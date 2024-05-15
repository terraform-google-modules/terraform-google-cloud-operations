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

provider "google" {
  project     = var.project_id
}

data "google_compute_regions" "available" {
}

data "google_compute_zones" "available" {
  for_each = toset(data.google_compute_regions.available.names)
  region = each.value
}

module "ops_agent_policy" {
  for_each = toset(flatten([for zones in values(data.google_compute_zones.available) : zones.names]))
  source      = "./../../modules/ops-agent-policy"
  assignment_id = "ops_agent_policy_all_in_${replace(each.key, "-", "_")}"
  zone = each.key
  instance_filter = {all=true}
}