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
## This script is ran via `make docker_test_bats`
####################################################################

PROJECT_ID="test-project-id"
POLICY_ID="ops-agents-test-policy"
DESCRIPTION="an example test policy"
AGENT_RULES_JSON_BASIC="[{\"type\":\"metrics\"}]"
OS_TYPES_JSON_BASIC="[{\"short_name\":\"centos\",\"version\":\"8\"}]"
EMPTY_LIST_JSON="[]"
ETAG="db5c5a61-6a05-4f67-8f84-c89a654eb576"

load "/usr/local/bats-support/load.bash"
load "/usr/local/bats-assert/load.bash"


# Setup before every test
setup() {
    SCRIPT_DIR="${BATS_TEST_DIRNAME%/}"
    UTILS_ABS_PATH="${SCRIPT_DIR}/../../modules/agent-policy/scripts/script-utils.sh"
    source "$UTILS_ABS_PATH"
}


##############################################################
##  get_create_command tests                                ##
##############################################################

@test "Tests get_create_command with defaults" {
    local description=""
    local agent_rules_json="$AGENT_RULES_JSON_BASIC"
    local group_labels_json="$EMPTY_LIST_JSON"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="$EMPTY_LIST_JSON"
    local instances_json="$EMPTY_LIST_JSON"

    local expected_command="gcloud alpha compute instances ops-agents"
    expected_command="$expected_command policies create ops-agents-test-policy"
    expected_command="$expected_command --agent-rules='type=metrics'"
    expected_command="$expected_command --os-types='version=8,short-name=centos'"
    expected_command="$expected_command --project='test-project-id' --quiet"

    run get_create_command "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json"

    assert_equal "$output" "$expected_command"
}

@test "Tests get_create_command with description" {
    local description="$DESCRIPTION"
    local agent_rules_json="$AGENT_RULES_JSON_BASIC"
    local group_labels_json="$EMPTY_LIST_JSON"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="$EMPTY_LIST_JSON"
    local instances_json="$EMPTY_LIST_JSON"

    local expected_command="gcloud alpha compute instances ops-agents"
    expected_command="$expected_command policies create ops-agents-test-policy"
    expected_command="$expected_command --description='an example test policy'"
    expected_command="$expected_command --agent-rules='type=metrics'"
    expected_command="$expected_command --os-types='version=8,short-name=centos'"
    expected_command="$expected_command --project='test-project-id' --quiet"

    run get_create_command "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json"

    assert_equal "$output" "$expected_command"
}

@test "Tests get_create_command with agent_rules" {
    local description=""
    local agent_rules_json="[{\"enable_autoupgrade\":true,\"package_state\":\"installed\","
    agent_rules_json="${agent_rules_json}\"type\":\"logging\",\"version\":\"current-major\"},"
    agent_rules_json="${agent_rules_json}{\"type\":\"metrics\"}]"
    local group_labels_json="$EMPTY_LIST_JSON"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="$EMPTY_LIST_JSON"
    local instances_json="$EMPTY_LIST_JSON"

    local expected_command="gcloud alpha compute instances ops-agents"
    expected_command="$expected_command policies create ops-agents-test-policy"
    expected_command="$expected_command --agent-rules='version=current-major,"
    expected_command="${expected_command}type=logging,enable-autoupgrade=true,"
    expected_command="${expected_command}package-state=installed;type=metrics'"
    expected_command="$expected_command --os-types='version=8,short-name=centos'"
    expected_command="$expected_command --project='test-project-id' --quiet"

    run get_create_command "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json"

    assert_equal "$output" "$expected_command"
}

@test "Tests get_create_command with group_labels" {
    local description=""
    local agent_rules_json="$AGENT_RULES_JSON_BASIC"
    local group_labels_json="[[{\"name\":\"env\",\"value\":\"prod\"},"
    group_labels_json="${group_labels_json}{\"name\":\"product\",\"value\":\"myapp\"}],"
    group_labels_json="${group_labels_json}[{\"name\":\"env\",\"value\":\"staging\"},"
    group_labels_json="${group_labels_json}{\"name\":\"product\",\"value\":\"myapp\"}]]"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="$EMPTY_LIST_JSON"
    local instances_json="$EMPTY_LIST_JSON"

    local expected_command="gcloud alpha compute instances ops-agents"
    expected_command="$expected_command policies create ops-agents-test-policy"
    expected_command="$expected_command --agent-rules='type=metrics'"
    expected_command="$expected_command --group-labels='env=prod,product=myapp;"
    expected_command="${expected_command}env=staging,product=myapp'"
    expected_command="$expected_command --os-types='version=8,short-name=centos'"
    expected_command="$expected_command --project='test-project-id' --quiet"

    run get_create_command "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json"

    assert_equal "$output" "$expected_command"
}

@test "Tests get_create_command with zones" {
    local description=""
    local agent_rules_json="$AGENT_RULES_JSON_BASIC"
    local group_labels_json="$EMPTY_LIST_JSON"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="[\"us-central1-c\",\"asia-northeast2-b\",\"europe-north1-b\"]"
    local instances_json="$EMPTY_LIST_JSON"

    local expected_command="gcloud alpha compute instances ops-agents"
    expected_command="$expected_command policies create ops-agents-test-policy"
    expected_command="$expected_command --agent-rules='type=metrics'"
    expected_command="$expected_command --os-types='version=8,short-name=centos'"
    expected_command="$expected_command --zones='us-central1-c,"
    expected_command="${expected_command}asia-northeast2-b,europe-north1-b'"
    expected_command="$expected_command --project='test-project-id' --quiet"

    run get_create_command "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json"

    assert_equal "$output" "$expected_command"
}

@test "Tests get_command_create with instances" {
    local description=""
    local agent_rules_json="$AGENT_RULES_JSON_BASIC"
    local group_labels_json="$EMPTY_LIST_JSON"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="$EMPTY_LIST_JSON"
    local instances_json="[\"zones/us-central1-a/instances/test-instance\"]"

    local expected_command="gcloud alpha compute instances ops-agents"
    expected_command="$expected_command policies create ops-agents-test-policy"
    expected_command="$expected_command --agent-rules='type=metrics'"
    expected_command="$expected_command --os-types='version=8,short-name=centos'"
    expected_command="$expected_command --instances='zones/us-central1-a/"
    expected_command="${expected_command}instances/test-instance'"
    expected_command="$expected_command --project='test-project-id' --quiet"

    run get_create_command "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json"

    assert_equal "$output" "$expected_command"
}



##############################################################
##  get_update_command tests                                ##
##############################################################

@test "Tests get_update_command clear filters" {
    local description=""
    local agent_rules_json="$AGENT_RULES_JSON_BASIC"
    local group_labels_json="$EMPTY_LIST_JSON"
    local os_types_json="$OS_TYPES_JSON_BASIC"
    local zones_json="$EMPTY_LIST_JSON"
    local instances_json="$EMPTY_LIST_JSON"

    local expected_command="gcloud alpha compute instances ops-agents"
    expected_command="$expected_command policies update ops-agents-test-policy"
    expected_command="$expected_command --agent-rules='type=metrics'"
    expected_command="$expected_command --os-types='version=8,short-name=centos'"
    expected_command="$expected_command --clear-group-labels"
    expected_command="$expected_command --clear-zones"
    expected_command="$expected_command --clear-instances"
    expected_command="$expected_command --etag='db5c5a61-6a05-4f67-8f84-c89a654eb576'"
    expected_command="$expected_command --project='test-project-id' --quiet"

    run get_update_command "$PROJECT_ID" "$POLICY_ID" \
        "$description" "$agent_rules_json" "$group_labels_json" "$os_types_json" \
        "$zones_json" "$instances_json" "$ETAG"

    assert_equal "$output" "$expected_command"
}



##############################################################
##  get_describe_command tests                              ##
##############################################################

@test "Test get_describe_command" {
    local expected_command="gcloud alpha compute instances ops-agents"
    expected_command="$expected_command policies describe ops-agents-test-policy"
    expected_command="$expected_command --project='test-project-id' --quiet"

    run get_describe_command "$PROJECT_ID" "$POLICY_ID"

    assert_equal "$output" "$expected_command"
}


##############################################################
##  get_delete_command tests                                ##
##############################################################

@test "Test get_delete_command" {
    local expected_command="gcloud alpha compute instances ops-agents"
    expected_command="$expected_command policies delete ops-agents-test-policy"
    expected_command="$expected_command --project='test-project-id' --quiet"

    run get_delete_command "$PROJECT_ID" "$POLICY_ID"

    assert_equal "$output" "$expected_command"
}


##############################################################
##  get_etag tests                                          ##
##############################################################

@test "Test get_etag simple" {
    local describe_output="etag: db5c5a61-6a05-4f67-8f84-c89a654eb576"
    local expected_etag="$ETAG"
    run get_etag "$describe_output"

    assert_equal "$output" "$expected_etag"
}

@test "Test get_etag detailed" {
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
    run get_etag "$describe_output"

    assert_equal "$output" "$expected_etag"
}
