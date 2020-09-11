#! /bin/bash
# Copyright 2020 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

SCRIPT_DIR="$( realpath "$( dirname "${BASH_SOURCE[0]}" )" )"
TF_VARS_FILE="${SCRIPT_DIR}/../fixtures/agent_policy_update_example/terraform.tfvars"
ORIGINAL_CONFIG="$(<"$TF_VARS_FILE")"

set -eu
source /usr/local/bin/task_helper_functions.sh


# Params:
#   $1 = string pattern before replacement
#   $2 = string pattern after replacement
#   $3 = replacement string
# This function replaces anything in between the string
# patterns with the given replacement string
function replace_between() {
    local file="$ORIGINAL_CONFIG"
    local upper=${file%$1 *} # removes everything after $1
    local lower=${file#*$2 } # removes everything before $2
    echo "$upper$1 = $3" > "$TF_VARS_FILE"
    echo "$2 $lower" >> "$TF_VARS_FILE"
}

# Params:
#   $1 = string pattern before replacement
#   $2 = replacement string
# This function replaces anything after the string pattern
# with the given replacement string
function replace_after() {
    local file="$ORIGINAL_CONFIG"
    local upper=${file%$1 *} # removes everything after $1
    echo "$upper$1 = $2" > "$TF_VARS_FILE"
}

function restore_original_config() {
    echo "$ORIGINAL_CONFIG" > "$TF_VARS_FILE"
}

function test_original_state() {
    restore_original_config
    kitchen_do converge agent-policy-update-example-default
    kitchen_do verify agent-policy-update-example-default
}

function test_agent_rules_update() {
    local agent_rules=$'[{\n type = "metrics" \n package_state = "removed" \n '
    agent_rules="$agent_rules"$'version = "latest" \n enable_autoupgrade = false \n }]'
    replace_between "agent_rules" "group_labels" "$agent_rules"
    kitchen_do converge agent-policy-update-example-default
    kitchen_do verify agent-policy-update-example-default
}

function test_agent_rules() {
    test_agent_rules_update
    test_original_state
}

function test_group_labels_update() {
    local group_labels=$'[{\n env = "prod" \n}]'
    replace_between "group_labels" "os_types" "$group_labels"
    kitchen_do converge agent-policy-update-example-default
    kitchen_do verify agent-policy-update-example-default
}

function test_group_labels() {
    test_group_labels_update
    test_original_state
}

function test_os_types_update() {
    local os_types=$'[{\n "short_name" = "sles" \n "version" = "15.1" \n}]'
    replace_between "os_types" "zones" "$os_types"
    kitchen_do converge agent-policy-update-example-default
    kitchen_do verify agent-policy-update-example-default
}

function test_os_types() {
    test_os_types_update
    test_original_state
}

function test_zones_update() {
    local zones='["us-central1-c", "asia-northeast2-b"]'
    replace_between "zones" "instances" "$zones"
    kitchen_do converge agent-policy-update-example-default
    kitchen_do verify agent-policy-update-example-default
}

function test_zones() {
    test_zones_update
    test_original_state
}

function test_instances_update() {
    local instances='["zones/us-central1-a/instances/test-instance"]'
    replace_after "instances" "$instances"
    kitchen_do converge agent-policy-update-example-default
    kitchen_do verify agent-policy-update-example-default
}

function test_instances() {
    test_instances_update
    test_original_state
}

function test_description_update() {
    local description=$'"a test description"'
    replace_between "description" "agent_rules" "$description"
    kitchen_do converge agent-policy-update-example-default
    kitchen_do verify agent-policy-update-example-default
}

function test_description() {
    test_description_update
}

function run_integration_update_tests() {
    source_test_env
    init_credentials

    kitchen_do create agent-policy-update-example-default
    test_original_state

    test_agent_rules
    test_group_labels
    test_os_types
    test_zones
    test_instances
    test_description

    restore_original_config
}

run_integration_update_tests
