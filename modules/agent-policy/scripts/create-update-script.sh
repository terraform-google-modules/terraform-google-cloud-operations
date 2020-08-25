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
## This script safely creates or updates an agent policy.
## The script takes eight arguments: PROJECT_ID, POLICY_ID,
## DESCRIPTION, AGENT_RULES_JSON, GROUP_LABELS_JSON, OS_TYPES_JSON,
## ZONES_JSON, and INSTANCES_JSON. This script is run
## during `terraform apply`
####################################################################

PROJECT_ID="$1"
POLICY_ID="$2"
DESCRIPTION="$3"
AGENT_RULES_JSON="$(echo "$4" | base64 --decode)"
GROUP_LABELS_JSON="$(echo "$5" | base64 --decode)"
OS_TYPES_JSON="$(echo "$6" | base64 --decode)"
ZONES_JSON="$(echo "$7" | base64 --decode)"
INSTANCES_JSON="$(echo "$8" | base64 --decode)"


# include functions to build gcloud command
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
UTILS_ABS_PATH="${SCRIPT_DIR}/script-utils.sh"
# shellcheck disable=SC1090
source "$UTILS_ABS_PATH"


DESCRIBE_COMMAND="$(get_describe_command "$PROJECT_ID" "$POLICY_ID")"
echo "$DESCRIBE_COMMAND"
DESCRIBE_OUTPUT=$(eval "$DESCRIBE_COMMAND" 2>/dev/null)
RETURN_CODE="$?"
echo "return code of describe command: $RETURN_CODE"

if [ "$RETURN_CODE" -eq 0 ]; then
    echo "$DESCRIBE_OUTPUT"
    echo "$POLICY_ID exists, updating"
    ETAG="$(get_etag "$DESCRIBE_OUTPUT")"
    echo "etag: $ETAG"
    # TODO: add etag to args
    UPDATE_COMMAND="$(get_update_command "$PROJECT_ID" "$POLICY_ID" \
        "$DESCRIPTION" "$AGENT_RULES_JSON" "$GROUP_LABELS_JSON" \
        "$OS_TYPES_JSON" "$ZONES_JSON" "$INSTANCES_JSON" "$ETAG")"
    echo "$UPDATE_COMMAND"
    eval "$UPDATE_COMMAND"
    RETURN_CODE="$?"
    echo "return code of update command: $RETURN_CODE"
else
    echo "$POLICY_ID does not exist, creating"
    CREATE_COMMAND="$(get_create_command "$PROJECT_ID" "$POLICY_ID" \
        "$DESCRIPTION" "$AGENT_RULES_JSON" "$GROUP_LABELS_JSON" \
        "$OS_TYPES_JSON" "$ZONES_JSON" "$INSTANCES_JSON")"
    echo "$CREATE_COMMAND"
    eval "$CREATE_COMMAND"
    RETURN_CODE="$?"
    echo "return code of create command: $RETURN_CODE"
fi

