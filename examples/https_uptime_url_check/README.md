# HTTPS Uptime URL Check Example

This example illustrates how to use the `simple-uptime-check` module for a simple HTTPS Uptime URL check.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| email | Email address to alert if uptime check fails. | `string` | `"example-email@gmail.com"` | no |
| hostname | The base hostname for the uptime check. | `string` | `"example-hostname.com"` | no |
| project\_id | The ID of the project in which to provision resources. | `string` | n/a | yes |
| uptime\_check\_display\_name | The ID of the project in which to provision resources. | `string` | `"example-uptime-check-name"` | no |

## Outputs

| Name | Description |
|------|-------------|
| alert\_policy\_id | The id of the alert policy. |
| notification\_channel\_ids | The ids of the notification channels |
| uptime\_check\_id | The id of the uptime check. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
