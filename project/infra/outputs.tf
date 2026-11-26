# Squelette fourni (lab terraform) : les sorties attendues. Décommentez-les quand vos ressources existent
# (les noms docker_container.web et docker_container.db sont ceux qu'attend la suite du cours).

output "web_servers" {
  description = "Noms des serveurs web, pour l'inventaire Ansible du lab suivant"
  value       = docker_container.web[*].name
}

output "db_host" {
  description = "Nom de la base sur le réseau back"
  value       = docker_container.db.name
}
