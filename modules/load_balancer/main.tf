resource "google_compute_forwarding_rule" "lb" {
  name                  = var.lb_name
  load_balancing_scheme = var.lb_scheme   # "EXTERNAL" or "INTERNAL"
  port_range            = var.lb_port_range
  target                = google_compute_target_pool.lb.self_link
  network               = var.network
  subnetwork            = var.subnetwork
}

resource "google_compute_target_pool" "lb" {
  name      = "${var.lb_name}-pool"
  instances = var.backend_instances
}

resource "google_compute_health_check" "lb" {
  name               = "${var.lb_name}-hc"
  check_interval_sec = 5
  timeout_sec        = 5
  healthy_threshold  = 2
  unhealthy_threshold = 2

  tcp_health_check {
    port = var.health_check_port
  }
}