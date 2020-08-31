#!/usr/bin/env bash

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

####################################################################
## This script contains integration tests that test udate behavior.
## It takes in two arguments: PROJECT_ID and POLICY_ID
## This script is ran via test/agent-policy-tests/test-runner.sh
####################################################################

PROJECT_ID="$1"
POLICY_ID="$2"
DESCRIPTION=""
AGENT_RULES='agent_rules=[{"type" : "logging", "version" : "1.*.*"}]'
GROUP_LABELS=""
OS_TYPES='os_types=[{"short_name" : "debian", "version" : "10"}]'
ZONES=""
INSTANCES=""
APPLY="apply"
DESTROY="destroy"
ORIGINAL_OUTPUT="agent_rules:
- enable_autoupgrade: true
  package_state: installed
  type: logging
  version: 1.*.*
assignment:
  group_labels: []
  instances: []
  os_types:
  - short_name: debian
    version: '10'
  zones: []
create_time: '2020-08-14T19:11:32.114Z'
description: None
etag: 2d089dc5-56e2-4f55-a24d-6fbbb6d3c714
id: projects/0123456789/guestPolicies/ops-agents-test-policy-update
update_time: '2020-08-14T19:11:32.114Z'"


# include functions to build gcloud command
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
UTILS_ABS_PATH="${SCRIPT_DIR}/../../../modules/agent-policy/scripts/script-utils.sh"
# shellcheck disable=SC1090
source "$UTILS_ABS_PATH"
# run commands from correct location
cd "$SCRIPT_DIR" || exit 1

DESCRIBE_COMMAND="$(get_describe_command "$PROJECT_ID" "$POLICY_ID")"
DELETE_COMMAND="$(get_delete_command "$PROJECT_ID" "$POLICY_ID")"


##############################################################
##  util functions                                          ##
##############################################################

# Params:
#   $1 = output of describe command
# Return:
#   A string that does not contain lines with
#   create_time:, etag:, id:, and update_time:
function format_string() {
    local output="$1"
    output=$(sed '/create_time:/d' <<< "$output")
    output=$(sed '/etag:/d' <<< "$output")
    output=$(sed '/id:/d' <<< "$output")
    output=$(sed '/update_time:/d' <<< "$output")
    echo "$output"
}

# Params:
#   $1 = test name
#   $2 = expected (string)
#   $3 = actual (string)
#   $4 = terraform output
# Compares the states of expected and actual values. Does not compare
# create time, etag, id, and update time. Prints the result
# of the comparison, and prints a diff if the expected and actual
# values are differet.
function assert_state_equals() {
    local test_name="$1"
    local terraform_output="$4"
    local expected
    local actual
    expected=$(format_string "$2")
    actual=$(format_string "$3")

    # assert that the expected and actual are equal
    if [ "$expected" = "$actual" ]; then
        echo "===== $test_name: SUCCESS"
    else
        echo "===== $test_name: FAILURE"
        echo "=====   expected:"
        echo "=====      \"$expected\""
        echo "=====   actual:"
        echo "=====      \"$actual\""
        echo "=====   terraform output:"
        echo "=====      $terraform_output"
    fi
}

# Params:
#   $1 = flag value
# Return:
#   An empty string if the flag value is empty, otherwise returns the
#   appropriate Terrafomr var flag
function get_terraform_var_flag() {
    local flag_value="$1"
    local flag=""
    if [ -n "$flag_value" ]; then
        # flag value is not empty
        flag=" -var='$flag_value'"
    fi
    echo "$flag"
}

# Params:
#   $1 = action
#   $2 = description
#   $3 = agent rules
#   $4 = group labels
#   $5 = os types
#   $6 = zones
#   $7 = instances
# Compares the expected and actual values. Prints the result
# of the comparison, and prints a diff if the expected and actual
# values are differet.
function get_terraform_command() {
    local project_id
    local policy_id
    local project_id_flag
    local policy_id_flag
    local description_flag
    local agent_rules_flag
    local group_labels_flag
    local os_types_flag
    local zones_flag
    local instances_flag

    project_id="project_id=$PROJECT_ID"
    policy_id="policy_id=$POLICY_ID"
    local action="$1"
    local description="$2"
    local agent_rules="$3"
    local group_labels="$4"
    local os_types="$5"
    local zones="$6"
    local instances="$7"

    project_id_flag="$(get_terraform_var_flag "$project_id")"
    policy_id_flag="$(get_terraform_var_flag "$policy_id")"
    description_flag="$(get_terraform_var_flag "$description")"
    agent_rules_flag="$(get_terraform_var_flag "$agent_rules")"
    group_labels_flag="$(get_terraform_var_flag "$group_labels")"
    os_types_flag="$(get_terraform_var_flag "$os_types")"
    zones_flag="$(get_terraform_var_flag "$zones")"
    instances_flag="$(get_terraform_var_flag "$instances")"

    local command="terraform $action -auto-approve"
    command="$command$project_id_flag$policy_id_flag$description_flag"
    command="$command$agent_rules_flag$group_labels_flag$os_types_flag"
    command="$command$zones_flag$instances_flag"
    echo "$command"
}



##############################################################
##  Integration update tests                                ##
##############################################################

# Params:
#   $1 = test name
#   $2 = expected result
#   $3 = description
#   $4 = agent rules
#   $5 = group labels
#   $6 = os types
#   $7 = zones
#   $8 = instances
# Applies the given description, agent rules, group labels, os types,
# zones, and instances to the Terraform module, and compares the result
# of the update with the expected result.
function test_state() {
    local test_name="$1"
    local expected_output="$2"
    local description="$3"
    local agent_rules="$4"
    local group_labels="$5"
    local os_types="$6"
    local zones="$7"
    local instances="$8"
    local terraform_command
    local terraform_result
    local actual_output

    terraform_command="$(get_terraform_command "$APPLY" "$description" \
        "$agent_rules" "$group_labels" "$os_types" "$zones" "$instances")"
    terraform_result=$(eval "$terraform_command" 2>&1)
    actual_output=$(eval "$DESCRIBE_COMMAND" 2>&1)
    assert_state_equals "$test_name" "$expected_output" \
        "$actual_output" "$terraform_result"
}

function test_original_state() {
    test_state "test_original_state" "$ORIGINAL_OUTPUT" "$DESCRIPTION" \
        "$AGENT_RULES" "$GROUP_LABELS" "$OS_TYPES" "$ZONES" "$INSTANCES"
}

function test_agent_rules_update() {
    local agent_rules='agent_rules=[{"type" : "metrics", "version" : "6.*.*"}]'
    local expected_output="agent_rules:
- enable_autoupgrade: true
  package_state: installed
  type: metrics
  version: 6.*.*
assignment:
  group_labels: []
  instances: []
  os_types:
  - short_name: debian
    version: '10'
  zones: []
create_time: '2020-08-14T19:11:32.114Z'
description: None
etag: 2d089dc5-56e2-4f55-a24d-6fbbb6d3c714
id: projects/0123456789/guestPolicies/ops-agents-test-policy-update
update_time: '2020-08-14T19:11:32.114Z'"
    test_state "test_agent_rules_update" "$expected_output" "$DESCRIPTION" \
        "$agent_rules" "$GROUP_LABELS" "$OS_TYPES" "$ZONES" "$INSTANCES"
}

function test_group_labels_update() {
    local group_labels='group_labels=[[{"name" : "env", "value" : "prod"}]]'
    local expected_output="agent_rules:
- enable_autoupgrade: true
  package_state: installed
  type: logging
  version: 1.*.*
assignment:
  group_labels:
  - env: prod
  instances: []
  os_types:
  - short_name: debian
    version: '10'
  zones: []
create_time: '2020-08-14T19:11:32.114Z'
description: None
etag: 2d089dc5-56e2-4f55-a24d-6fbbb6d3c714
id: projects/0123456789/guestPolicies/ops-agents-test-policy-update
update_time: '2020-08-14T19:11:32.114Z'"
    test_state "test_group_labels_update" "$expected_output" "$DESCRIPTION" \
        "$AGENT_RULES" "$group_labels" "$OS_TYPES" "$ZONES" "$INSTANCES"
}

function test_os_types_update() {
    local os_types='os_types=[{"short_name" : "rhel", "version" : "8.2"}]'
    local expected_output="agent_rules:
- enable_autoupgrade: true
  package_state: installed
  type: logging
  version: 1.*.*
assignment:
  group_labels: []
  instances: []
  os_types:
  - short_name: rhel
    version: '8.2'
  zones: []
create_time: '2020-08-14T19:11:32.114Z'
description: None
etag: 2d089dc5-56e2-4f55-a24d-6fbbb6d3c714
id: projects/0123456789/guestPolicies/ops-agents-test-policy-update
update_time: '2020-08-14T19:11:32.114Z'"
    test_state "test_os_types_update" "$expected_output" "$DESCRIPTION" \
        "$AGENT_RULES" "$GROUP_LABELS" "$os_types" "$ZONES" "$INSTANCES"
}

function test_zones_update() {
    local zones='zones=["us-central1-c", "asia-northeast2-b"]'
    local expected_output="agent_rules:
- enable_autoupgrade: true
  package_state: installed
  type: logging
  version: 1.*.*
assignment:
  group_labels: []
  instances: []
  os_types:
  - short_name: debian
    version: '10'
  zones:
  - us-central1-c
  - asia-northeast2-b
create_time: '2020-08-14T19:11:32.114Z'
description: None
etag: 2d089dc5-56e2-4f55-a24d-6fbbb6d3c714
id: projects/0123456789/guestPolicies/ops-agents-test-policy-update
update_time: '2020-08-14T19:11:32.114Z'"
    test_state "test_zones_update" "$expected_output" "$DESCRIPTION" \
        "$AGENT_RULES" "$GROUP_LABELS" "$OS_TYPES" "$zones" "$INSTANCES"
}

function test_instances_update() {
    local instances='instances=["zones/us-central1-a/instances/test-instance"]'
    local expected_output="agent_rules:
- enable_autoupgrade: true
  package_state: installed
  type: logging
  version: 1.*.*
assignment:
  group_labels: []
  instances:
  - zones/us-central1-a/instances/test-instance
  os_types:
  - short_name: debian
    version: '10'
  zones: []
create_time: '2020-08-14T19:11:32.114Z'
description: None
etag: 2d089dc5-56e2-4f55-a24d-6fbbb6d3c714
id: projects/0123456789/guestPolicies/ops-agents-test-policy-update
update_time: '2020-08-14T19:11:32.114Z'"
    test_state "test_zones_update" "$expected_output" "$DESCRIPTION" \
        "$AGENT_RULES" "$GROUP_LABELS" "$OS_TYPES" "$ZONES" "$instances"
}

function test_description_update() {
    local description='description=a test description'
    local expected_output="agent_rules:
- enable_autoupgrade: true
  package_state: installed
  type: logging
  version: 1.*.*
assignment:
  group_labels: []
  instances: []
  os_types:
  - short_name: debian
    version: '10'
  zones: []
create_time: '2020-08-14T19:11:32.114Z'
description: a test description
etag: 2d089dc5-56e2-4f55-a24d-6fbbb6d3c714
id: projects/0123456789/guestPolicies/ops-agents-test-policy-update
update_time: '2020-08-14T19:11:32.114Z'"
    test_state "test_description_update" "$expected_output" "$description" \
        "$AGENT_RULES" "$GROUP_LABELS" "$OS_TYPES" "$ZONES" "$INSTANCES"
}



##############################################################
##  Functions to run integration update tests               ##
##############################################################

function test_agent_rules() {
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "╠═ Testing agent rules update                               ═╣"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo "===== Updating agent rules..."
    test_agent_rules_update
    echo "===== Reverting agent rules update..."
    test_original_state
}

function test_group_labels() {
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "╠═ Testing group labels update                              ═╣"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo "===== Updating group labels..."
    test_group_labels_update
    echo "===== Clearing group labels..."
    test_original_state
}

function test_os_types() {
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "╠═ Testing os types update                                  ═╣"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo "===== Updating os types..."
    test_os_types_update
    echo "===== Reverting os types update..."
    test_original_state
}

function test_zones() {
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "╠═ Testing zones update                                     ═╣"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo "===== Updating zones..."
    test_zones_update
    echo "===== Clearing zones..."
    test_original_state
}

function test_instances() {
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "╠═ Testing instances update                                 ═╣"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo "===== Updating instances..."
    test_instances_update
    echo "===== Clearing instances..."
    test_original_state
}

function test_description() {
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "╠═ Testing description update                               ═╣"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo "===== Updating description..."
    test_description_update
}

function run_update_tests() {
    test_agent_rules
    test_group_labels
    test_os_types
    test_zones
    test_instances
    test_description
}



##############################################################
##  Test environment functions                              ##
##############################################################

function terraform_setup() {
    local terraform_init_output
    echo "===== Initializing module..."
    terraform_init_output=$(terraform init 2>&1)
    return_code="$?"
    if [ "$return_code" -eq 0 ]; then
        echo "=====   SUCCESS"
    else
        echo "=====   FAILED to initialize module"
        echo "$terraform_init_output"
        exit 1
    fi
    echo "===== Creating module..."
    test_original_state
}

function setup() {
    local return_code
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "╠═ Running test setup                                       ═╣"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo "===== Checking if $POLICY_ID exists in $PROJECT_ID..."
    echo "===== Running describe command: $DESCRIBE_COMMAND"
    eval "$DESCRIBE_COMMAND" >/dev/null 2>&1
    return_code="$?"
    echo "===== Return code of describe command: $return_code"
    if [ "$return_code" -eq 0 ]; then
        echo "===== $POLICY_ID exists in $PROJECT_ID, deleting..."
        echo "===== Running delete command: $DELETE_COMMAND"
        eval "$DELETE_COMMAND"
        return_code="$?"
        echo "===== Return code of delete command: $return_code"
    else
        echo "===== $POLICY_ID does not exist in $PROJECT_ID"
    fi
    terraform_setup
}

function teardown() {
    local destroy_command
    local destroy_output
    local return_code
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "╠═ Running test teardown                                    ═╣"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo "===== Destroying module..."
    destroy_command="$(get_terraform_command "$DESTROY" "$DESCRIPTION" \
        "$AGENT_RULES" "$GROUP_LABELS" "$OS_TYPES" "$ZONES" "$INSTANCES")"
    destroy_output=$(eval "$destroy_command" 2>&1)
    destroy_return_code="$?"
    eval "$DESCRIBE_COMMAND" >/dev/null 2>&1
    describe_return_code="$?"
    if [ "$destroy_return_code" -eq 0 ] && [ "$describe_return_code" -eq 1 ]; then
        echo "=====   SUCCESS"
    else
        echo "=====   FAILED to destroy module"
        echo "$destroy_output"
        exit 1
    fi
}



##############################################################
##  Run tests                                               ##
##############################################################
setup
run_update_tests
teardown
