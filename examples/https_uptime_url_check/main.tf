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

module "uptime-check" {
  source  = "terraform-google-modules/cloud-operations/google//modules/simple-uptime-check"
  version = "~> 0.6"

  project_id                = var.project_id
  uptime_check_display_name = var.uptime_check_display_name
  protocol                  = "HTTPS"
  monitored_resource = {
    monitored_resource_type = "uptime_url"
    labels = {
      "project_id" = var.project_id
      "host"       = var.hostname
    }
  }

  notification_channels = [
    {
      display_name = "Email Notification Channel"
      type         = "email"
      labels       = { email_address = var.email }
    },
    # {
    #   display_name = "SMS Notification Channel"
    #   type         = "sms"
    #   labels       = { number = var.sms }
    # }
  ]
}
