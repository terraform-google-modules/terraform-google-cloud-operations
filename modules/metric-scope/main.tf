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

locals {
  root_group        = [for val in var.group : val if val.parent_name == null]
  sub_group_level_1 = setsubtract(distinct([for val in var.group : val.parent_name == null ? {} : contains(local.root_group.*.name, val.parent_name) ? val : {}]), [{}])
  sub_group_level_2 = setsubtract(distinct([for val in var.group : val.parent_name == null ? {} : contains(local.sub_group_level_1.*.name, val.parent_name) ? val : {}]), [{}])
  sub_group_level_3 = setsubtract(distinct([for val in var.group : val.parent_name == null ? {} : contains(local.sub_group_level_2.*.name, val.parent_name) ? val : {}]), [{}])
  sub_group_level_4 = setsubtract(distinct([for val in var.group : val.parent_name == null ? {} : contains(local.sub_group_level_3.*.name, val.parent_name) ? val : {}]), [{}])
  sub_group_level_5 = setsubtract(distinct([for val in var.group : val.parent_name == null ? {} : contains(local.sub_group_level_4.*.name, val.parent_name) ? val : {}]), [{}])
  sub_group_level_6 = setsubtract(distinct([for val in var.group : val.parent_name == null ? {} : contains(local.sub_group_level_5.*.name, val.parent_name) ? val : {}]), [{}])
  sub_group_level_7 = setsubtract(distinct([for val in var.group : val.parent_name == null ? {} : contains(local.sub_group_level_6.*.name, val.parent_name) ? val : {}]), [{}])
  sub_group_level_8 = setsubtract(distinct([for val in var.group : val.parent_name == null ? {} : contains(local.sub_group_level_7.*.name, val.parent_name) ? val : {}]), [{}])
}

#attach project to scoping project

resource "google_monitoring_monitored_project" "primary" {
  for_each      = toset(var.monitored_project)
  metrics_scope = var.scoping_project
  name          = each.value
}

#monitoring groups

resource "google_monitoring_group" "root-group" {
  depends_on   = [google_monitoring_monitored_project.primary]
  for_each     = { for i in local.root_group : i.name => i }
  display_name = each.key
  parent_name  = each.value.parent_name
  filter       = each.value.filter
  project      = var.scoping_project
  is_cluster   = each.value.is_cluster

}

resource "google_monitoring_group" "sub-group-level-1" {
  for_each     = { for i in local.sub_group_level_1 : i.name => i }
  display_name = each.key
  parent_name  = google_monitoring_group.root-group[each.value.parent_name].name
  filter       = each.value.filter
  project      = var.scoping_project
  is_cluster   = each.value.is_cluster
}

resource "google_monitoring_group" "sub-group-level-2" {
  for_each     = { for i in local.sub_group_level_2 : i.name => i }
  display_name = each.key
  parent_name  = google_monitoring_group.sub-group-level-1[each.value.parent_name].name
  filter       = each.value.filter
  project      = var.scoping_project
  is_cluster   = each.value.is_cluster
}

resource "google_monitoring_group" "sub-group-level-3" {
  for_each     = { for i in local.sub_group_level_3 : i.name => i }
  display_name = each.key
  parent_name  = google_monitoring_group.sub-group-level-2[each.value.parent_name].name
  filter       = each.value.filter
  project      = var.scoping_project
  is_cluster   = each.value.is_cluster
}

resource "google_monitoring_group" "sub-group-level-4" {
  for_each     = { for i in local.sub_group_level_4 : i.name => i }
  display_name = each.key
  parent_name  = google_monitoring_group.sub-group-level-3[each.value.parent_name].name
  filter       = each.value.filter
  project      = var.scoping_project
  is_cluster   = each.value.is_cluster
}

resource "google_monitoring_group" "sub-group-level-5" {
  for_each     = { for i in local.sub_group_level_5 : i.name => i }
  display_name = each.key
  parent_name  = google_monitoring_group.sub-group-level-4[each.value.parent_name].name
  filter       = each.value.filter
  project      = var.scoping_project
  is_cluster   = each.value.is_cluster
}

resource "google_monitoring_group" "sub-group-level-6" {
  for_each     = { for i in local.sub_group_level_6 : i.name => i }
  display_name = each.key
  parent_name  = google_monitoring_group.sub-group-level-5[each.value.parent_name].name
  filter       = each.value.filter
  project      = var.scoping_project
  is_cluster   = each.value.is_cluster
}

resource "google_monitoring_group" "sub-group-level-7" {
  for_each     = { for i in local.sub_group_level_7 : i.name => i }
  display_name = each.key
  parent_name  = google_monitoring_group.sub-group-level-6[each.value.parent_name].name
  filter       = each.value.filter
  project      = var.scoping_project
  is_cluster   = each.value.is_cluster
}

resource "google_monitoring_group" "sub-group-level-8" {
  for_each     = { for i in local.sub_group_level_8 : i.name => i }
  display_name = each.key
  parent_name  = google_monitoring_group.sub-group-level-7[each.value.parent_name].name
  filter       = each.value.filter
  project      = var.scoping_project
  is_cluster   = each.value.is_cluster
}

