project_id      = "terraform-488518"
region          = "us-central1"

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

vm1_name        = "frontend-vm"
vm2_name        = "backend-vm"
vm_image        = "debian-cloud/debian-12"
vm_machine_type = "e2-micro"

vm1_startup_script = "apt-get update -y && apt-get install -y iperf3"
vm2_startup_script = "apt-get update -y && apt-get install -y nginx iperf3"