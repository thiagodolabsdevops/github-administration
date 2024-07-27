resource "github_repository" "repos" {
  for_each = { for repo in var.repositories : repo.name => repo }

  name        = each.value.name
  description = each.value.description
  visibility  = each.value.visibility

  has_downloads = each.value.has_downloads
  has_issues    = each.value.has_issues
  has_projects  = each.value.has_projects
  has_wiki      = each.value.has_wiki

  is_template  = each.value.is_template
  homepage_url = each.value.homepage_url
  archived     = each.value.archived

  allow_rebase_merge = each.value.allow_rebase_merge
  allow_squash_merge = each.value.allow_squash_merge
  allow_merge_commit = each.value.allow_merge_commit

  # dynamic "pages" {
  #   for_each = each.value.pages != null ? [each.value.pages] : []
  #   content {
  #     source {
  #       branch = pages.value.branch
  #       path   = pages.value.path
  #     }
  #   }
  # }

  # auto_init        = each.value.auto_init
  # license_template = each.value.license_template
}

# TODO: Implement feature to create repositories based on existent repository templates
# TODO: Implement feature to create repositories that servers GitHub Pages
# TODO: Implement feature to create auto-initialized repositories with a README