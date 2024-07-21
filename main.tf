terraform {
  cloud {
    organization = "fiap-postech-tsombra"
    workspaces {
      name = "workspace"
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

locals {
  cloud_sql_instance = "${var.GCP_ID}:${var.CLOUD_REGION}:${var.IMAGE_NAME}-database"
}

# Enable Secret Manager API
resource "google_project_service" "secretmanager_api" {
  service            = "secretmanager.googleapis.com"
  disable_on_destroy = false
}

# Enable SQL Admin API
resource "google_project_service" "sqladmin_api" {
  service            = "sqladmin.googleapis.com"
  disable_on_destroy = false
}

# Enable Cloud Run API
resource "google_project_service" "cloudrun_api" {
  service            = "run.googleapis.com"
  disable_on_destroy = false
}

provider "google" {
  project     = var.GCP_ID
  region      = var.CLOUD_REGION
  zone        = var.ZONE
  credentials = var.CREDENTIALS
}

resource "google_cloud_run_v2_service" "fiap-postech" {
  name     = var.IMAGE_NAME
  location = var.CLOUD_REGION
  template {

    containers {
      image = "${var.CLOUD_REGION}-docker.pkg.dev/${var.GCP_ID}/fiap/${var.IMAGE_NAME}:${var.TAG}"
      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }
      env {
        name  = "DATABASE_URL"
        value = "mysql://${var.MYSQL_USER}:${var.MYSQL_PASSWORD}@localhost/${var.MYSQL_DATABASE}?socket=/cloudsql/${var.GCP_ID}:${var.CLOUD_REGION}:${var.IMAGE_NAME}-database"
      }
    }
    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [local.cloud_sql_instance]
      }
    }
  }
  client     = "terraform"
  depends_on = [google_project_service.secretmanager_api, google_project_service.cloudrun_api, google_project_service.sqladmin_api]
}
