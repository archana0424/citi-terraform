module "vpc1" {
  source               = "../modules/vpc"
  name                 = var.vpc1_name
  delete_default_routes = true
  subnets              = var.vpc1_subnets
}

module "vpc2" {
  source               = "../modules/vpc"
  name                 = var.vpc2_name
  delete_default_routes = true
  subnets              = var.vpc2_subnets
}

module "peering_vpc1_vpc2" {
  source              = "../modules/peering"
  local_vpc_name      = module.vpc1.network_name
  peer_vpc_name       = module.vpc2.network_name
  local_vpc_self_link = module.vpc1.network_self_link
  peer_vpc_self_link  = module.vpc2.network_self_link
}

module "vm_a" {
  source         = "../modules/compute_vm"
  name           = var.vm1_name
  zone           = "${var.region}-a"
  network        = module.vpc1.network_self_link
  subnet         = module.vpc1.subnet_self_links["a"]
  tags           = ["web"]
  machine_type = var.machine_type
  image        = var.image
  sa_email       = var.deploy_sa_email
  startup_script = "apt-get update -y && apt-get install -y nginx"
}

module "vm_b" {
  source         = "../modules/compute_vm"
  name           = var.vm2_name
  zone           = "${var.region}-b"
  network        = module.vpc1.network_self_link
  subnet         = module.vpc1.subnet_self_links["b"]
  sa_email       = var.deploy_sa_email
  machine_type = var.machine_type
  image        = var.image
  startup_script = "apt-get update -y && apt-get install -y apache2"
}
/*  Classic VPN Setup (Static Routes)
module "vpn_vpc_a" {
  source            = "../modules/vpn"
  vpn_gateway_name  = "vpc-a"
  vpc_name          = module.vpc_a.vpc_name
  vpc_self_link     = module.vpc_a.vpc_self_link
  region            = var.region
  peer_ip           = module.vpn_vpc_b.vpn_gateway_ip   # dynamically connected
  shared_secret     = var.vpn_shared_secret
  local_cidr        = var.vpc_a_cidr
  remote_cidr       = var.vpc_b_cidr
}

module "vpn_vpc_b" {
  source            = "../modules/vpn"
  vpn_gateway_name  = "vpc-b"
  vpc_name          = module.vpc_2.vpc_name
  vpc_self_link     = module.vpc_b.vpc_self_link
  region            = var.region
  peer_ip           = module.vpn_vpc_a.vpn_gateway_ip   # dynamically connected
  shared_secret     = var.vpn_shared_secret
  local_cidr        = var.vpc_b_cidr
  remote_cidr       = var.vpc_a_cidr
}
*/
module "ha_vpn_a" {
  source                   = "../modules/vpn"
  name                     = "vpn-a"
  vpc_self_link            = module.vpc1.vpc_self_link   # fixed name
  region                   = var.region
  peer_gateway_ip          = module.ha_vpn_b.gateway_ip  # requires output in vpn module
  local_asn                = var.vpc_a_asn
  peer_asn                 = var.vpc_b_asn
  bgp_interface_cidr_local = var.bgp_interface_cidr_a
  bgp_interface_peer_ip    = var.bgp_peer_ip_a
  shared_secret            = var.vpn_shared_secret
}

module "ha_vpn_b" {
  source                   = "../modules/vpn"
  name                     = "vpn-b"
  vpc_self_link            = module.vpc2.vpc_self_link   # fixed name
  region                   = var.region
  peer_gateway_ip          = module.ha_vpn_a.gateway_ip  # requires output in vpn module
  local_asn                = var.vpc_b_asn
  peer_asn                 = var.vpc_a_asn
  bgp_interface_cidr_local = var.bgp_interface_cidr_b
  bgp_interface_peer_ip    = var.bgp_peer_ip_b
  shared_secret            = var.vpn_shared_secret
}
module "firewall" {
  source       = "../modules/firewall_rule"
  network_name = var.fw_network_name
  rules        = var.fw_rules
}
module "external_lb" {
  source            = "../modules/load_balancer"
  lb_name           = "web-external-lb"
  lb_scheme         = "EXTERNAL"
  lb_port_range     = "80"
  backend_instances = [
    module.vm_a.self_link,
    module.vm_b.self_link
  ]
  network           = module.vpc1.network_self_link
  subnetwork        = null
  health_check_port = 80
}

module "internal_lb" {
  source            = "../modules/load_balancer"
  lb_name           = "app-internal-lb"
  lb_scheme         = "INTERNAL"
  lb_port_range     = "8080"
  backend_instances = [
    module.vm_a.self_link,
    module.vm_b.self_link
  ]
  network           = module.vpc1.network_self_link
  subnetwork        = module.vpc1.subnet_self_links["a"]
  health_check_port = 8080
}
module "public_dns" {
  source          = "../modules/cloud_dns"
  zone_name       = var.public_dns_zone_name
  zone_domain     = var.public_dns_domain
  zone_visibility = "public"
  records         = var.public_dns_records
}

module "private_dns" {
  source          = "../modules/cloud_dns"
  zone_name       = var.private_dns_zone_name
  zone_domain     = var.private_dns_domain
  zone_visibility = "private"
  records         = var.private_dns_records
  private_networks = var.private_dns_networks
}