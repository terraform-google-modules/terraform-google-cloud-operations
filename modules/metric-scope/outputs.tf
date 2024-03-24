/**
 * Copyright 2019 Google LLC
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

output "metric-scope-ids" {
  value       = [for id in var.monitored_project : google_monitoring_monitored_project.primary[id].id]
  description = "ID's of the metric scope"
}

output "monitoring-groups" {
  value = flatten([[for id in local.root_group : google_monitoring_group.root-group[id.name].name],
    [for id in local.sub_group_level_1 : google_monitoring_group.sub-group-level-1[id.name].name],
    [for id in local.sub_group_level_2 : google_monitoring_group.sub-group-level-2[id.name].name],
    [for id in local.sub_group_level_3 : google_monitoring_group.sub-group-level-3[id.name].name],
    [for id in local.sub_group_level_4 : google_monitoring_group.sub-group-level-4[id.name].name],
    [for id in local.sub_group_level_5 : google_monitoring_group.sub-group-level-5[id.name].name],
    [for id in local.sub_group_level_6 : google_monitoring_group.sub-group-level-6[id.name].name],
    [for id in local.sub_group_level_7 : google_monitoring_group.sub-group-level-7[id.name].name],
  [for id in local.sub_group_level_8 : google_monitoring_group.sub-group-level-8[id.name].name]])

  description = "Monitoring group names"
}
