resource "github_team" "teams" {
  for_each = { for team in var.teams : team.name => team }

  name        = each.value.name
  description = each.value.description
  privacy     = each.value.privacy
}