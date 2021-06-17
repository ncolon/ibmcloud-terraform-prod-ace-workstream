resource "ibm_cis" "cis_instance" {
  name              = var.cluster_prefix
  plan              = "standard"
  resource_group_id = var.resource_group_id
  location          = "global"

  //User can increase timeouts
  timeouts {
    create = "15m"
    update = "15m"
    delete = "15m"
  }
}

resource "ibm_cis_domain" "cis_domain" {
  domain = var.glb_domain
  cis_id = ibm_cis.instance.id
}

resource "ibm_cis_healthcheck" "https_hc" {
  cis_id         = ibm_cis.instance.id
  expected_body  = "alive"
  expected_codes = "2xx"
  method         = "GET"
  timeout        = 7
  path           = "/"
  interval       = 60
  retries        = 3
  description    = "HTTPS HealthCheck"
}
