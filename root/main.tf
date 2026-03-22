locals {
  fw_rules = {
    for key, rule in var.fw_rules :
    key => merge(rule, key == "ssh" ? {
      target_service_accounts = [var.deploy_sa_email]
    } : {})
  }
}
################################
# VPC NETWORKS
################################

module "vpc1" {
  source                = "../modules/vpc"
  name                  = var.vpc1_name
  delete_default_routes = true
  subnets               = var.vpc1_subnets
}

module "vpc2" {
  source                = "../modules/vpc"
  name                  = var.vpc2_name
  delete_default_routes = true
  subnets               = var.vpc2_subnets
}

################################
# VPC PEERING
################################

module "peering_vpc1_vpc2" {
  source              = "../modules/peering"
  local_vpc_name      = module.vpc1.network_name
  peer_vpc_name       = module.vpc2.network_name
  local_vpc_self_link = module.vpc1.network_self_link
  peer_vpc_self_link  = module.vpc2.network_self_link
}

################################
# COMPUTE INSTANCES
################################

module "vm_a" {
  source = "../modules/compute_vm"

  name = var.vm1_name
  zone = "${var.region}-a"

  network = module.vpc1.network_self_link
  subnet  = module.vpc1.subnet_self_links["a"]

  tags = ["web"]

  machine_type = var.vm_machine_type
  image        = var.vm_image
  sa_email     = var.deploy_sa_email

  startup_script = "apt-get update -y && apt-get install -y nginx"
}

module "vm_b" {
  source = "../modules/compute_vm"

  name = var.vm2_name
  zone = "${var.region}-b"

  network = module.vpc1.network_self_link
  subnet  = module.vpc1.subnet_self_links["b"]

  machine_type = var.vm_machine_type
  image        = var.vm_image
  sa_email     = var.deploy_sa_email

  startup_script = "apt-get update -y && apt-get install -y apache2"
}

################################
# HA VPN CONFIGURATION
################################

module "ha_vpn_a" {
  source = "../modules/vpn"

  name          = "vpn-a"
  region        = var.region
  vpc_self_link = module.vpc1.network_self_link

  peer_gateway_ip = module.ha_vpn_b.gateway_ip

  local_asn = var.vpc_a_asn
  peer_asn  = var.vpc_b_asn

  bgp_interface_cidr_local = var.bgp_interface_cidr_a
  bgp_interface_peer_ip    = var.bgp_peer_ip_a

  shared_secret = var.vpn_shared_secret
}

module "ha_vpn_b" {
  source = "../modules/vpn"

  name          = "vpn-b"
  region        = var.region
  vpc_self_link = module.vpc2.network_self_link

  peer_gateway_ip = module.ha_vpn_a.gateway_ip

  local_asn = var.vpc_b_asn
  peer_asn  = var.vpc_a_asn

  bgp_interface_cidr_local = var.bgp_interface_cidr_b
  bgp_interface_peer_ip    = var.bgp_peer_ip_b

  shared_secret = var.vpn_shared_secret
}

################################
# FIREWALL RULES
################################

module "firewall" {
  source = "../modules/firewall_rule"

  network_name = module.vpc1.network_name
  rules        = local.fw_rules
}
################################
# EXTERNAL LOAD BALANCER
################################

module "external_lb" {
  source = "../modules/load_balancer"

  lb_name       = "web-external-lb"
  lb_scheme     = "EXTERNAL"
  lb_port_range = "80"

  backend_instances = [
    module.vm_a.self_link,
    module.vm_b.self_link
  ]

  network    = module.vpc1.network_self_link
  subnetwork = null

  health_check_port = 80
}

################################
# INTERNAL LOAD BALANCER
################################

module "internal_lb" {
  source = "../modules/load_balancer"

  lb_name       = "app-internal-lb"
  lb_scheme     = "INTERNAL"
  lb_port_range = "80"

  backend_instances = [
    module.vm_a.self_link,
    module.vm_b.self_link
  ]

  network    = module.vpc1.network_self_link
  subnetwork = module.vpc1.subnet_self_links["a"]

  health_check_port = 80
}

################################
# PUBLIC CLOUD DNS
################################

module "public_dns" {
  source = "../modules/cloud_dns"

  zone_name       = var.public_dns_zone_name
  zone_domain     = var.public_dns_domain
  zone_visibility = "public"

  records = var.public_dns_records
}

################################
# PRIVATE CLOUD DNS
################################

module "private_dns" {
  source = "../modules/cloud_dns"

  zone_name       = var.private_dns_zone_name
  zone_domain     = var.private_dns_domain
  zone_visibility = "private"

  records = var.private_dns_records

  private_networks = [
    module.vpc1.network_self_link
  ]
}

module "cloud_nat_app_dev" {
  source      = "../modules/cloud_nat"
  project_id  = var.project_id
  region      = var.region
  vpc_name    = var.vpc1_name
  subnet_name = var.vpc1_subnets["a"].name
}

module "routes_app_dev" {
  source                 = "../modules/routes"
  router_name            = "app-dev-custom-route"
  network                = var.vpc1_name
  dest_range             = "0.0.0.0/0"
  next_hop_instance      = module.vm_a.self_link 
  next_hop_instance_zone = "us-central1-a"
  priority               = 900
}

module "disks" {
  source    = "../modules/disks"
  disk_name = var.disk_name
  disk_size = var.disk_size
  zone      = var.zone
  vm_name   = module.vm_a.vm_name
}

module "snapshot_vm_a" {
  source = "../modules/snapshots"

  snapshot_name = "vm-a-snapshot"
  source_disk = module.vm_a.boot_disk_self_link
  new_vm_name  = "vm-a-restored"
  machine_type = var.vm_machine_type
  zone         = "${var.region}-a"
  network = var.network
  subnet  = var.subnet
  sa_email = var.deploy_sa_email
}
module "template" {
  source = "../modules/instance_template"

  name_prefix = "web-template"
  machine_type = "e2-medium"
  image = "debian-cloud/debian-11"
  network = module.vpc1.network_self_link
  subnet  = module.vpc1.subnet_self_links["a"]
  sa_email = var.deploy_sa_email

  startup_script = <<EOF
#!/bin/bash
apt-get update -y
apt-get install -y nginx
echo "Hello from $(hostname)" > /var/www/html/index.html
systemctl restart nginx
EOF

  tags = ["web"]
}

module "mig" {
  source = "../modules/mig"

  mig_name = "web-mig"
  base_instance_name = "web"

  zone = var.zone

  instance_template = module.template.template_self_link

  target_size = 2
  min_replicas = 2
  max_replicas = 5
}

module "http_lb" {
  source = "../modules/http_lb"

  name = "web-lb"

  instance_group = module.mig.instance_group
}
module "gke_cluster" {
  source = "../modules/GKE_cluster"

  cluster_name   = var.gke_cluster_name
  region         = var.gke_region
  network        = module.vpc1.network_self_link
  subnetwork     = module.vpc1.subnet_self_links["a"]
  node_pool_name = var.gke_node_pool
  node_count     = var.gke_node_count
  machine_type   = var.gke_machine_type
  hello_image    = var.gke_hello_image
  deploy_sa_email = var.deploy_sa_email
}

module "k8s_app" {
  source = "../modules/K8s_app"
  cluster_endpoint = module.gke_cluster.endpoint
}