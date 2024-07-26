output "repository_names" {
  value = [for repo in github_repository.repos : repo.name]
}

output "team_names" {
  value = [for team in github_team.teams : team.name]
}