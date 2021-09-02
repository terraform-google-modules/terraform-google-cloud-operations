
// Configure the Google Cloud provider
provider "google" {
  credentials = file("test-key.json")
  project     = var.gcp_project
  region      = var.gcp_region
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}


// A Single Compute Engine instance
resource "google_compute_instance" "default" {
 name         = "terraform-test-vm"
 machine_type = "f1-micro"
 zone         = var.gcp_zone

 boot_disk {
   initialize_params {
     image = "centos-cloud/centos-8-v20210817"
   }
 }
 labels = {
    env = "prod"
    app = "myproduct"
    created_by = "terraform"
  }

 network_interface {
   network = "default"

   access_config {
     // Include this section to give the VM an external ip address
   }
 }
 service_account {
    // Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    // This non production example uses the default compute service account. 
    email  = var.service_account_email
    scopes = ["cloud-platform"]
 }
}

// Cloud Ops Agent Policy
module "agent_policy" {
  source     = "terraform-google-modules/cloud-operations/google//modules/agent-policy"
  version    = "~> 0.1.0"

  project_id = var.gcp_project
  policy_id  = "ops-agents-example-policy"
  agent_rules = [
    {
      type               = "ops-agent"
      version            = "current-major"
      package_state      = "installed"
      enable_autoupgrade = true
    },
  ]
  group_labels = [
    {
      env = "prod"
      app = "myproduct"
      created_by = "terraform"
    }
  ]

  os_types = [
    {
      short_name = "centos"
      version    = "8"
    },
  ]
}
