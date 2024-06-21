# Agent Policy

This module is used to install/uninstall the ops agent in GCE.

## Usage

Functional examples are included in the [examples](./../../examples) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| agents\_rule | Whether to install or uninstall the agent, and which version to install. | `object({ package_state : string, version : string })` | <pre>{<br>  "package_state": "installed",<br>  "version": "latest"<br>}</pre> | no |
| assignment\_id | Resource name. Unique among policy assignments in the given zone | `string` | n/a | yes |
| instance\_filter | Filter to select VMs. Structure is documented below here: https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/os_config_os_policy_assignment. | <pre>object({<br>    all : optional(bool),<br>    // excludes a VM if it contains all label-value pairs for some element in the list<br>    exclusion_labels : optional(list(object({<br>      labels : map(string)<br>    })), []),<br>    // includes a VM if it contains all label-value pairs for some element in the list<br>    inclusion_labels : optional(list(object({<br>      labels : map(string)<br>    })), []),<br>    // includes a VM if its inventory data matches at least one of the following inventories<br>    inventories : optional(list(object({<br>      os_short_name : string,<br>      os_version : string<br>    })), []),<br>  })</pre> | n/a | yes |
| project | The ID of the project in which to provision resources. If not present, uses the provider ID | `string` | `null` | no |
| zone | The location to which policy assignments are applied to. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| ops\_agent\_policy | The generated policy for installing/uninstalling the ops agent. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
