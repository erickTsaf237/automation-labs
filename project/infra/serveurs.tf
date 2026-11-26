#deux serveur web identiques, decrit une deule fois

resource "docker_container" "web" {
  count = var.web_count
  name  = "srv-web-${count.index + 1}"
  image = docker_image.server.image_id

  networks_advanced {
    name = docker_network.front.name
  }

  networks_advanced {
    name = docker_network.back.name
  }
}

#La base: sur back seulement, sans por publié
resource "docker_container" "db" {
  name  = "db"
  image = docker_image.postgres.image_id

  env = [
    "POSTGRES_DB=reservations",
    "POSTGRES_USER=reservations",
    "POSTGRES_PASSWORD=${var.db_password}"
  ]

  networks_advanced {
    name = docker_network.back.name
  }
}
