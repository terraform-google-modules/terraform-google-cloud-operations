 #!/usr/bin/env bash

# Copyright 2018 Google LLC
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

PROJECT_ID="test-project-id"
POLICY_ID="ops-agents-test-policy"
DESCRIPTION="an example test policy"
AGENT_RULES_JSON_BASIC="[{\"type\":\"metrics\"}]"
OS_TYPES_JSON_BASIC="[{\"short_name\":\"centos\",\"version\":\"8\"}]"
EMPTY_LIST_JSON="[]"
CREATE="create"
UPDATE="update"

# include functions to build gcloud command
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${script_dir}/../modules/agent-policy/scripts/create-update-utils.sh"



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
        echo "=====      $expected"
        echo "=====   actual:"
        echo "=====      $actual"
    fi
}



##############################################################
##  get_upsert_command create tests                         ##
##############################################################

function test_get_upsert_command_create_defaults() {
    local description=""
    local agent_rules_json="$AGENT_RULES_JSON_BASIC"
    local group_labels_json="$EMPTY_LIST_JSON"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="$EMPTY_LIST_JSON"
    local instances_json="$EMPTY_LIST_JSON"

    local expected_command="$(echo "gcloud alpha compute instances ops-agents" \
        "policies create ops-agents-test-policy" \
        "--agent-rules=\"type=metrics\"" \
        "--os-types=\"version=8,short-name=centos\"" \
        "--project=\"test-project-id\"")"
    local actual_command="$(get_upsert_command $CREATE "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json")"

    assert_equals "test_get_upsert_command_create_defaults" \
        "$expected_command" "$actual_command"
}

function test_get_upsert_command_create_description() {
    local description="$DESCRIPTION"
    local agent_rules_json="$AGENT_RULES_JSON_BASIC"
    local group_labels_json="$EMPTY_LIST_JSON"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="$EMPTY_LIST_JSON"
    local instances_json="$EMPTY_LIST_JSON"

    local expected_command="$(echo "gcloud alpha compute instances ops-agents" \
        "policies create ops-agents-test-policy" \
        "--description=\"an example test policy\"" \
        "--agent-rules=\"type=metrics\"" \
        "--os-types=\"version=8,short-name=centos\"" \
        "--project=\"test-project-id\"")"
    local actual_command="$(get_upsert_command $CREATE "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json")"

    assert_equals "test_get_upsert_command_create_description" \
        "$expected_command" "$actual_command"
}

function test_get_upsert_command_create_agent_rules() {
    local description=""
    local agent_rules_json="[{\"enable_autoupgrade\":true,\"package_state\":\"installed\",\"type\":\"logging\",\"version\":\"current-major\"},{\"type\":\"metrics\"}]"
    local group_labels_json="$EMPTY_LIST_JSON"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="$EMPTY_LIST_JSON"
    local instances_json="$EMPTY_LIST_JSON"

    local expected_command="$(echo "gcloud alpha compute instances ops-agents" \
        "policies create ops-agents-test-policy" \
        "--agent-rules=\"version=current-major,type=logging,enable-autoupgrade=true,package-state=installed;type=metrics\"" \
        "--os-types=\"version=8,short-name=centos\"" \
        "--project=\"test-project-id\"")"
    local actual_command="$(get_upsert_command $CREATE "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json")"

    assert_equals "test_get_upsert_command_create_agent_rules" \
        "$expected_command" "$actual_command"
}

function test_get_upsert_command_create_group_labels() {
    local description=""
    local agent_rules_json="$AGENT_RULES_JSON_BASIC"
    local group_labels_json="[[{\"name\":\"env\",\"value\":\"prod\"},{\"name\":\"product\",\"value\":\"myapp\"}],[{\"name\":\"env\",\"value\":\"staging\"},{\"name\":\"product\",\"value\":\"myapp\"}]]"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="$EMPTY_LIST_JSON"
    local instances_json="$EMPTY_LIST_JSON"

    local expected_command="$(echo "gcloud alpha compute instances ops-agents" \
        "policies create ops-agents-test-policy" \
        "--agent-rules=\"type=metrics\"" \
        "--group-labels=\"env=prod,product=myapp;env=staging,product=myapp\"" \
        "--os-types=\"version=8,short-name=centos\"" \
        "--project=\"test-project-id\"")"
    local actual_command="$(get_upsert_command $CREATE "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json")"

    assert_equals "test_get_upsert_command_create_group_labels" \
        "$expected_command" "$actual_command"
}

function test_get_upsert_command_create_zones() {
    local description=""
    local agent_rules_json="$AGENT_RULES_JSON_BASIC"
    local group_labels_json="$EMPTY_LIST_JSON"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="[\"us-central1-c\",\"asia-northeast2-b\",\"europe-north1-b\"]"
    local instances_json="$EMPTY_LIST_JSON"

    local expected_command="$(echo "gcloud alpha compute instances ops-agents" \
        "policies create ops-agents-test-policy" \
        "--agent-rules=\"type=metrics\"" \
        "--os-types=\"version=8,short-name=centos\"" \
        "--zones=\"us-central1-c,asia-northeast2-b,europe-north1-b\"" \
        "--project=\"test-project-id\"")"
    local actual_command="$(get_upsert_command $CREATE "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json")"

    assert_equals "test_get_upsert_command_create_zones" \
        "$expected_command" "$actual_command"
}

function test_get_upsert_command_create_instances() {
    local description=""
    local agent_rules_json="$AGENT_RULES_JSON_BASIC"
    local group_labels_json="$EMPTY_LIST_JSON"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="$EMPTY_LIST_JSON"
    local instances_json="[\"zones/us-central1-a/instances/test-instance\"]"

    local expected_command="$(echo "gcloud alpha compute instances ops-agents" \
        "policies create ops-agents-test-policy" \
        "--agent-rules=\"type=metrics\"" \
        "--os-types=\"version=8,short-name=centos\"" \
        "--instances=\"zones/us-central1-a/instances/test-instance\"" \
        "--project=\"test-project-id\"")"
    local actual_command="$(get_upsert_command $CREATE "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json")"

    assert_equals "test_get_upsert_command_create_instances" \
        "$expected_command" "$actual_command"
}



##############################################################
##  get_upsert_command update tests                         ##
##############################################################

function test_get_upsert_command_update_clear_filters() {
    local description=""
    local agent_rules_json="$AGENT_RULES_JSON_BASIC"
    local group_labels_json="$EMPTY_LIST_JSON"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="$EMPTY_LIST_JSON"
    local instances_json="$EMPTY_LIST_JSON"

    local expected_command="$(echo "gcloud alpha compute instances ops-agents" \
        "policies update ops-agents-test-policy" \
        "--agent-rules=\"type=metrics\"" \
        "--os-types=\"version=8,short-name=centos\"" \
        "--clear-group-labels --clear-zones --clear-instances" \
        "--project=\"test-project-id\"")"
    local actual_command="$(get_upsert_command $UPDATE "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json")"

    assert_equals "test_get_upsert_command_update_clear_filters" \
        "$expected_command" "$actual_command"
}



##############################################################
##  get_describe_command tests                              ##
##############################################################

function test_get_describe_command() {
    local description=""
    local agent_rules_json="$AGENT_RULES_JSON_BASIC"
    local group_labels_json="$EMPTY_LIST_JSON"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="$EMPTY_LIST_JSON"
    local instances_json="$EMPTY_LIST_JSON"

    local expected_command="$(echo "gcloud alpha compute instances ops-agents" \
        "policies describe ops-agents-test-policy" \
        "--project=\"test-project-id\"")"
    local actual_command="$(get_describe_command "$PROJECT_ID" "$POLICY_ID")"

    assert_equals "test_get_describe_command" \
        "$expected_command" "$actual_command"
}



##############################################################
##  functions to run tests                                  ##
##############################################################

function test_get_upsert_command_create() {
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "╠═ Running get_upsert_command create tests                  ═╣"
    echo "╚════════════════════════════════════════════════════════════╝"

    test_get_upsert_command_create_defaults
    test_get_upsert_command_create_description
    test_get_upsert_command_create_agent_rules
    test_get_upsert_command_create_group_labels
    test_get_upsert_command_create_zones
    test_get_upsert_command_create_instances

    echo ""
}

function test_get_upsert_command_update() {
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "╠═ Running get_upsert_command update tests                  ═╣"
    echo "╚════════════════════════════════════════════════════════════╝"

    test_get_upsert_command_update_clear_filters

    echo ""
}

function test_get_describe() {
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "╠═ Running get_describe_command tests                       ═╣"
    echo "╚════════════════════════════════════════════════════════════╝"

    test_get_describe_command

    echo ""
}



# run tests
test_get_upsert_command_create
test_get_upsert_command_update
test_get_describe