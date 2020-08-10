module "agent-policy" {
  source        = "./agent-policy"
  project_id    = "code-lab-280417"
  policy_id     = "ops-agents-test-policy-fresh"
  description   = "an example policy description"
  agent_rules = [
    {
      type               = "logging"
      version            = "current-major"
      package_state      = "installed"
      enable_autoupgrade = true
    },
  ]
  group_labels = [
    [
      {
        name  = "env"
        value = "prod"
      }, 
      {
        name  = "product"
        value = "myapp"
      },
    ],
    [
      {
        name  = "env"
        value = "staging"
      }, 
      {
        name  = "product"
        value = "myapp"
      },
    ],
  ]
  os_types = [
    {
      short_name = "centos"
      version    = "8"
    },
  ]
  zones = null
}