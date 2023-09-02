## Metric Scope

This module is used add multiple projects as monitored project under a scoping project and to create monitoring resource groups/subgroups.

Groups and sub-groups name should be unique

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| group | List of Monitoring Resouce Groups | <pre>list(object({<br>    name        = string<br>    parent_name = optional(string, null)<br>    filter      = string<br>    is_cluster  = optional(bool, false)<br>  }))</pre> | `[]` | no |
| monitored\_project | List of Monitored project | `list(string)` | `[]` | no |
| scoping\_project | Scope Project | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
