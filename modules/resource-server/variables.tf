variable "name" {
  type        = string
  description = "Name of the resource server (kebab-case, e.g., 'pix-api')."
  validation {
    condition     = can(regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", var.name))
    error_message = "Name must be kebab-case (lowercase letters, numbers, and hyphens only; start with letter, no prefixes like 'acme-')."
  }
}

variable "roles" {
  type        = list(string)
  description = "Optional list of roles (kebab-case). If empty, defaults to ['viewer']."
  default     = []
  validation {
    condition = alltrue([
      for role in var.roles : can(regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", role))
    ])
    error_message = "Each role must be kebab-case (lowercase letters, numbers, and hyphens only; start with letter)."
  }
}

variable "realm_id" {
  type        = string
  description = "ID of the Keycloak realm where resources will be created."
}