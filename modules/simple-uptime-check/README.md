## Simple Uptime Check

This module is used to create a single uptime check along with an alert policy and new and/or existing notification channel(s) to notify if the uptime check fails.

This module does not support multiple alert policies or multiple conditions for a single alert policy. For alert policies, conditions does not support `condition_absent`, `condition_monitoring_query_language` or `condition_matched_log` blocks.

## Usage

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| accepted\_response\_status\_classes | Check will only pass if the HTTP response status code is in this set of status classes (combined with the set of status values). Possible values: STATUS\_CLASS\_1XX, STATUS\_CLASS\_2XX, STATUS\_CLASS\_3XX, STATUS\_CLASS\_4XX, STATUS\_CLASS\_5XX, STATUS\_CLASS\_ANY | `set(string)` | `[]` | no |
| accepted\_response\_status\_values | Check will only pass if the HTTP response status code is in this set of status values (combined with the set of status classes). | `set(number)` | `[]` | no |
| aggregations | Specifies the alignment of data points in individual time series as well as how to combine the retrieved time series together. | <pre>object({<br>    alignment_period     = string<br>    per_series_aligner   = string<br>    group_by_fields      = list(string)<br>    cross_series_reducer = string<br>  })</pre> | <pre>{<br>  "alignment_period": "1200s",<br>  "cross_series_reducer": "REDUCE_COUNT_FALSE",<br>  "group_by_fields": [<br>    "resource.label.*"<br>  ],<br>  "per_series_aligner": "ALIGN_NEXT_OLDER"<br>}</pre> | no |
| alert\_policy\_combiner | Determines how to combine multiple conditions. One of: AND, OR, or AND\_WITH\_MATCHING\_RESOURCE. | `string` | `"OR"` | no |
| alert\_policy\_display\_name | Display name for the alert policy. Defaults to "var.uptime\_check\_display\_name Uptime Failure Alert Policy" if left empty. | `string` | `""` | no |
| alert\_policy\_user\_labels | This field is intended to be used for organizing and identifying the AlertPolicy objects. | `map(string)` | `{}` | no |
| auth\_info | Optional username and password to authenticate. | <pre>object({<br>    username = string<br>    password = string<br>  })</pre> | `null` | no |
| auto\_close | Open incidents will close if an alert policy that was active has no data for this long (in seconds, must be at least 30 minutes). For example "18000s". | `string` | `null` | no |
| body | The request body associated with the HTTP POST request. | `string` | `null` | no |
| checker\_type | One of: STATIC\_IP\_CHECKERS, VPC\_CHECKERS | `string` | `"STATIC_IP_CHECKERS"` | no |
| condition\_display\_name | A unique name to identify condition in dashboards, notifications, and incidents. If left empty, defaults to Failure of uptime check\_id | `string` | `""` | no |
| condition\_threshold\_comparison | The comparison to apply between the time series (indicated by filter and aggregation) and the threshold (indicated by threshold\_value). | `string` | `"COMPARISON_GT"` | no |
| condition\_threshold\_duration | The amount of time that a time series must violate the threshold to be considered failing, in seconds. Must be a multiple of 60 seconds. | `string` | `"60s"` | no |
| condition\_threshold\_filter | A filter that identifies which time series should be compared with the threshold. Defaults to uptime check failure filter if left as empty string. | `string` | `""` | no |
| condition\_threshold\_trigger | Defines the percent and number of time series that must fail the predicate for the condition to be triggered | <pre>object({<br>    percent = number<br>    count   = number<br>  })</pre> | <pre>{<br>  "count": 1,<br>  "percent": null<br>}</pre> | no |
| condition\_threshold\_value | A value against which to compare the time series. | `number` | `1` | no |
| content | String or regex content to match. | `string` | `null` | no |
| content\_type | Content type to use for the http(s) check. Can be one of: TYPE\_UNSPECIFIED, URL\_ENCODED | `string` | `null` | no |
| enabled | Whether or not the policy is enabled (defaults to true) | `bool` | `true` | no |
| existing\_notification\_channels | List of existing notification channel IDs to use for alerting if the uptime check fails. | `list(string)` | `[]` | no |
| headers | The list of headers to send as part of the uptime check request. | `map(string)` | `{}` | no |
| json\_path\_matcher | If matcher is MATCHES\_JSON\_PATH or NOT\_MATCHES\_JSON\_PATH, the json matcher and path to use. The json matcher must be either EXACT\_MATCH or REGEX\_MATCH. | <pre>object({<br>    json_path    = string<br>    json_matcher = string<br>  })</pre> | `null` | no |
| mask\_headers | Whether to encrypt the header information. | `bool` | `false` | no |
| matcher | Type of content matcher. One of: CONTAINS\_STRING, NOT\_CONTAINS\_STRING, MATCHES\_REGEX, NOT\_MATCHES\_REGEX, MATCHES\_JSON\_PATH, NOT\_MATCHES\_JSON\_PATH | `string` | `"CONTAINS_STRING"` | no |
| monitored\_resource | Monitored resource type and labels. One of: uptime\_url, gce\_instance, gae\_app, aws\_ec2\_instance, aws\_elb\_load\_balancer, k8s\_service, servicedirectory\_service. See https://cloud.google.com/monitoring/api/resources for a list of labels. | <pre>object({<br>    monitored_resource_type = string<br>    labels                  = map(string)<br>  })</pre> | `null` | no |
| notification\_channel\_strategy | Control over how the notification channels in notification\_channels are notified when this alert fires, on a per-channel basis. | <pre>object({<br>    notification_channel_names = list(string)<br>    renotify_interval          = number<br>  })</pre> | `null` | no |
| notification\_channels | List of all the notification channels to create for alerting if the uptime check fails. See https://cloud.google.com/monitoring/api/ref_v3/rest/v3/projects.notificationChannelDescriptors/list for a list of types and labels. | <pre>list(object({<br>    display_name = string<br>    type         = string<br>    labels       = map(string)<br>  }))</pre> | `[]` | no |
| notification\_rate\_limit\_period | Not more than one notification per specified period (in seconds), for example "30s". | `string` | `null` | no |
| path | Path to the page to run the check against. The path to the page to run the check against. Will be combined with the host in monitored\_resource block to construct the entire URL. | `string` | `"/"` | no |
| period | How frequently uptime check is run. Must be one of the following: 60s, 300s, 600s, 900s | `string` | `"60s"` | no |
| port | The port to the page to run the check against. If left null, defaults to 443 for HTTPS and 80 for HTTP. | `number` | `null` | no |
| project\_id | The project ID to host the uptime check in (required). | `string` | n/a | yes |
| protocol | Protocol for uptime check. One of: HTTPS, HTTP, or TCP (required). | `string` | n/a | yes |
| request\_method | HTTP request method to use for the check. One of: METHOD\_UNSPECIFIED, GET, POST | `string` | `"GET"` | no |
| resource\_group | Group resource associated with configuration. Resource types must be one of: RESOURCE\_TYPE\_UNSPECIFIED, INSTANCE, AWS\_ELB\_LOAD\_BALANCER | <pre>object({<br>    resource_type = string<br>    group_id      = string<br>  })</pre> | `null` | no |
| selected\_regions | Regions from which to run the uptime check from. Defaults to all regions. | `list(string)` | `[]` | no |
| timeout | The maximum amount of time to wait for the request to complete. | `string` | `"10s"` | no |
| uptime\_check\_display\_name | The display name for the uptime check (required). | `string` | n/a | yes |
| validate\_ssl | If https, whether to validate SSL certificates. | `string` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| alert\_policy\_id | The id of the alert policy. |
| notification\_channel\_ids | The ids of the notification channels |
| uptime\_check\_id | The id of the uptime check. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
