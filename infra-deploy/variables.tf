variable "regions" {
  type        = list(string)
  description = "IBM Cloud Region to deploy into"
}

variable "cluster_prefix" {
  type        = string
  description = "Prefix to use for IBM Cloud resources"
}

variable "vpc_cidrs" {
  type        = list(string)
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

variable "glb_domain" {
  type = string
}
