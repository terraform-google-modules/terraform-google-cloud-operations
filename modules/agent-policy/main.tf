module "gcloud" {
  source  = "terraform-google-modules/gcloud/google"

  platform = "linux"
  additional_components = ["alpha", "beta"]

  create_cmd_entrypoint = "${path.module}/scripts/create-update-script.sh"
  create_cmd_body       = "${var.project_id} ${var.policy_id} ${jsonencode(var.description == null ? "" : var.description)} ${base64encode(jsonencode(var.agent_rules))} ${base64encode(jsonencode(var.group_labels == null ? [] : var.group_labels))} ${base64encode(jsonencode(var.os_types))} ${base64encode(jsonencode(var.zones == null ? [] : var.zones))} ${base64encode(jsonencode(var.instances == null ? [] : var.instances))}"

  destroy_cmd_entrypoint = "gcloud"
  destroy_cmd_body       = "alpha compute instances ops-agents policies delete ${var.policy_id} --project=${var.project_id}"
}