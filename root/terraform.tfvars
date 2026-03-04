project_id      = "terraform-488518"
region          = "us-central1"
# ASNs for BGP
vpc_a_asn           = 64514
vpc_b_asn           = 64515
# Link-local IPs for BGP session
bgp_interface_cidr_a = "169.254.0.1/30"
bgp_interface_cidr_b = "169.254.0.2/30"
# Peer IPs for each side
bgp_peer_ip_a       = "169.254.0.2"
bgp_peer_ip_b       = "169.254.0.1"
vpn_shared_secret = "super-secure-secret"

vpc1_name = "vpc-app-dev"
vpc2_name = "vpc-onprem-sim"

vpc1_subnets = {
  a = { name = "sub-a", cidr = "10.10.1.0/24", region = "us-central1" }
  b = { name = "sub-b", cidr = "10.10.2.0/24", region = "us-central1" }
}

vpc2_subnets = {
  a = { name = "ops-a", cidr = "10.20.1.0/24", region = "us-central1" }
}

vm1_name        = "frontend-vm"
vm2_name        = "backend-vm"
vm_image        = "debian-cloud/debian-12"
vm_machine_type = "e2-micro"

vm1_startup_script = "apt-get update -y && apt-get install -y iperf3"
vm2_startup_script = "apt-get update -y && apt-get install -y nginx iperf3"