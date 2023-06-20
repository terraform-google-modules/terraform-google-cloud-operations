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

variable "project_id" {
  description = "The ID of the project in which to provision resources."
  type        = string
}

variable "uptime_check_display_name" {
  description = "The ID of the project in which to provision resources."
  type        = string
  default     = "example-uptime-check-name"
}

variable "hostname" {
  description = "The base hostname for the uptime check."
  type        = string
  default     = "example-hostname.com"
}

variable "email" {
  description = "Email address to alert if uptime check fails."
  type        = string
  default     = "example-email@gmail.com"
}

variable "sms" {
  description = "Phone number (including country code) to alert if uptime check fails."
  type        = string
  default     = "+10123456789"
}
