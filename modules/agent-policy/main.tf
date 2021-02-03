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

module "gcloud-upsert" {
  source = "terraform-google-modules/gcloud/google"

  platform              = "linux"
  additional_components = ["beta"]
  gcloud_sdk_version    = "325.0.0"
  create_cmd_entrypoint = abspath("${path.module}/scripts/create-update-script.sh")
  create_cmd_body       = <<-EOT
    ${var.project_id} ${jsonencode(var.policy_id)} \
    ${jsonencode(var.description == null ? "" : var.description)} \
    ${base64encode(jsonencode(var.agent_rules))} \
    ${base64encode(jsonencode(var.group_labels == null ? [] : var.group_labels))} \
    ${base64encode(jsonencode(var.os_types))} \
    ${base64encode(jsonencode(var.zones == null ? [] : var.zones))} \
    ${base64encode(jsonencode(var.instances == null ? [] : var.instances))}
    EOT
  create_cmd_triggers   = { uuid = uuid() }
}

module "gcloud-destroy" {
  source = "terraform-google-modules/gcloud/google"

  platform              = "linux"
  gcloud_sdk_version    = "325.0.0"
  additional_components = ["beta"]

  destroy_cmd_entrypoint = abspath("${path.module}/scripts/delete-script.sh")
  destroy_cmd_body       = "${var.project_id} ${jsonencode(var.policy_id)}"
}
