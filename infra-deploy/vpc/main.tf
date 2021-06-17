terraform {
  required_providers {
    ibm = {
      source  = "IBM-Cloud/ibm"
      version = "~> 1.12.0"
    }
  }
}

provider "ibm" {
  region = var.region
}


resource "ibm_is_vpc" "vpc" {
  name           = var.cluster_id
  resource_group = var.resource_group_id
}

resource "ibm_is_subnet" "subnet" {
  count           = 3
  name            = "subnet${count.index + 1}"
  vpc             = ibm_is_vpc.vpc.id
  zone            = "${var.region}-${count.index + 1}"
  ipv4_cidr_block = cidrsubnet(var.vpc_cidr, 2, count.index)
  public_gateway  = ibm_is_public_gateway.gateway[count.index].id
  depends_on = [
    ibm_is_vpc.vpc
  ]
}

resource "ibm_is_public_gateway" "gateway" {
  count = 3
  name  = "gateway-zone-${count.index + 1}"
  vpc   = ibm_is_vpc.vpc.id
  zone  = "${var.region}-${count.index + 1}"
}
