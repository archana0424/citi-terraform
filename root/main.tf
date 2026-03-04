module "vpc1" {
  source               = "../../modules/vpc"
  name                 = var.vpc1_name
  delete_default_routes = true
  subnets              = var.vpc1_subnets
}

module "vpc2" {
  source               = "../../modules/vpc"
  name                 = var.vpc2_name
  delete_default_routes = true
  subnets              = var.vpc2_subnets
}

module "peering_vpc1_vpc2" {
  source              = "./modules/vpc-peering"
  local_vpc_name      = module.vpc1.network_name
  peer_vpc_name       = module.vpc2.network_name
  local_vpc_self_link = module.vpc1.network_self_link
  peer_vpc_self_link  = module.vpc2.network_self_link
}

module "vm_a" {
  source         = "./modules/compute_vm"
  name           = var.vm1_name
  zone           = "${var.region}-a"
  network        = module.vpc1.network_self_link
  subnet         = module.vpc1.subnet_self_links["a"]
  tags           = ["web"]
  sa_email       = var.deploy_sa_email
  startup_script = "apt-get update -y && apt-get install -y nginx"
}

module "vm_b" {
  source         = "./modules/compute_vm"
  name           = var.vm2_name
  zone           = "${var.region}-b"
  network        = module.vpc1.network_self_link
  subnet         = module.vpc1.subnet_self_links["b"]
  sa_email       = var.deploy_sa_email
  startup_script = "apt-get update -y && apt-get install -y apache2"
}