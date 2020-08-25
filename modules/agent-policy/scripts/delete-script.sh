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
## This script safely deletes an agent policy. The script takes
## two arguments: PROJECT_ID and POLICY_ID. This script is run
## during `terraform destroy`
####################################################################

PROJECT_ID="$1"
POLICY_ID="$2"

# include functions to build gcloud command
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
UTILS_ABS_PATH="${SCRIPT_DIR}/script-utils.sh"
# shellcheck disable=SC1090
source "$UTILS_ABS_PATH"

DESCRIBE_COMMAND="$(get_describe_command "$PROJECT_ID" "$POLICY_ID")"
echo "$DESCRIBE_COMMAND"
eval "$DESCRIBE_COMMAND"
RETURN_CODE="$?"
echo "return code of describe command: $RETURN_CODE"

if [ "$RETURN_CODE" -eq 0 ]; then
    DELETE_COMMAND="$(get_delete_command "$PROJECT_ID" "$POLICY_ID")"
    echo "$DELETE_COMMAND"
    eval "$DELETE_COMMAND"
    RETURN_CODE="$?"
    echo "return code of delete command: $RETURN_CODE"
fi
