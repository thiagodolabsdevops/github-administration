variable "repositories" {
  type = list(object({
    name        = string
    description = optional(string, "")

    visibility    = optional(string, "public")
    has_downloads = optional(bool, true)
    has_issues    = optional(bool, true)
    has_projects  = optional(bool, true)
    has_wiki      = optional(bool, true)

    is_template  = optional(bool, false)
    homepage_url = optional(string, "")
    archived     = optional(bool, false)

    allow_rebase_merge = optional(bool, true)
    allow_squash_merge = optional(bool, true)
    allow_merge_commit = optional(bool, true)

    # pages = optional(object({
    #   branch = string
    #   path   = string
    # }), null)

    secrets = optional(map(string))

    # auto_init        = optional(bool, true)        # Initialize repositories with a README
    # license_template = optional(string, "gpl-3.0") # License template to apply to all repositories
  }))
  description = "List of GitHub repositories to create"
}

variable "teams" {
  type = list(object({
    name        = string
    description = string
    privacy     = string
    members     = optional(list(string), [])
  }))
  description = "List of GitHub teams to create"
}

variable "secrets" {
  type        = map(string)
  description = "Map of secrets to be applied to all repositories"
  default = {
    AWS_ACCESS_KEY_ID     = "blablabla"
    AWS_REGION            = "us-east-1"
    AWS_SECRET_ACCESS_KEY = "blablabla"
  }
}