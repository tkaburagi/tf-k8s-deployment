terraform {
	required_version = "~> 0.12"
}

provider "kubernetes" {
	config_context = var.k8s_context
}

resource "kubernetes_namespace" "tf-demo" {
	metadata {
		name = "tf-demo"
	}
}