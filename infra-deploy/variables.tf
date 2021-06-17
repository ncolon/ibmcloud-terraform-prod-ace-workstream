variable "region" {
  type        = string
  description = "IBM Cloud Region to deploy into"
}

variable "vpc_resrouce_group_name" {
  type        = string
  description = "IBM Cloud resource group to deploy VPC"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.240.0.0/16"
  description = "CIDR for IBM Cloud VPC"
}

variable "kube_version" {
  type        = string
  default     = "4.6.28_openshift"
  description = "Version of Kubernetes to deploy"
}

variable "worker_flavor" {
  type        = string
  default     = ""
  description = "Size of nodes in worker pools"
}

variable "workers_per_zone" {
  type        = number
  default     = 2
  description = "Number of nodes per worker pool. Minimum of 2 per zone"
  validation {
    condition     = var.workers_per_zone > 1
    error_message = "Workers_per_zone must be 2 or greater."
  }
}
