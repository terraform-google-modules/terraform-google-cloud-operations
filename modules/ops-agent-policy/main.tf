/**
 * Copyright 2020 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  is_install = var.ops_agent.package_state == "installed" 
  is_pin_to_version = length(regexall("2\\.\\d+\\.\\d+", var.ops_agent.version)) > 0
  file_path = (local.is_install && local.is_pin_to_version ? "pin_to_version_install/policy_pin_to_version_install.yaml" : (
               local.is_install ? "major_version_install/policy_major_version_install.yaml" : (
               "uninstall/policy_uninstall.yaml")))
  file = file("${path.module}/${local.file_path}")
  repo_suffix = replace(var.ops_agent.version, ".*.*", "")
  os_policies = yamldecode(replace(local.file, "$agent_version", local.repo_suffix))
}

resource "google_os_config_os_policy_assignment" "ops_agent_policy" {

  instance_filter {
    all = var.instance_filter.all
    dynamic "exclusion_labels" {
      for_each = var.instance_filter.exclusion_labels
      content {
        labels = exclusion_labels.value["labels"]
      }
    } 
    dynamic "inclusion_labels" {
      for_each = var.instance_filter.inclusion_labels
      content {
        labels = inclusion_labels.value["labels"]
      }
    }
    dynamic "inventories" {
      for_each = var.instance_filter.inventories
      content {
        os_short_name = inventories.value["os_short_name"]
        os_version = inventories.value["os_version"]
      }
    } 
  }

  location = var.zone
  name     = var.assignment_id


  os_policies {
    id   = local.os_policies.id
    mode = local.os_policies.mode
    allow_no_resource_group_match = local.os_policies.allowNoResourceGroupMatch
    description = "TODO DO NOT SUBMIT"

    dynamic "resource_groups" {
      for_each = local.os_policies.resourceGroups
      content {
        dynamic "inventory_filters" {
          for_each = resource_groups.value.inventoryFilters
          content {
            os_short_name = inventory_filters.value.osShortName
            os_version    = try(inventory_filters.value.osVersion, "")
          }
        }
        
        dynamic "resources" {
          for_each = resource_groups.value.resources
          content {
            id = resources.value.id
             
            dynamic "pkg" {
              for_each = try(resources.value.pkg[*], [])
              content {
                desired_state = pkg.value.desiredState
                dynamic "apt" {
                  for_each = try(pkg.value.apt[*], [])
                  content {
                    name = apt.value.name
                  }
                }
                
                dynamic "deb" {
                  for_each = try(pkg.value.deb[*], [])
                  content {
                    source {
                      
                      dynamic "remote" {
                        for_each = try(deb.value.source.remote[*], [])
                        content {
                          uri = remote.value.uri
                          sha256_checksum = try(remote.value.sha256Checksum, null)
                        }
                      }
                      dynamic "gcs" {
                        for_each = try(deb.value.source.gcs[*], [])
                        content {
                          bucket = gcs.value.bucket
                          object = gcs.value.object
                          generation = try(gcs.value.generation, null)
                        }
                      }
                      local_path = try(deb.value.source.localPath, null)
                      allow_insecure = try(deb.value.source.allowInsecure, false)
                      
                    }
                    pull_deps = try(deb.value.pullDeps, null)
                    
                  }
                }
                
                dynamic "yum" {
                  for_each = try(pkg.value.yum[*], [])
                  content {
                    name = yum.value.name
                  }
                }
                
                dynamic "zypper" {
                  for_each = try(pkg.value.zypper[*], [])
                  content {
                    name = zypper.value.name
                  }
                }
                
                dynamic "rpm" {
                  for_each = try(pkg.value.rpm[*], [])
                  content {
                    source {
                      dynamic "remote" {
                        for_each = try(rpm.value.source.remote[*], [])
                        content {
                          uri = remote.value.uri
                          sha256_checksum = try(remote.value.sha256Checksum, null)
                        }
                      }
                      dynamic "gcs" {
                        for_each = try(rpm.value.source.gcs[*], [])
                        content {
                          bucket = gcs.value.bucket
                          object = gcs.value.object
                          generation = try(gcs.value.generation, null)
                        }
                      }
                      local_path = try(rpm.value.source.localPath, null)
                      allow_insecure = try(rpm.value.source.allowInsecure, false)
                    }
                    pull_deps = try(rpm.value.pullDeps, null)
                  }
                }
                
                dynamic "googet" {
                  for_each = try(pkg.value.googet[*], [])
                  content {
                    name = googet.value.name
                  }
                }


                dynamic "msi" {
                  for_each = try(pkg.value.msi[*], [])
                  content {
                    source {
                      dynamic "remote" {
                        for_each = try(msi.value.source.remote[*], [])
                        content {
                          uri = remote.value.uri
                          sha256_checksum = try(remote.value.sha256Checksum, null)
                        }
                      }
                      dynamic "gcs" {
                        for_each = try(msi.value.source.gcs[*], [])
                        content {
                          bucket = gcs.value.bucket
                          object = gcs.value.object
                          generation = try(gcs.value.generation, null)
                        }
                      }
                      local_path = try(msi.value.source.localPath, null)
                      allow_insecure = try(msi.value.source.allowInsecure, false)
                    }
                    properties = try(msi.value.properties, null)
                  }
                }
                
                
              }
            } 
            dynamic "repository" {
              for_each = try(resources.value.repository[*], [])
              content {
                dynamic "apt" {
                  for_each = try(repository.value.apt[*], [])
                  content {
                    archive_type = apt.value.archiveType
                    uri = apt.value.uri
                    distribution = apt.value.distribution
                    components = apt.value.components
                    gpg_key = try(apt.value.gpg_key, null)
                  }
                }
                dynamic "yum" {
                  for_each = try(repository.value.yum[*], [])
                  content {
                    id = yum.value.id
                    display_name = try(yum.value.displayName, null)
                    base_url = yum.value.baseUrl
                    gpg_keys = try(yum.value.gpgKeys, null)
                  }
                }
                dynamic "zypper" {
                  for_each = try(repository.value.zypper[*], [])
                  content {
                    id = zypper.value.id
                    display_name = try(zypper.value.displayName, null)
                    base_url = zypper.value.baseUrl
                    gpg_keys = try(zypper.value.gpgKeys, null)
                  }
                }
                dynamic "goo" {
                  for_each = try(repository.value.goo[*], [])
                  content {
                    name = goo.value.name 
                    url = goo.value.url
                  }
                }

              }
            }
            dynamic "exec" {
              for_each = try(resources.value.exec[*], [])
              content {
                validate {
                  dynamic "file" {
                    for_each = try(exec.value.validate.file[*], [])
                    content {
                      dynamic "remote" {
                        for_each = try(file.value.remote[*], [])
                        content {
                          uri = remote.value.uri
                          sha256_checksum = try(remote.value.sha256Checksum, null)
                        }
                        
                      }
                      dynamic "gcs" {
                        for_each = try(file.value.gcs[*], [])
                        content {
                          bucket = gcs.value.bucket
                          object = gcs.value.object
                          generation = try(gcs.value.generation, null)
                        }
                      }
                      local_path = try(file.value.localPath, null)
                      allow_insecure = try(file.value.allowInsecure, null)

                    }
                    
                  }
                  script = try(exec.value.validate.script, null)
                  args = try(exec.value.validate.args, null)
                  interpreter = exec.value.validate.interpreter
                  output_file_path = try(exec.value.validate.outputFilePath, null)
                  
                }


                dynamic "enforce" {
                  for_each = try(exec.value.enforce[*], [])
                  content {
                    dynamic "file" {
                      for_each = try(enforce.value.file[*], [])
                      content {
                        dynamic "remote" {
                          for_each = try(file.value.remote[*], [])
                          content {
                            uri = remote.value.uri
                            sha256_checksum = try(remote.value.sha256Checksum, null)
                          }
                          
                        }
                        dynamic "gcs" {
                          for_each = try(file.value.gcs[*], [])
                          content {
                            bucket = gcs.value.bucket
                            object = gcs.value.object
                            generation = try(gcs.value.generation, null)
                          }
                        }
                        local_path = try(file.value.localPath, null)
                        allow_insecure = try(file.value.allowInsecure, null)

                      }
                      
                    }
                    script = try(enforce.value.script, null)
                    args = try(enforce.value.args, null)
                    interpreter = enforce.value.interpreter
                    output_file_path = try(enforce.value.outputFilePath, null)
                    
                  }
                }
              }
            }
            dynamic "file" {
              for_each = try(resources.value.file[*], [])

              content {
                dynamic "file" {
                  for_each = try(file.value.file, [])

                  content {
                    dynamic "remote" {
                        for_each = try(file.value.remote[*], [])
                        content {
                          uri = remote.value.uri
                          sha256_checksum = try(remote.value.sha256Checksum, null)
                        }
                      }
                      dynamic "gcs" {
                        for_each = try(file.value.gcs[*], [])
                        content {
                          bucket = gcs.value.bucket
                          object = gcs.value.object
                          generation = try(gcs.value.generation, null)
                        }
                      }
                      local_path = try(file.value.localPath, null)
                      allow_insecure = try(file.value.allowInsecure, null)
                  }

                  
                }
                content = try(file.value.content, null)
                path = file.value.path
                state = file.value.state
              }
              
            }
          }
        }
      }
    }
  }


  rollout {
    disruption_budget {
      percent = 10
    }

    min_wait_duration = "3s"
  }

  description = "A test os policy assignment"
  project = var.project
  skip_await_rollout = true
}
