vpc1_name = "vpc-app-dev"
vpc2_name = "vpc-onprem-sim"

vpc1_subnets = {
  a = { name = "sub-a", cidr = "10.10.1.0/24", region = "us-central1" }
  b = { name = "sub-b", cidr = "10.10.2.0/24", region = "us-central1" }
}

vpc2_subnets = {
  a = { name = "ops-a", cidr = "10.20.1.0/24", region = "us-central1" }
  b = { name = "ops-b", cidr = "10.20.2.0/24", region = "us-central1" }
}