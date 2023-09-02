/**
 * Copyright 2023 Google LLC
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

variable "scoping_project" {
  type        = string
  description = "Scope Project"
}

variable "monitored_project" {
  type        = list(string)
  description = "List of Monitored project"
  default     = []
}

variable "group" {
  type = list(object({
    name        = string
    parent_name = optional(string, null)
    filter      = string
    is_cluster  = optional(bool, false)
  }))
  default     = []
  description = "List of Monitoring Resouce Groups"
}
