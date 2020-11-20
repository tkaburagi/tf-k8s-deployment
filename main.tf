terraform {
	required_version = "~> 0.12"
}

provider "kubernetes" {
	host = "https://34.69.199.143"
	cluster_ca_certificate = var.ca_cert
	load_config_file = "false"
}


resource "kubernetes_namespace" "tf-demo" {
	metadata {
		name = "tf-demo"
	}
}