project_id      = "secure-theme-489603-d9"
region          = "us-central1"
# NAT vars
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

# VPC vars
vpc1_name = "vpc-app-dev"
vpc2_name = "vpc-onprem-sim"

vpc1_subnets = {
  a = { name = "sub-a", cidr = "10.10.1.0/24", region = "us-central1" }
  b = { name = "sub-b", cidr = "10.10.2.0/24", region = "us-central1" }
}

vpc2_subnets = {
  a = { name = "ops-a", cidr = "10.20.1.0/24", region = "us-central1" }
}

# VM vars
vm1_name        = "frontend-vm"
vm2_name        = "backend-vm"
vm_image        = "debian-cloud/debian-12"
vm_machine_type = "e2-micro"

vm1_startup_script = "apt-get update -y && apt-get install -y iperf3"
vm2_startup_script = "apt-get update -y && apt-get install -y nginx iperf3"

# firewall vars
fw_network_name = "vpc-app-dev"

fw_rules = {
  ssh = {
    name          = "allow-ssh"
    protocol      = "tcp"
    ports         = ["22"]
    source_ranges = ["35.235.240.0/20"]   # IAP proxy range
  }

  web = {
    name          = "allow-http-https"
    protocol      = "tcp"
    ports         = ["80", "443"]
    source_ranges = ["0.0.0.0/0"]
    target_tags   = ["web"]
  }

  icmp = {
    name          = "allow-icmp"
    protocol      = "icmp"
    ports         = []
    source_ranges = ["0.0.0.0/0"]
  }
}

# Public DNS zone
public_dns_zone_name = "my-public-zone"
public_dns_domain    = "example.com."

public_dns_records = {
  "www" = {
    name    = "www"
    type    = "A"
    ttl     = 300
    rrdatas = ["34.123.45.67"] # external LB IP
  }
}

# Private DNS zone
private_dns_zone_name = "my-private-zone"
private_dns_domain    = "internal.local."

private_dns_records = {
  "vm-a" = {
    name    = "vm-a"
    type    = "A"
    ttl     = 300
    rrdatas = ["10.0.1.5"] # internal IP of vm_a
  }
  "vm-b" = {
    name    = "vm-b"
    type    = "A"
    ttl     = 300
    rrdatas = ["10.0.2.5"] # internal IP of vm_b
  }
}
disk_name     = "extra-disk"
disk_size     = 50
snapshot_name = "boot-snapshot"
new_vm_name   = "cloned-vm"
machine_type  = "e2-medium"
zone          = "us-central1-a"
network       = "default"
subnet        = "default"
#gke cluser 
gke_cluster_name = "dev-gke-cluster"
gke_region       = "us-central1"

primary_machine_type = "e2-medium"
primary_min_nodes    = 1
primary_max_nodes    = 3

secondary_machine_type = "e2-standard-2"
secondary_min_nodes    = 1
secondary_max_nodes    = 2

app_name = "hello-app"
app_label = "hello"
app_image = "nginx"
app_replicas = 2
container_port = 80
service_port   = 80
pv_size = "10Gi"
gce_disk_name = "gke-app-disk"