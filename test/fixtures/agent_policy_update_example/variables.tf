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

variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "description" {
  description = "The description of the policy."
  type        = string
  default     = null
}

variable "agent_rules" {
  description = "A list of agent rules to be enforced by the policy."
  type        = list(any)
}

variable "group_labels" {
  description = "A list of label maps to filter instances to apply policies on."
  type = list(list(object({
    name  = string
    value = string
  })))
  default = null
}

variable "os_types" {
  description = "A list of label maps to filter instances to apply policies on."
  type        = list(any)
}

variable "zones" {
  description = "A list of zones to filter instances to apply the policy."
  type        = list(string)
  default     = null
}

variable "instances" {
  description = "A list of zones to filter instances to apply the policy."
  type        = list(string)
  default     = null
}
