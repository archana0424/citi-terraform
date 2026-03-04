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
