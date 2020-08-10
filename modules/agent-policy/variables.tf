terraform {
  experiments = [variable_validation]
}

variable "project_id" {
  description = "The ID of the project."
  type = string
}

variable "policy_id" {
  description = "The ID of the policy."
  type = string
}

variable "description" {
  description = "The description of the policy."
  type = string
  default = null
}

variable "agent_rules" {
  description = "A list of agent rules to be enforced by the policy."
  type = list(any)

  validation {
    condition = can([for agent_rule in var.agent_rules: agent_rule["type"]])
    error_message = "Each agent rule must have a type."
  }
}

variable "group_labels" {
  description = "A list of label maps to filter instances to apply policies on."
  type = list(list(object({
    name = string
    value = string
  })))
  default = null
}

variable "os_types" {
  description = "A list of label maps to filter instances to apply policies on."
  type = list(any)

  validation {
    condition = can([for os_type in var.os_types: os_type["short_name"]])
    error_message = "Each os type must have a short_name."
  }
}

variable "zones" {
  description = "A list of zones to filter instances to apply the policy."
  type = list(string)
  default = null
}

variable "instances" {
  description = "A list of zones to filter instances to apply the policy."
  type = list(string)
  default = null
}
