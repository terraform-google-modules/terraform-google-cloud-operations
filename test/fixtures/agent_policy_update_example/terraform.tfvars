description = null
agent_rules = [
  {
    type               = "logging"
    version            = "1.*.*"
    package_state      = "installed"
    enable_autoupgrade = true
  }
]
group_labels = null
os_types = [
  {
    short_name = "rhel"
    version    = "8.2"
  },
]
zones     = null
instances = null
