variable "name" {
  type        = string
  description = "Name of the service account (kebab-case, e.g., 'pix-worker')."
  validation {
    condition     = can(regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", var.name))
    error_message = "Name must be kebab-case (lowercase letters, numbers, and hyphens only; start with letter, no prefixes like 'sa-acme-')."
  }
}

variable "permissions" {
  type        = map(list(string))
  description = "Map of resource server names to list of roles (e.g., {'pix-api' = ['reader']})."
  validation {
    condition = alltrue(flatten([
      for rs, roles in var.permissions : concat(
        [can(regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", rs))],
        [for role in roles : can(regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", role))]
      )
    ]))
    error_message = "Resource server names and role names must be kebab-case."
  }
}

variable "realm_id" {
  type        = string
  description = "ID of the Keycloak realm."
}