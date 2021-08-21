terraform {
  backend "s3" {
    bucket = var.backend_bucket
    key    = "upe_example.tfstate"
    region = var.region_id
  }
}