terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "~> 1.12.0"
    }
  }
}

resource "random_string" "id" {
  length  = 5
  special = false
  upper   = false
}

# Configure the IBM Provider

locals {
  cluster_id = "${var.cluster_prefix}-${random_string.id.result}"
}

resource "ibm_resource_group" "rg" {
  name = "${local.cluster_id}-rg"
}

resource "ibm_resource_group" "glb" {
  name = "glb-${local.cluster_id}-rg"
}


# Terraform Limitation
# │ Error: Module module.vpc contains provider configuration
# │
# │ Providers cannot be configured within modules using count, for_each or depends_on.


module "vpc_region1" {
  source            = "./vpc"
  resource_group_id = ibm_resource_group.rg.id
  region            = var.regions[0]
  cluster_id        = local.cluster_id
  vpc_cidr          = var.vpc_cidrs[0]
}

module "vpc_region2" {
  source            = "./vpc"
  resource_group_id = ibm_resource_group.rg.id
  region            = var.regions[1]
  cluster_id        = local.cluster_id
  vpc_cidr          = var.vpc_cidrs[1]
}


module "roks_region1" {
  source            = "./roks"
  resource_group_id = ibm_resource_group.rg.id
  region            = var.regions[0]
  vpc_id            = module.vpc_region1.vpc_id
  cluster_id        = local.cluster_id
  kube_version      = var.kube_version
  worker_flavor     = var.worker_flavor
  workers_per_zone  = var.workers_per_zone
  subnet_ids        = module.vpc_region1.subnet_ids
}

module "roks_region2" {
  source            = "./roks"
  resource_group_id = ibm_resource_group.rg.id
  region            = var.regions[1]
  vpc_id            = module.vpc_region1.vpc_id
  cluster_id        = local.cluster_id
  kube_version      = var.kube_version
  worker_flavor     = var.worker_flavor
  workers_per_zone  = var.workers_per_zone
  subnet_ids        = module.vpc_region1.subnet_ids
}

module "glb" {
  source            = "./glb"
  resource_group_id = ibm_resource_group.glb.id
}

# resource "ibm_is_vpc" "vpc" {
#   name           = "${var.region}-${random_string.id.result}"
#   resource_group = ibm_resource_group.vpc-rg.id
# }

# resource "ibm_is_subnet" "subnet" {
#   count           = 3
#   name            = "subnet${count.index + 1}"
#   vpc             = ibm_is_vpc.vpc.id
#   zone            = "${var.region}-${count.index + 1}"
#   ipv4_cidr_block = cidrsubnet(var.vcp_cidr, 2, count.index)
#   depends_on = [
#     ibm_is_vpc.vpc
#   ]
# }

# resource "ibm_resource_instance" "cos_instance" {
#   name     = "my_cos_instance"
#   service  = "cloud-object-storage"
#   plan     = "standard"
#   location = "global"
# }

# resource "ibm_container_vpc_cluster" "roks" {
#   name = "roks-${var.region}-${random_string.id.result}"
#   # name              = "roks-${var.cluster_prefix}-${random_string.id.result}"
#   kube_version      = "4.6.28_openshift"
#   vpc_id            = ibm_is_vpc.vpc.id
#   flavor            = "bx2.16x64"
#   worker_count      = "2"
#   entitlement       = "cloud_pak"
#   cos_instance_crn  = ibm_resource_instance.cos_instance.id
#   resource_group_id = ibm_resource_group.vpc-rg.id
#   # disable_public_service_endpoint = true
#   zones {
#     subnet_id = ibm_is_subnet.subnet[0].id
#     name      = "${var.region}-1"
#   }
# }

# resource "ibm_container_vpc_worker_pool" "zone2" {
#   cluster           = ibm_container_vpc_cluster.roks.name
#   worker_pool_name  = "zone2"
#   flavor            = "bx2.16x64"
#   vpc_id            = ibm_is_vpc.vpc.id
#   worker_count      = "2"
#   entitlement       = "cloud_pak"
#   resource_group_id = ibm_resource_group.vpc-rg.id
#   zones {
#     subnet_id = ibm_is_subnet.subnet[1].id
#     name      = "${var.region}-2"
#   }
# }

# resource "ibm_container_vpc_worker_pool" "zone3" {
#   cluster           = ibm_container_vpc_cluster.roks.name
#   worker_pool_name  = "zone3"
#   flavor            = "bx2.16x64"
#   vpc_id            = ibm_is_vpc.vpc.id
#   worker_count      = "2"
#   entitlement       = "cloud_pak"
#   resource_group_id = ibm_resource_group.vpc-rg.id
#   zones {
#     subnet_id = ibm_is_subnet.subnet[2].id
#     name      = "${var.region}-3"
#   }
# }
