locals {
  tf_cloud_organization = var.TF_CLOUD_ORGANIZATION
  tf_workspace          = var.TF_WORKSPACE
}

terraform {
  cloud {
    organization = local.tf_cloud_organization
    workspaces {
      name = local.tf_workspace
    }
  }
}

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.51.0"
    }
  }
}

provider "google" {
  project     = var.GCP_ID
  region      = var.REGION
  zone        = var.ZONE
  credentials = var.CREDENTIALS
}

data "terraform_remote_state" "fiap-database" {
  backend = "remote"

  config = {
    organization = local.tf_cloud_organization
    workspaces = {
      name = local.tf_workspace
    }
  }
}

resource "google_cloud_run_v2_service" "fiap-postech" {
  name     = "fiap-pos-tech"
  location = var.REGION

  template {

    containers {
      image = "southamerica-east1-docker.pkg.dev/lateral-scion-414400/fiap/fiap-pos-tech:71f403d93026dbbdc5993a5a8b0d2a6b51cf4435"

      env {
        name  = "DATABASE_URL"
        value = "mysql://${var.MYSQL_USER}:${var.MYSQL_PASSWORD}@localhost/${var.MYSQL_DATABASE}?socket=/cloudsql/${var.CLOUD_INSTANCE}"
      }
    }
  }
}
