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
  description = "The project ID to host the uptime check in (required)."
  type        = string
}

variable "uptime_check_display_name" {
  description = "The display name for the uptime check (required)."
  type        = string
}

variable "protocol" {
  description = "Protocol for uptime check. One of: HTTPS, HTTP, or TCP (required)."
  type        = string
}

variable "timeout" {
  description = "The maximum amount of time to wait for the request to complete."
  type        = string
  default     = "10s"
}

variable "period" {
  description = "How frequently uptime check is run. Must be one of the following: 60s, 300s, 600s, 900s"
  type        = string
  default     = "60s"
}

variable "content" {
  description = "String or regex content to match."
  type = string
  default = null
}

variable "matcher" {
  description = "Type of content matcher. One of: CONTAINS_STRING, NOT_CONTAINS_STRING, MATCHES_REGEX, NOT_MATCHES_REGEX, MATCHES_JSON_PATH, NOT_MATCHES_JSON_PATH"
  type = string
  default = "CONTAINS_STRING"
}

variable "json_path_matcher" {
  description = "If matcher is MATCHES_JSON_PATH or NOT_MATCHES_JSON_PATH, the json matcher and path to use. The json matcher must be either EXACT_MATCH or REGEX_MATCH."
  type = object({
    json_path = string
    json_matcher = string
  })
  default = null
}

variable "path" {
  description = "Path to the page to run the check against. The path to the page to run the check against. Will be combined with the host in monitored_resource block to construct the entire URL."
  type        = string
  default     = "/"
}

variable "port" {
  description = "The port to the page to run the check against. If left null, defaults to 443 for HTTPS and 80 for HTTP."
  type        = number
  default     = null
}

variable "headers" {
  description = "The list of headers to send as part of the uptime check request."
  type        = map(string)
  default     = {}
}

variable "body" {
  description = "The request body associated with the HTTP POST request."
  type        = string
  default     = null
}

variable "auth_info" {
  description = "Optional username and password to authenticate."
  type = object({
    username = string
    password = string
  })
  default = null
}

variable "accepted_response_status_values" {
  description = "Check will only pass if the HTTP response status code is in this set of status values (combined with the set of status classes)."
  type = set(number)
  default = []
}

variable "accepted_response_status_classes" {
  description = "Check will only pass if the HTTP response status code is in this set of status classes (combined with the set of status values). Possible values: STATUS_CLASS_1XX, STATUS_CLASS_2XX, STATUS_CLASS_3XX, STATUS_CLASS_4XX, STATUS_CLASS_5XX, STATUS_CLASS_ANY"
  type = set(string)
  default = []
}

variable "mask_headers" {
  description = "Whether to encrypt the header information."
  type        = bool
  default     = false
}

variable "request_method" {
  description = "HTTP request method to use for the check. One of: METHOD_UNSPECIFIED, GET, POST"
  type        = string
  default     = "GET"
}

variable "content_type" {
  description = "Content type to use for the http(s) check. Can be one of: TYPE_UNSPECIFIED, URL_ENCODED"
  type        = string
  default     = null
}

variable "validate_ssl" {
  description = "If https, whether to validate SSL certificates."
  type        = string
  default     = true
}

variable "selected_regions" {
  description = "Regions from which to run the uptime check from. Defaults to all regions."
  type        = list(string)
  default     = []
}

variable "checker_type" {
  description = "One of: STATIC_IP_CHECKERS, VPC_CHECKERS"
  type        = string
  default     = "STATIC_IP_CHECKERS"
}

variable "resource_group" {
  description = "Group resource associated with configuration. Resource types must be one of: RESOURCE_TYPE_UNSPECIFIED, INSTANCE, AWS_ELB_LOAD_BALANCER"
  type        = object({
    resource_type = string
    group_id      = string
  })
  default = null
}

variable "monitored_resource" {
  description = "Monitored resource type and labels. One of: uptime_url, gce_instance, gae_app, aws_ec2_instance, aws_elb_load_balancer, k8s_service, servicedirectory_service. See https://cloud.google.com/monitoring/api/resources for a list of labels."
  type        = object({
    monitored_resource_type = string
    labels = map(string)
  })
  default = null
}

// Alert Policy Variables

variable "alert_policy_display_name" {
  description = "Display name for the alert policy. Defaults to \"var.uptime_check_display_name Uptime Failure Alert Policy\" if left empty."
  type = string
  default = ""
}

variable "enabled" {
  description = "Whether or not the policy is enabled (defaults to true)"
  type        = bool
  default     = true
}

variable "alert_policy_combiner" {
  description = "Determines how to combine multiple conditions. One of: AND, OR, or AND_WITH_MATCHING_RESOURCE."
  type        = string
  default     = "OR"
}

variable "condition_display_name" {
  description = "A unique name to identify condition in dashboards, notifications, and incidents. If left empty, defaults to Failure of uptime check_id"
  type        = string
  default     = ""
}

variable "condition_threshold_value" {
  description = "A value against which to compare the time series."
  type        = number
  default     = 1
}

variable "condition_threshold_duration" {
  description = "The amount of time that a time series must violate the threshold to be considered failing, in seconds. Must be a multiple of 60 seconds."
  type        = string
  default     = "60s"
}

variable "condition_threshold_comparison" {
  description = "The comparison to apply between the time series (indicated by filter and aggregation) and the threshold (indicated by threshold_value)."
  type        = string
  default     = "COMPARISON_GT"
}

variable "condition_threshold_filter" {
  description = "A filter that identifies which time series should be compared with the threshold. Defaults to uptime check failure filter if left as empty string."
  type        = string
  default     = ""
}

variable "aggregations" {
  description = "Specifies the alignment of data points in individual time series as well as how to combine the retrieved time series together."
  type        = object({
    alignment_period = string
    per_series_aligner = string
    group_by_fields = list(string)
    cross_series_reducer = string
  })
  default     = {
    alignment_period = "1200s"
    per_series_aligner = "ALIGN_NEXT_OLDER"
    group_by_fields = ["resource.label.*"]
    cross_series_reducer = "REDUCE_COUNT_FALSE"
  }
}

variable "condition_threshold_trigger" {
  description = "Defines the percent and number of time series that must fail the predicate for the condition to be triggered"
  type        = object({
    percent = number
    count = number
  })
  default = {
    percent = null
    count   = 1
  }
}

variable "notification_rate_limit_period" {
  description = "Not more than one notification per specified period (in seconds), for example \"30s\"."
  type        = string
  default     = null
}

variable "auto_close" {
  description = "Open incidents will close if an alert policy that was active has no data for this long (in seconds, must be at least 30 minutes). For example \"18000s\"."
  type        = string
  default     = null
}

variable "notification_channel_strategy" {
  description = "Control over how the notification channels in notification_channels are notified when this alert fires, on a per-channel basis."
  type        = object({
    notification_channel_names = list(string)
    renotify_interval = number
  })
  default     = null
}

variable "alert_policy_user_labels" {
  description = "This field is intended to be used for organizing and identifying the AlertPolicy objects."
  type        = map(string)
  default     = {}
}

variable "notification_channels" {
  description = "List of all the notification channels to create for alerting if the uptime check fails. See https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.notificationChannelDescriptors/list for a list of types and labels."
  type        = list(object({
    display_name = string
    type         = string
    labels       = map(string)
  }))
  default     = []
}

variable "existing_notification_channels" {
  description = "List of existing notification channel IDs to use for alerting if the uptime check fails."
  type        = list(string)
  default     = []
}
