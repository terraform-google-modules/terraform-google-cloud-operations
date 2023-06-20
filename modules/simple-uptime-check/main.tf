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
  use_ssl   = var.protocol == "HTTPS"
  http_port = var.port == null && var.protocol == "HTTPS" ? 443 : 80

  alert_policy_name     = coalesce(var.alert_policy_display_name, "${var.uptime_check_display_name} Uptime Failure Alert Policy")
  enable_alert_strategy = var.auto_close != null || var.notification_rate_limit_period != null || var.notification_channel_strategy != null ? true : false
  resource_type         = var.monitored_resource != null ? var.monitored_resource.monitored_resource_type : var.resource_group.resource_type
  threshold_filter      = var.condition_threshold_filter == "" ? "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND metric.label.check_id=\"${google_monitoring_uptime_check_config.uptime_check.uptime_check_id}\" AND resource.type=\"${local.resource_type}\"" : var.condition_threshold_filter
}

resource "google_monitoring_uptime_check_config" "uptime_check" {
  display_name = var.uptime_check_display_name
  project      = var.project_id

  timeout          = var.timeout
  period           = var.period
  selected_regions = var.selected_regions
  checker_type     = var.checker_type

  dynamic "http_check" {
    for_each = var.protocol == "HTTP" || var.protocol == "HTTPS" ? [1] : []
    content {
      path           = var.path
      port           = local.http_port
      request_method = var.request_method
      headers        = var.headers
      mask_headers   = var.mask_headers
      content_type   = var.content_type
      body           = var.body
      use_ssl        = local.use_ssl
      validate_ssl   = var.validate_ssl

      dynamic "auth_info" {
        for_each = var.auth_info != null ? [1] : []

        content {
          username = var.auth_info.username
          password = var.auth_info.password
        }
      }

      dynamic "accepted_response_status_codes" {
        for_each = var.accepted_response_status_values

        content {
          status_value = accepted_response_status_codes.value
        }
      }

      dynamic "accepted_response_status_codes" {
        for_each = var.accepted_response_status_classes

        content {
          status_class = accepted_response_status_codes.value
        }
      }
    }
  }

  dynamic "tcp_check" {
    for_each = var.protocol == "TCP" ? [1] : []
    content {
      port = var.port
    }
  }

  dynamic "content_matchers" {
    for_each = var.content != null ? [1] : []

    content {
      content = var.content
      matcher = var.matcher

      dynamic "json_path_matcher" {
        for_each = var.json_path_matcher != null ? [1] : []

        content {
          json_path    = var.json_path_matcher.json_path
          json_matcher = var.json_path_matcher.json_matcher
        }
      }
    }
  }

  dynamic "resource_group" {
    for_each = var.resource_group != null ? [1] : []

    content {
      resource_type = var.resource_group.resource_type
      group_id      = var.resource_group.group_id
    }
  }

  dynamic "monitored_resource" {
    for_each = var.monitored_resource != null ? [1] : []

    content {
      type   = var.monitored_resource.monitored_resource_type
      labels = var.monitored_resource.labels
    }
  }
}

resource "google_monitoring_alert_policy" "alert_policy" {
  project      = var.project_id
  display_name = local.alert_policy_name
  enabled      = var.enabled
  combiner     = var.alert_policy_combiner

  conditions {
    display_name = var.condition_display_name != "" ? var.condition_display_name : "Failure of uptime check_id ${google_monitoring_uptime_check_config.uptime_check.uptime_check_id}"

    condition_threshold {
      threshold_value = var.condition_threshold_value
      duration        = var.condition_threshold_duration
      filter          = local.threshold_filter
      comparison      = var.condition_threshold_comparison

      aggregations {
        alignment_period     = var.aggregations.alignment_period
        per_series_aligner   = var.aggregations.per_series_aligner
        group_by_fields      = var.aggregations.group_by_fields
        cross_series_reducer = var.aggregations.cross_series_reducer
      }

      trigger {
        percent = var.condition_threshold_trigger.percent
        count   = var.condition_threshold_trigger.count
      }
    }
  }

  notification_channels = concat([for channel in google_monitoring_notification_channel.notification_channel : channel.id], var.existing_notification_channels)

  dynamic "alert_strategy" {
    for_each = local.enable_alert_strategy ? [1] : []

    content {
      auto_close = var.auto_close

      dynamic "notification_rate_limit" {
        for_each = var.notification_rate_limit_period != null ? [1] : []

        content {
          period = var.notification_rate_limit_period
        }
      }

      dynamic "notification_channel_strategy" {
        for_each = var.notification_channel_strategy != null ? [1] : []

        content {
          notification_channel_names = var.notification_channel_strategy.notification_channel_names
          renotify_interval          = var.notification_channel_strategy.renotify_interval
        }
      }
    }
  }

  user_labels = var.alert_policy_user_labels
}

resource "google_monitoring_notification_channel" "notification_channel" {
  for_each     = { for k, v in var.notification_channels : k => v }
  project      = var.project_id
  display_name = each.value.display_name
  type         = each.value.type
  labels       = each.value.labels
}
