<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| group | n/a | <pre>list(object({<br>    name        = string<br>    parent_name = optional(string, null)<br>    filter      = string<br>    is_cluster  = optional(bool, false)<br>  }))</pre> | n/a | yes |
| monitored\_project | List of Monitored project | `list(string)` | n/a | yes |
| scoping\_project | Scope Project | `string` | n/a | yes |

## Outputs

No outputs.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

