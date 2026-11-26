# Reseaux prive: : les serveurs web et le devcontainer s'y rejoignent.
resource "docker_network" "back" {
    name= "back"
  
}

# Réseau privé : seuls les serveurs web et la base s'y trouvent
resource "docker_network" "front" {
  name = "front"
}