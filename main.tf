terraform {
  cloud {
    organization = "fiap-postech-tsombra"
    workspaces {
      name = "terraform-cloud-test-infra"
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
  region      = "us-central1"
  zone        = "us-central1-a"
  credentials = "./credentials.json"
}

resource "google_cloud_run_v2_service" "cloud-run-with-tf" {
  name     = "cloud-run-with-tf"
  location = "us-central1"

  template {

    containers {
      image = "southamerica-east1-docker.pkg.dev/lateral-scion-414400/fiap/fiap-pos-tech:485806c573792201cf0f4990729ba1980e9338ae"

      env {
        name  = "DATABASE_URL"
        value = "mysql://${var.MYSQL_USER}:${var.MYSQL_PASSWORD}@localhost/${var.MYSQL_DATABASE}?socket=cloudsql/${var.CLOUD_INSTANCE}"
      }
      env {
        name  = "DB_HOST"
        value = var.MYSQL_HOST
      }
      env {
        name  = "DB_ROOT_PASSWORD"
        value = var.MYSQL_ROOT_PASSWORD
      }
      env {
        name  = "DB_ROOT_USER"
        value = var.MYSQL_ROOT_USER
      }
      env {
        name  = "DB_DATABASE"
        value = var.MYSQL_DATABASE
      }
      env {
        name  = "DB_USER"
        value = var.MYSQL_USER
      }
      env {
        name  = "DB_PASSWORD"
        value = var.MYSQL_PASSWORD
      }
      env {
        name  = "DB_PORT"
        value = var.MYSQL_PORT
      }
    }
  }
}

# provider "kubernetes" {
#   config_context_cluster = "tshadz-cluster-1"
# }


# resource "kubernetes_namespace" "fiap-postech" {
#     metadata {
#         name = var.APP_NAMESPACE
#     }
# }

# resource "helm_release" "fiap-postech" {
#     name = kubernetes_namespace.fiap-postech.metadata[0].name
#     namespace = kubernetes_namespace.fiap-postech.metadata[0].name
#     chart = "${path.module}/chart"

#     set {
#         name = "env"
#         value = var.env
#     }

#     set {
#         name = "gcp_project"
#         value = var.project_id
#     }

#     set { 
#         name = "database.connection_name"
#         value = "${var.project_id}:${var.APP_REGION}:${var.database_instance_name}"
#     }

#     set {
#         name = "database.private_address"
#         value = module.
#     }
# }