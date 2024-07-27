locals {
  flattened_secrets = flatten([
    for repo in var.repositories : [
      for secret_key, secret_value in repo.secrets : {
        repository      = repo.name
        secret_name     = secret_key
        plaintext_value = secret_value
      }
    ]
  ])
}

resource "github_actions_secret" "secrets" {
  for_each = { for s in local.flattened_secrets : "${s.repository}-${s.secret_name}" => s }

  repository      = each.value.repository
  secret_name     = each.value.secret_name
  plaintext_value = each.value.plaintext_value
}