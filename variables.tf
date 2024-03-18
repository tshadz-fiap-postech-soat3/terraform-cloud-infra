variable "DB_REGION" {
  description = "Database region"
}

variable "DB_TIER" {
  description = "Database tier"
}

variable "GCP_ID" {
  description = "Project ID"
}

variable "MYSQL_HOST" {
  description = "DB Host"
}

variable "MYSQL_ROOT_PASSWORD" {
  description = "DB Password"
}

variable "MYSQL_DATABASE" {
  default = "fastfood"
}

variable "MYSQL_USER" {
  description = "DB Instance Name"
}

variable "MYSQL_PASSWORD" {
  description = "DB Password"
}

variable "MYSQL_PORT" {
  description = "DB Port"
}

variable "CLOUD_INSTANCE" {
  description = "DB Instance Name"
}

variable "CREDENTIALS" {
  description = "Cloud Sql Service Credentials"
}

variable "REGION" {
  description = "The region for the resources"
  default     = "us-central1"
}

variable "ZONE" {
  description = "The zone for the resources"
  default     = "us-central1-a"
}