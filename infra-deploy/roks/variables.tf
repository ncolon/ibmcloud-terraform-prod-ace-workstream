variable "region" {
  type = string
}

variable "resource_group_id" {
  type = string
}

variable "cluster_id" {
  type = string
}

variable "vpc_id" {
  type = string
}

variable "kube_version" {
  type = string
}

variable "worker_flavor" {
  type = string
}

variable "workers_per_zone" {
  type = number
}

variable "subnet_ids" {
  type = list(string)
}
