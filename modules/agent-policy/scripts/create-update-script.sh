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

PROJECT_ID="$1"
POLICY_ID="$2"
DESCRIPTION="$3"
AGENT_RULES_JSON="$(echo "$4" | base64 --decode)"
GROUP_LABELS_JSON="$(echo "$5" | base64 --decode)"
OS_TYPES_JSON="$(echo "$6" | base64 --decode)"
ZONES_JSON="$(echo "$7" | base64 --decode)"
INSTANCES_JSON="$(echo "$8" | base64 --decode)"
CREATE="create"
UPDATE="update"
LAUNCH_STAGE="alpha"
DESCRIBE_COMMAND="gcloud $LAUNCH_STAGE compute instances ops-agents policies describe $POLICY_ID --project=$PROJECT_ID"


# include functions to build gcloud command
script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${script_dir}/create-update-utils.sh"

DESCRIBE_COMMAND="$(get_describe_command "$PROJECT_ID" "$POLICY_ID")"
echo $DESCRIBE_COMMAND

if eval $DESCRIBE_COMMAND; then # suppresses output
    echo "$POLICY_ID exists, updating"
    UPDATE_COMMAND="$(get_upsert_command $UPDATE "$PROJECT_ID" "$POLICY_ID" \
        "$DESCRIPTION" "$AGENT_RULES_JSON" "$GROUP_LABELS_JSON" \
        "$OS_TYPES_JSON" "$ZONES_JSON" "$INSTANCES_JSON")"

    echo $UPDATE_COMMAND
    eval $UPDATE_COMMAND
else
    echo "$POLICY_ID does not exist, creating"
    CREATE_COMMAND="$(get_upsert_command $CREATE "$PROJECT_ID" "$POLICY_ID" \
        "$DESCRIPTION" "$AGENT_RULES_JSON" "$GROUP_LABELS_JSON" \
        "$OS_TYPES_JSON" "$ZONES_JSON" "$INSTANCES_JSON")"
        
    echo $CREATE_COMMAND
    eval $CREATE_COMMAND
fi

