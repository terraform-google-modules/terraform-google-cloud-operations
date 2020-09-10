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

module "example" {
  source = "../../../examples/agent_policy_update_example"

  project_id   = var.project_id
  description  = var.description
  agent_rules  = var.agent_rules
  group_labels = var.group_labels
  os_types     = var.os_types
  zones        = var.zones
  instances    = var.instances
}
