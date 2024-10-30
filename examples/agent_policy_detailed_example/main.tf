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

module "agent_policy_detailed" {
  source  = "terraform-google-modules/cloud-operations/google//modules/agent-policy"
  version = "~> 0.6"

  project_id  = var.project_id
  policy_id   = "ops-agents-test-policy-detailed"
  description = "an example policy description"
  agent_rules = [
    {
      type               = "logging"
      version            = "current-major"
      package_state      = "installed"
      enable_autoupgrade = true
    },
    {
      type               = "metrics"
      version            = "current-major"
      package_state      = "installed"
      enable_autoupgrade = true
    },
  ]
  group_labels = [
    {
      env     = "prod"
      product = "myapp"
    },
    {
      env     = "staging"
      product = "myapp"
    }
  ]
  os_types = [
    {
      short_name = "debian"
      version    = "10"
    },
  ]
  zones = [
    "us-central1-c",
    "asia-northeast2-b",
    "europe-north1-b",
  ]
  instances = ["zones/us-central1-a/instances/test-instance"]
}
