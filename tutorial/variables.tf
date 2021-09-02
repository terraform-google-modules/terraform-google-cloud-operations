variable "gcp_region" {
  description = "GCP region"
  type        = string
  default     = "us-central1"
}

variable "gcp_zone" {
    description = "GCP Zone"
    type        = string
    default     = "us-central1-a"
}

variable "gcp_project" {
    description = "GCP Project"
    type        = string
}

variable "service_account_email" {
    description = "Service Account Email"
    type        = string
}