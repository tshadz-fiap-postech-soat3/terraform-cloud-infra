terraform {
  cloud {
    organization = "fiap-postech-tsombra"
    workspaces {
      name = "fiap-cloud-infra-tf"
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
  name     = "fiap-pos-tech"
  location = var.CLOUD_REGION
  template {

    containers {
      image = "southamerica-east1-docker.pkg.dev/lateral-scion-414400/fiap/fiap-pos-tech:fdb80d323f4bef1859818f8e13dae40a140835c0"
      volume_mounts {
        name       = "cloudsql"
        mount_path = "/cloudsql"
      }
      env {
        name  = "DATABASE_URL"
        value = "mysql://${var.MYSQL_USER}:${var.MYSQL_PASSWORD}@localhost/${var.MYSQL_DATABASE}?socket=/cloudsql/${var.CLOUD_INSTANCE}"
      }
    }
    volumes {
      name = "cloudsql"
      cloud_sql_instance {
        instances = [var.CLOUD_INSTANCE]
      }
    }
  }
  client     = "terraform"
  depends_on = [google_project_service.secretmanager_api, google_project_service.cloudrun_api, google_project_service.sqladmin_api]
}
