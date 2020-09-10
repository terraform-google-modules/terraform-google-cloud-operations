# Update Example

This example is specifically for testing update functionality.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| agent\_rules | A list of agent rules to be enforced by the policy. | list(any) | n/a | yes |
| description | The description of the policy. | string | `"null"` | no |
| group\_labels | A list of label maps to filter instances to apply policies on. | object | `"null"` | no |
| instances | A list of zones to filter instances to apply the policy. | list(string) | `"null"` | no |
| os\_types | A list of label maps to filter instances to apply policies on. | list(any) | n/a | yes |
| project\_id | The ID of the project in which to provision resources. | string | n/a | yes |
| zones | A list of zones to filter instances to apply the policy. | list(string) | `"null"` | no |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

To provision this example, run the following from within this directory:
- `terraform init` to get the plugins
- `terraform plan` to see the infrastructure plan
- `terraform apply` to apply the infrastructure build
- `terraform destroy` to destroy the built infrastructure
