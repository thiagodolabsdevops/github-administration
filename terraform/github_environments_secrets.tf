# resource "github_repository_environment" "environments" {
#   for_each = var.environments

#   repository  = each.value.repositories
#   environment = each.key
# }

# resource "github_actions_secret" "secrets" {
#   for_each = var.environments

#   repository      = each.value.repositories
#   secret_name     = each.key
#   plaintext_value = each.value.secrets[each.key]
# }