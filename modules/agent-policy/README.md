# Agent Policy

This module is used to install and manage metrics and logging agents in GCE.

## Usage

Basic usage of this module is as follows:

```hcl
module "agent_policy" {
  source     = "terraform-google-modules/cloud-operations/google/modules/agent-policy"
  project_id = "<PROJECT ID"
  policy_id  = "ops-agents-example-policy"
  agent_rules = [
    {
      type = "logging"
    },
  ]
  os_types = [
    {
      short_name = "centos"
      version    = "8"
    },
  ]
}
```

Functional examples are included in the [examples](./../../examples) directory.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| agent\_rules | A list of agent rules to be enforced by the policy. | list(any) | n/a | yes |
| description | The description of the policy. | string | `"null"` | no |
| group\_labels | A list of label maps to filter instances to apply policies on. | object | `"null"` | no |
| instances | A list of instances to filter instances to apply the policy. | list(string) | `"null"` | no |
| os\_types | A list of OS types to filter instances to apply the policy. | list(any) | n/a | yes |
| policy\_id | The ID of the policy. | string | n/a | yes |
| project\_id | The ID of the project in which to provision resources. | string | n/a | yes |
| zones | A list of zones to filter instances to apply the policy. | list(string) | `"null"` | no |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

### agent_rules variable

Each agent rule in the list of agent rules contains the following fields:

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| type | Type of agent to manage. Allowed values: `"logging"`, `"metrics"`. | string | n/a | yes |
| version | Version of the agent to install. Allowed values and formats: `"current-major"`, `"latest"`, `"MAJOR_VERSION.*.*"`, `"MAJOR_VERSION.MINOR_VERSION.PATCH_VERSION"`, `"5.5.2-BUILD_NUMBER"`. `"5.5.2-BUILD_NUMBER"` is only allowed if `type="metrics"`. | string | `"current-major"` | no |
| package\_state | Desired package state of the agent. Allowed values: `"installed"`, `"removed"`. | object | `"installed"` | no |
| enable\_autoupgrade | Whether to enable autoupgrade of the agent. Allowed values: `true`, `false`. | list(string) | `true` | no |

### group_labels variable

Group labels are represented as a list of label maps to filter instances that the policy applies to. Each label map is represented by a list of objects, and each object contains the following fields:

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| name | The name of the label. | string | n/a | yes |
| value | The value of the label. | string | n/a | yes |

### instances variable

Each item in the list must be in the format of `zones/ZONE_NAME/instances/INSTANCE_NAME`. To list all existing instances, run `gcloud compute instances list`.

### os_types variable

For now, exactly one OS type needs to be specified. Each OS type contains the following fields:

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| short_name | Short name of the OS. Allowed values: `"centos"`, `"debian"`, `"rhel"`, `"sles"`, `"sles_sap"`, `"ubuntu"`. | string | n/a | yes |
| version | Version of the OS. | string | n/a | yes |

To inspect the exact OS short name and version of an instance, run `gcloud beta compute instances os-inventory describe INSTANCE_NAME`.

### policy_id variable

This ID must start with `ops-agents-`, contain only lowercase letters, numbers, and hyphens, end with a number or a letter, be between 1-63 characters, and be unique within the project.

## Requirements

These sections describe requirements for using this module.

### Software

The following dependencies must be available:

- [Terraform][terraform] v0.12
- [Terraform Provider for GCP][terraform-provider-gcp] plugin v2.0
- [Google Cloud SDK][google-cloud-sdk]
- [curl][curl]

### Service Account

A service account with the following roles must be used to provision
the resources of this module:

- Logging Logs Writer: `roles/logging.logWriter`
- Monitoring Metric Writer: `roles/monitoring.metricWriter`
- OS Config GuestPolicy Admin: `roles/osconfig.guestPolicyAdmin`

The [Project Factory module][project-factory-module] and the
[IAM module][iam-module] may be used in combination to provision a
service account with the necessary roles applied.

### APIs

A project with the following APIs enabled must be used to host the
resources of this module:

* Google Cloud Logging API: `logging.googleapis.com`
* Google Cloud Monitoring API: `monitoring.googleapis.com`
* Google Cloud OS Config API: `osconfig.googleapis.com`
    * [OS Config Metadata][os-config-metadata]

The [Project Factory module][project-factory-module] can be used to
provision a project with the necessary APIs enabled.

## Testing



### Integration Testing

Instructions for how to run integration tests can be found in [CONTRIBUTING.md](./../../CONTRIBUTING.md#integration-testing)

### Unit Testing

To run unit tests, navigate to [test/agent-policy-tests](./../../test/agent-policy-tests), then run `./test-runner.py`.

## Contributing

Refer to the [contribution guidelines](./../../CONTRIBUTING.md) for
information on contributing to this module.

[iam-module]: https://registry.terraform.io/modules/terraform-google-modules/iam/google
[project-factory-module]: https://registry.terraform.io/modules/terraform-google-modules/project-factory/google
[terraform-provider-gcp]: https://www.terraform.io/docs/providers/google/index.html
[terraform]: https://www.terraform.io/downloads.html
[curl]: https://curl.haxx.se
[google-cloud-sdk]: https://cloud.google.com/sdk/install
[os-config-metadata]: https://cloud.google.com/compute/docs/manage-os#enable-metadata
