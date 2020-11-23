terraform {
	required_version = "~> 0.12"
}

provider "google" {
	credentials = var.gcp_key
	project     = "se-kabu"
	region      = "us-central1"
}

resource "google_container_cluster" "primary" {
	name     = "k8s-sentinel-demo-custer"
	location = "us-central1"

	remove_default_node_pool = true
	initial_node_count       = 1

	master_auth {
		username = "user"
		password = "welcome1welcome1welcome1welcome1"

		client_certificate_config {
			issue_client_certificate = true
		}
	}
}

resource "google_container_node_pool" "primary_preemptible_nodes" {
	name       = "my-node-pool"
	location   = "us-central1"
	cluster    = google_container_cluster.primary.name
	node_count = 1

	node_config {
		preemptible  = true
		machine_type = "e2-medium"

		metadata = {
			disable-legacy-endpoints = "true"
		}

		oauth_scopes = [
			"https://www.googleapis.com/auth/cloud-platform"
		]
	}
}