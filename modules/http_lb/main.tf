resource "google_compute_health_check" "http" {
  name = "${var.name}-hc"

  http_health_check {
    port = 80
  }
}

resource "google_compute_backend_service" "backend" {
  name          = "${var.name}-backend"
  protocol      = "HTTP"
  timeout_sec   = 10
  health_checks = [google_compute_health_check.http.id]

  backend {
    group = var.instance_group
  }
}

resource "google_compute_url_map" "url_map" {
  name            = "${var.name}-urlmap"
  default_service = google_compute_backend_service.backend.id
}

resource "google_compute_target_http_proxy" "proxy" {
  name    = "${var.name}-proxy"
  url_map = google_compute_url_map.url_map.id
}

resource "google_compute_global_forwarding_rule" "http_rule" {
  name       = "${var.name}-fw"
  target     = google_compute_target_http_proxy.proxy.id
  port_range = "80"
}