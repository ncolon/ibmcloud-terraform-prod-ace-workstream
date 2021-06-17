terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "~> 1.12.0"
    }
  }
}

resource "ibm_resource_instance" "cos_instance" {
  name     = "cos-${var.cluster_id}"
  service  = "cloud-object-storage"
  plan     = "standard"
  location = "global"
}

resource "ibm_container_vpc_cluster" "roks" {
  name              = "roks-${var.cluster_id}"
  kube_version      = var.kube_version
  vpc_id            = var.vpc_id
  flavor            = var.worker_flavor
  worker_count      = var.workers_per_zone
  entitlement       = "cloud_pak"
  cos_instance_crn  = ibm_resource_instance.cos_instance.id
  resource_group_id = var.resource_group_id
  zones {
    subnet_id = var.subnet_ids[0]
    name      = "${var.region}-1"
  }
}

resource "ibm_container_vpc_worker_pool" "zone2" {
  cluster           = ibm_container_vpc_cluster.roks.name
  worker_pool_name  = "zone2"
  flavor            = var.worker_flavor
  vpc_id            = var.vpc_id
  worker_count      = var.workers_per_zone
  entitlement       = "cloud_pak"
  resource_group_id = var.resource_group_id
  zones {
    subnet_id = var.subnet_ids[1]
    name      = "${var.region}-2"
  }
}

resource "ibm_container_vpc_worker_pool" "zone3" {
  cluster           = ibm_container_vpc_cluster.roks.name
  worker_pool_name  = "zone3"
  flavor            = var.worker_flavor
  vpc_id            = var.vpc_id
  worker_count      = var.workers_per_zone
  entitlement       = "cloud_pak"
  resource_group_id = var.resource_group_id
  zones {
    subnet_id = var.subnet_ids[2]
    name      = "${var.region}-3"
  }
}
