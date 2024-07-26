resource "github_team" "teams" {
  for_each = { for team in var.teams : team.name => team }

  name        = each.value.name
  description = each.value.description
  privacy     = each.value.privacy
}

# resource "github_team_membership" "team_memberships" {
#   for_each = {
#     for team in var.teams : team.name => team if length(team.members) > 0
#   }

#   # count    = length(each.value.members)
#   team_id  = github_team.teams[each.key].id
#   username = each.value.members[count.index]
#   role     = "member"
# }