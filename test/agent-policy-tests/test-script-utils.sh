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
## This script contains unit tests for
## modules/agent-policy/scripts/script-utils.sh
## This script is ran via test/agent-policy-tests/test-runner.sh
####################################################################

PROJECT_ID="test-project-id"
POLICY_ID="ops-agents-test-policy"
DESCRIPTION="an example test policy"
AGENT_RULES_JSON_BASIC="[{\"type\":\"metrics\"}]"
OS_TYPES_JSON_BASIC="[{\"short_name\":\"centos\",\"version\":\"8\"}]"
EMPTY_LIST_JSON="[]"
ETAG="db5c5a61-6a05-4f67-8f84-c89a654eb576"


# include functions to build gcloud command
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
UTILS_ABS_PATH="${SCRIPT_DIR}/../../modules/agent-policy/scripts/script-utils.sh"
# shellcheck disable=SC1090
source "$UTILS_ABS_PATH"


##############################################################
##  util functions                                          ##
##############################################################

# Params:
#   $1 = test name
#   $2 = expected (string)
#   $3 = actual (string)
# Compares the expected and actual values. Prints the result
# of the comparison, and prints a diff if the expected and actual
# values are differet.
function assert_equals() {
    local test_name="$1"
    local expected="$2"
    local actual="$3"
    # assert that the expected and actual are equal
    if [ "$expected" = "$actual" ]; then
        echo "===== $test_name: SUCCESS"
    else
        echo "===== $test_name: FAILURE"
        echo "=====   expected:"
        echo "=====      \"$expected\""
        echo "=====   actual:"
        echo "=====      \"$actual\""
    fi
}



##############################################################
##  get_create_command tests                                ##
##############################################################

function test_get_create_command_defaults() {
    local description=""
    local agent_rules_json="$AGENT_RULES_JSON_BASIC"
    local group_labels_json="$EMPTY_LIST_JSON"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="$EMPTY_LIST_JSON"
    local instances_json="$EMPTY_LIST_JSON"
    local expected_command
    local actual_command

    expected_command="gcloud alpha compute instances ops-agents"
    expected_command="$expected_command policies create ops-agents-test-policy"
    expected_command="$expected_command --agent-rules='type=metrics'"
    expected_command="$expected_command --os-types='version=8,short-name=centos'"
    expected_command="$expected_command --project='test-project-id' --quiet"
    actual_command="$(get_create_command "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json")"

    assert_equals "test_get_create_command_defaults" \
        "$expected_command" "$actual_command"
}

function test_get_create_command_description() {
    local description="$DESCRIPTION"
    local agent_rules_json="$AGENT_RULES_JSON_BASIC"
    local group_labels_json="$EMPTY_LIST_JSON"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="$EMPTY_LIST_JSON"
    local instances_json="$EMPTY_LIST_JSON"
    local expected_command
    local actual_command

    expected_command="gcloud alpha compute instances ops-agents"
    expected_command="$expected_command policies create ops-agents-test-policy"
    expected_command="$expected_command --description='an example test policy'"
    expected_command="$expected_command --agent-rules='type=metrics'"
    expected_command="$expected_command --os-types='version=8,short-name=centos'"
    expected_command="$expected_command --project='test-project-id' --quiet"
    actual_command="$(get_create_command "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json")"

    assert_equals "test_get_create_command_description" \
        "$expected_command" "$actual_command"
}

function test_get_create_command_agent_rules() {
    local description=""
    local agent_rules_json="[{\"enable_autoupgrade\":true,\"package_state\":\"installed\","
    agent_rules_json="${agent_rules_json}\"type\":\"logging\",\"version\":\"current-major\"},"
    agent_rules_json="${agent_rules_json}{\"type\":\"metrics\"}]"
    local group_labels_json="$EMPTY_LIST_JSON"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="$EMPTY_LIST_JSON"
    local instances_json="$EMPTY_LIST_JSON"
    local expected_command
    local actual_command

    expected_command="gcloud alpha compute instances ops-agents"
    expected_command="$expected_command policies create ops-agents-test-policy"
    expected_command="$expected_command --agent-rules='version=current-major,"
    expected_command="${expected_command}type=logging,enable-autoupgrade=true,"
    expected_command="${expected_command}package-state=installed;type=metrics'"
    expected_command="$expected_command --os-types='version=8,short-name=centos'"
    expected_command="$expected_command --project='test-project-id' --quiet"
    actual_command="$(get_create_command "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json")"

    assert_equals "test_get_create_command_agent_rules" \
        "$expected_command" "$actual_command"
}

function test_get_create_command_group_labels() {
    local description=""
    local agent_rules_json="$AGENT_RULES_JSON_BASIC"
    local group_labels_json="[[{\"name\":\"env\",\"value\":\"prod\"},"
    group_labels_json="${group_labels_json}{\"name\":\"product\",\"value\":\"myapp\"}],"
    group_labels_json="${group_labels_json}[{\"name\":\"env\",\"value\":\"staging\"},"
    group_labels_json="${group_labels_json}{\"name\":\"product\",\"value\":\"myapp\"}]]"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="$EMPTY_LIST_JSON"
    local instances_json="$EMPTY_LIST_JSON"
    local expected_command
    local actual_command

    expected_command="gcloud alpha compute instances ops-agents"
    expected_command="$expected_command policies create ops-agents-test-policy"
    expected_command="$expected_command --agent-rules='type=metrics'"
    expected_command="$expected_command --group-labels='env=prod,product=myapp;"
    expected_command="${expected_command}env=staging,product=myapp'"
    expected_command="$expected_command --os-types='version=8,short-name=centos'"
    expected_command="$expected_command --project='test-project-id' --quiet"
    actual_command="$(get_create_command "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json")"

    assert_equals "test_get_create_command_group_labels" \
        "$expected_command" "$actual_command"
}

function test_get_create_command_zones() {
    local description=""
    local agent_rules_json="$AGENT_RULES_JSON_BASIC"
    local group_labels_json="$EMPTY_LIST_JSON"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="[\"us-central1-c\",\"asia-northeast2-b\",\"europe-north1-b\"]"
    local instances_json="$EMPTY_LIST_JSON"
    local expected_command
    local actual_command

    expected_command="gcloud alpha compute instances ops-agents"
    expected_command="$expected_command policies create ops-agents-test-policy"
    expected_command="$expected_command --agent-rules='type=metrics'"
    expected_command="$expected_command --os-types='version=8,short-name=centos'"
    expected_command="$expected_command --zones='us-central1-c,"
    expected_command="${expected_command}asia-northeast2-b,europe-north1-b'"
    expected_command="$expected_command --project='test-project-id' --quiet"
    actual_command="$(get_create_command "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json")"

    assert_equals "test_get_create_command_zones" \
        "$expected_command" "$actual_command"
}

function test_get_create_command_instances() {
    local description=""
    local agent_rules_json="$AGENT_RULES_JSON_BASIC"
    local group_labels_json="$EMPTY_LIST_JSON"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="$EMPTY_LIST_JSON"
    local instances_json="[\"zones/us-central1-a/instances/test-instance\"]"
    local expected_command
    local actual_command

    expected_command="gcloud alpha compute instances ops-agents"
    expected_command="$expected_command policies create ops-agents-test-policy"
    expected_command="$expected_command --agent-rules='type=metrics'"
    expected_command="$expected_command --os-types='version=8,short-name=centos'"
    expected_command="$expected_command --instances='zones/us-central1-a/"
    expected_command="${expected_command}instances/test-instance'"
    expected_command="$expected_command --project='test-project-id' --quiet"
    actual_command="$(get_create_command "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json")"

    assert_equals "test_get_create_command_instances" \
        "$expected_command" "$actual_command"
}



##############################################################
##  get_update_command tests                                ##
##############################################################

function test_get_update_command_clear_filters() {
    local description=""
    local agent_rules_json="$AGENT_RULES_JSON_BASIC"
    local group_labels_json="$EMPTY_LIST_JSON"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="$EMPTY_LIST_JSON"
    local instances_json="$EMPTY_LIST_JSON"
    local expected_command
    local actual_command

    expected_command="gcloud alpha compute instances ops-agents"
    expected_command="$expected_command policies update ops-agents-test-policy"
    expected_command="$expected_command --agent-rules='type=metrics'"
    expected_command="$expected_command --os-types='version=8,short-name=centos'"
    expected_command="$expected_command --clear-group-labels"
    expected_command="$expected_command --clear-zones"
    expected_command="$expected_command --clear-instances"
    expected_command="$expected_command --etag='db5c5a61-6a05-4f67-8f84-c89a654eb576'"
    expected_command="$expected_command --project='test-project-id' --quiet"
    actual_command="$(get_update_command "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json" "$ETAG")"

    assert_equals "test_get_update_command_clear_filters" \
        "$expected_command" "$actual_command"
}



##############################################################
##  get_describe_command tests                              ##
##############################################################

function test_get_describe_command() {
    local expected_command
    local actual_command

    expected_command="gcloud alpha compute instances ops-agents"
    expected_command="$expected_command policies describe ops-agents-test-policy"
    expected_command="$expected_command --project='test-project-id' --quiet"
    actual_command="$(get_describe_command "$PROJECT_ID" "$POLICY_ID")"

    assert_equals "test_get_describe_command" \
        "$expected_command" "$actual_command"
}


##############################################################
##  get_delete_command tests                                ##
##############################################################

function test_get_delete_command() {
    local expected_command
    local actual_command

    expected_command="gcloud alpha compute instances ops-agents"
    expected_command="$expected_command policies delete ops-agents-test-policy"
    expected_command="$expected_command --project='test-project-id' --quiet"
    actual_command="$(get_delete_command "$PROJECT_ID" "$POLICY_ID")"

    assert_equals "test_get_describe_command" \
        "$expected_command" "$actual_command"
}


##############################################################
##  get_etag tests                                          ##
##############################################################

function test_get_etag_simple() {
    local describe_output="etag: db5c5a61-6a05-4f67-8f84-c89a654eb576"
    local expected_etag="$ETAG"
    local actual_etag
    actual_etag="$(get_etag "$describe_output")"

    assert_equals "test_get_etag_simple" \
        "$expected_etag" "$actual_etag"
}

function test_get_etag_detailed() {
    local describe_output="agent_rules: - enable_autoupgrade:
        true package_state: installed
        type: logging
        version: 1.*.*
        assignment:
        group_labels: []
        instances: []
        os_types:
        - short_name: debian
          version: '10'
        zones: []
        create_time: '2020-08-13T17:53:34.607Z'
        description: None
        etag: db5c5a61-6a05-4f67-8f84-c89a654eb576
        id: projects/981664706940/guestPolicies/ops-agents-test-policy-simple
        update_time: '2020-08-13T17:54:27.267Z'"
    local expected_etag="$ETAG"
    local actual_etag
    actual_etag="$(get_etag "$describe_output")"

    assert_equals "test_get_etag_detailed" \
        "$expected_etag" "$actual_etag"
}



##############################################################
##  functions to run tests                                  ##
##############################################################

function test_get_create_command() {
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "╠═ Running get_create_command tests                         ═╣"
    echo "╚════════════════════════════════════════════════════════════╝"
    test_get_create_command_defaults
    test_get_create_command_description
    test_get_create_command_agent_rules
    test_get_create_command_group_labels
    test_get_create_command_zones
    test_get_create_command_instances
    echo ""
}

function test_get_update_command() {
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "╠═ Running get_update_command tests                         ═╣"
    echo "╚════════════════════════════════════════════════════════════╝"
    test_get_update_command_clear_filters
    echo ""
}

function test_get_describe() {
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "╠═ Running get_describe_command tests                       ═╣"
    echo "╚════════════════════════════════════════════════════════════╝"
    test_get_describe_command
    echo ""
}

function test_get_delete() {
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "╠═ Running get_delete_command tests                         ═╣"
    echo "╚════════════════════════════════════════════════════════════╝"
    test_get_delete_command
    echo ""
}

function test_get_etag() {
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "╠═ Running get_etag tests                                   ═╣"
    echo "╚════════════════════════════════════════════════════════════╝"
    test_get_etag_simple
    test_get_etag_detailed
    echo ""
}



##############################################################
##  Run tests                                               ##
##############################################################
test_get_create_command
test_get_update_command
test_get_describe
test_get_delete
test_get_etag
