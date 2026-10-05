terraform {
  required_version = ">= 1.0"

  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

# Docker provider (talks to the local Docker daemon).
# On Windows with Docker Desktop, uncomment the host line below.
provider "docker" {
  # host = "npipe:////./pipe/docker_engine"
}

variable "external_port" {
  description = "Host port mapped to the container's port 80"
  type        = number
  default     = 8080
}

# Pull the image
resource "docker_image" "nginx" {
  name         = "nginx:latest"
  keep_locally = false
}

# Create the container (implicit dependency on docker_image.nginx)
resource "docker_container" "nginx" {
  name  = "terraform-nginx"
  image = docker_image.nginx.image_id

  ports {
    internal = 80
    external = var.external_port
  }
}

output "container_name" {
  value = docker_container.nginx.name
}

output "url" {
  value = "http://localhost:${var.external_port}"
}
