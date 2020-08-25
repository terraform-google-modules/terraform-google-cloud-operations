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
## This script contains util functions. The util functions are used
## in modules/agent-policy/scripts/create-update-script.sh and
## modules/agent-policy/scripts/delete-script.sh
####################################################################


CREATE="create"
UPDATE="update"
LAUNCH_STAGE="alpha"


# Params:
#   $1 = JSON formatted list(string)
# Return:
#   A well-formatted command line flag value for a list of strings
function get_formatted_list_of_strings() {
    local formatted
    local python="python -c 'import json, sys;"
    python="$python list_of_strings = json.load(sys.stdin);"
    python="$python print (\",\".join(x for x in list_of_strings))'"
    formatted="$(echo "$1" | eval "$python")"
    echo "$formatted"
}


# Params:
#   $1 = JSON formatted list(object)
# Return:
#   A well-formatted command line flag value for a list of objects
function get_formatted_list_of_objects() {
    local formatted
    local python="python -c 'import json, sys;"
    python="$python list_of_objs = json.load(sys.stdin);"
    python="$python print (\";\".join(\",\".join([\"{}={}\".format(k.replace(\"_\", \"-\"),"
    python="$python str(v).lower() if type(v) is bool else v) for k, v in obj.items()])"
    python="$python for obj in list_of_objs))'"
    formatted="$(echo "$1" | eval "$python")"
    # formatted="$(echo "$1" | python -c 'import json, sys; \
    #     list_of_objs = json.load(sys.stdin); \
    #     print (";".join(",".join(["{}={}".format(k.replace("_", "-"), \
    #         str(v).lower() if type(v) is bool else v) for k, v in obj.items()]) \
    #         for obj in list_of_objs))')"
    echo "$formatted"
}


# Params:
#   $1 = JSON formatted list(list(objects))
# Return:
#   A well-formatted command line flag value for a list of list of objects
function get_formatted_list_of_list_of_objects() {
    local formatted
    local python="python -c 'import json, sys;"
    python="$python list_of_list_of_objs = json.load(sys.stdin);"
    python="$python print (\";\".join(\",\".join(\"=\".join(inner_list[x] for x in inner_list)"
    python="$python for inner_list in outer_list) for outer_list in list_of_list_of_objs))'"
    formatted="$(echo "$1" | eval "$python")"
    echo "$formatted"

}

# Params:
#   $1 = output of successful describe command
# Return:
#   the etag in the given string
function get_etag() {
    local describe_output="$1"
    local etag=${describe_output#*etag: } # removes everything before etag
    etag=${etag%id: *} # removes everything after etag
    echo "$etag" | tr -d '\040\011\012\015' # removes spaces, tabs, carriage returns, newlines
}


# Params:
#   $1 = flag name
#   $2 = flag value
# Return:
#   An empty string if the flag value is empty, otherwise returns the appropriate flag
function get_flag() {
    local flag_name="$1"
    local flag_value="$2"
    local flag=""
    if [ -n "$flag_value" ]; then
        # flag value is not empty
        flag=" --$flag_name='$flag_value'"
    fi
    echo "$flag"
}


# Params:
#   $1 = flag name
#   $2 = flag value
# Return:
#   An appropriate --clear-x flag (where x is instances, group-labels, or zones)
#   if the flag value is empty, otherwise returns the appropriate flag
function get_update_flag() {
    # if the flag is empty
    # we return the "clear group labels flag"
    local flag_name="$1"
    local flag_value="$2"
    local update_flag=""
    if [ -z "$flag_value" ]; then
        # flag value is empty
        update_flag=" --clear-$flag_name"
    fi
    echo "$update_flag"
}


# Params:
#   $1 = group labels flag name
#   $2 = group labels flag value
#   $3 = zones flag name
#   $4 = zones flag value
#   $5 = instances flag name
#   $5 = instances flag value
# Return:
#   The appropriate --clear-x flags (where x is group-labels, zones, or instances)
#   based on grloup labels flag value, zones flag value, and instances flag value
function get_update_flags() {
    local group_labels_flag_name="$1"
    local group_labels_flag_value="$2"
    local zones_flag_name="$3"
    local zones_flag_value="$4"
    local instances_flag_name="$5"
    local instances_flag_value="$6"
    local clear_group_labels_flag
    local clear_zones_flag
    local update_flags

    clear_group_labels_flag="$(get_update_flag "$group_labels_flag_name" \
        "$group_labels_flag_value")"
    clear_zones_flag=$(get_update_flag "$zones_flag_name" "$zones_flag_value")
    clear_instances_flag=$(get_update_flag "$instances_flag_name" "$instances_flag_value")

    local update_flags="$clear_group_labels_flag$clear_zones_flag$clear_instances_flag"
    echo "$update_flags"
}

# Params:
#   $1 = project id
# Return:
#   The appropriate global flags (--project and --quiet)
function get_global_flags() {
    local project_id="$1"
    local project_flag_name="project"
    local project_flag
    project_flag=$(get_flag "$project_flag_name" "$project_id")
    local quiet_flag=" --quiet"

    local global_flags="$project_flag$quiet_flag"
    echo "$global_flags"
}

# Params:
#   $1 = action (create or update)
#   $2 = policy id
#   $3 = description of the agent policy
#   $4 = agent rules, in json format
#   $5 = group labels, in json format
#   $6 = os types, in json format
#   $7 = zones, in json format
#   $8 = instances, in json format
# Return:
#   the appropriate gcloud create or update command, given the args
function get_base_upsert_command() {
    local action="$1"
    local policy_id="$2"
    local description="$3"
    local agent_rules_json="$4"
    local group_labels_json="$5"
    local os_types_json="$6"
    local zones_json="$7"
    local instances_json="$8"

    local description_flag_name="description"
    local agent_rules_flag_name="agent-rules"
    local group_labels_flag_name="group-labels"
    local os_types_flag_name="os-types"
    local zones_flag_name="zones"
    local instances_flag_name="instances"

    local agent_rules_flag_value
    local group_labels_flag_value
    local os_types_flag_value
    local zones_flag_value
    local instances_flag_value
    agent_rules_flag_value=$(get_formatted_list_of_objects "$agent_rules_json")
    group_labels_flag_value=$(get_formatted_list_of_list_of_objects "$group_labels_json")
    os_types_flag_value=$(get_formatted_list_of_objects "$os_types_json")
    zones_flag_value=$(get_formatted_list_of_strings "$zones_json")
    instances_flag_value=$(get_formatted_list_of_strings "$instances_json")

    local description_flag
    local agent_rules_flag
    local group_labels_flag
    local os_types_flag
    local zones_flag
    local instances_flag
    local project_flag
    description_flag=$(get_flag "$description_flag_name" "$description")
    agent_rules_flag=$(get_flag "$agent_rules_flag_name" "$agent_rules_flag_value")
    group_labels_flag=$(get_flag "$group_labels_flag_name" "$group_labels_flag_value")
    os_types_flag=$(get_flag "$os_types_flag_name" "$os_types_flag_value")
    zones_flag=$(get_flag "$zones_flag_name" "$zones_flag_value")
    instances_flag=$(get_flag "$instances_flag_name" "$instances_flag_value")

    local update_flags=""
    if [ "$action" = "$UPDATE" ]; then
        update_flags="$(get_update_flags "$group_labels_flag_name" \
            "$group_labels_flag_value" "$zones_flag_name" "$zones_flag_value" \
            "$instances_flag_name" "$instances_flag_value")"
    fi

    local command="gcloud $LAUNCH_STAGE compute instances ops-agents policies $action"
    command="$command $policy_id$description_flag$agent_rules_flag$group_labels_flag"
    command="$command$os_types_flag$zones_flag$instances_flag$update_flags"
    echo "$command"
}

# Params:
#   $1 = project id
#   $2 = policy id
#   $3 = description of the agent policy
#   $4 = agent rules, in json format
#   $5 = group labels, in json format
#   $6 = os types, in json format
#   $7 = zones, in json format
#   $8 = instances, in json format
# Return:
#   the appropriate gcloud create command, given the args
function get_create_command() {
    local project_id="$1"
    local policy_id="$2"
    local description="$3"
    local agent_rules_json="$4"
    local group_labels_json="$5"
    local os_types_json="$6"
    local zones_json="$7"
    local instances_json="$8"
    local base_create_command
    local global_flags

    base_create_command="$(get_base_upsert_command "$CREATE" \
        "$policy_id" "$description" "$agent_rules_json" \
        "$group_labels_json" "$os_types_json" "$zones_json" "$instances_json")"
    global_flags=$(get_global_flags "$project_id")

    local create_command="$base_create_command$global_flags"
    echo "$create_command"
}

# Params:
#   $1 = project id
#   $2 = policy id
#   $3 = description of the agent policy
#   $4 = agent rules, in json format
#   $5 = group labels, in json format
#   $6 = os types, in json format
#   $7 = zones, in json format
#   $8 = instances, in json format
#   $9 = etag
# Return:
#   the appropriate gcloud update command, given the args
function get_update_command() {
    local project_id="$1"
    local policy_id="$2"
    local description="$3"
    local agent_rules_json="$4"
    local group_labels_json="$5"
    local os_types_json="$6"
    local zones_json="$7"
    local instances_json="$8"
    local etag="$9"
    local base_update_command
    local etag_flag
    local global_flags

    base_update_command="$(get_base_upsert_command "$UPDATE" \
        "$policy_id" "$description" "$agent_rules_json" \
        "$group_labels_json" "$os_types_json" "$zones_json" "$instances_json")"
    etag_flag=$(get_flag etag "$etag")
    global_flags=$(get_global_flags "$project_id")
    local update_command="$base_update_command$etag_flag$global_flags"
    echo "$update_command"
}


# Params:
#   $1 = project id
#   $2 = policy id
# Return:
#   the appropriate gcloud describe command, given the args
function get_describe_command() {
    local project_id="$1"
    local policy_id="$2"
    local project_flag_name="project"
    local project_flag
    project_flag=$(get_flag "$project_flag_name" "$project_id")

    local command="gcloud $LAUNCH_STAGE compute instances ops-agents policies describe"
    command="$command $policy_id$project_flag --quiet"
    echo "$command"
}

# Params:
#   $1 = project id
#   $2 = policy id
# Return:
#   the appropriate gcloud delete command, given the args
function get_delete_command() {
    local project_id="$1"
    local policy_id="$2"
    local project_flag_name="project"
    local project_flag
    project_flag=$(get_flag "$project_flag_name" "$project_id")

    local command="gcloud $LAUNCH_STAGE compute instances ops-agents policies delete"
    command="$command $policy_id$project_flag --quiet"
    echo "$command"
}
