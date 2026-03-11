terraform {
  backend "gcs" {
    # These values can be overridden by -backend-config flags in Cloud Build
    bucket = "tfstate-terraform-488518"
    prefix = "network/dev"
  }
}