locals {
  data_lake_bucket = "dtc_data_lake"
}

variable "project" {
  description = "Data Engineering Zoomcamp"
}

variable "region" {
  description = "Region for GCP resources. Choose as per your location: https://cloud.google.com/about/locations"
  default = "europe-west6"
  type = string
}

variable "credentials" {
  description = "Google JSON credentials file"
  default = "de-zoomcamp-375617-d3361d38006c.json" # plug your filename here
}

variable "storage_class" {
  description = "Storage class type for your bucket. Check official docs for more info."
  default = "STANDARD"
}

variable "BQ_DATASET" {
  description = "BigQuery Dataset that raw data (from GCS) will be written to"
  type = string
  default = "trips_data_all"
}
