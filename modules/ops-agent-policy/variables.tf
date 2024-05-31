/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

####################################################################
## Variables for the ops-agent-policy module
####################################################################

variable "assignment_id" {
  description = "Resource name. Unique among policy assignments in the given zone"
  type        = string
}

variable "zone" {
  description = "The location to which policy assignments are applied to."
  type        = string
}

variable "project" {
  description = "The ID of the project in which to provision resources. If not present, uses the provider ID"
  type        = string
  default     = null
}

variable "ops_agent" {
  description = "Whether to install or uninstall the agent, and which version to install."
  type        = object({ package_state : string, version : string })
  default     = { package_state : "installed", version : "latest" }
  validation {
    condition     = contains(["installed", "removed"], var.ops_agent.package_state)
    error_message = "ops_agent.package_state must be one of installed|removed"
  }
  validation {
    condition = (var.ops_agent.version == "latest" ||
      length(regexall("2\\.\\d+\\.\\d+", var.ops_agent.version)) > 0 ||
    var.ops_agent.version == "2.*.*")
    error_message = "ops_agent.version match one of 'latest', r'2\\.\\d\\.\\d', '2.*.*"
  }
}

variable "instance_filter" {
  description = "Filter to select VMs. Structure is documented below here: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/os_config_os_policy_assignment."
  type = object({
    all : optional(bool),
    exclusion_labels : optional(list(object({
      labels : map(string)
    })), []),
    inclusion_labels : optional(list(object({
      labels : map(string)
    })), []),
    inventories : optional(list(object({
      os_short_name : string,
      os_version : string
    })), []),
  })
}