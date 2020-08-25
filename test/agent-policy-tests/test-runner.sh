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
## This script runs the unit tests and the integration tests that
## check update behavior
####################################################################

PROJECT_ID=""
POLICY_ID=""

# make sure the script is running from the right place
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$SCRIPT_DIR" || exit 1

echo "##############################################################"
echo "## RUNNING UNIT TESTS                                       ##"
echo "##############################################################"
./test-script-utils.sh

echo "##############################################################"
echo "## RUNNING INTEGRATION UPDATE TESTS                         ##"
echo "##############################################################"
# ./test-update-utils/test-integration-update.sh "$PROJECT_ID" "$POLICY_ID"
