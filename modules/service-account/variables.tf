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

variable "string_hardcoded_claims" {
  type = map(object({
    value               = string
    add_to_id_token     = optional(bool, true)
    add_to_access_token = optional(bool, true)
    add_to_userinfo     = optional(bool, true)
  }))
  description = "Map of claim names to objects defining hardcoded string claims (e.g., {'app-role' = { value = 'worker', add_to_id_token = false }})."
  default     = {}
  validation {
    condition = alltrue([
      for name, config in var.string_hardcoded_claims :
      can(regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", name))
    ])
    error_message = "Claim names must be kebab-case."
  }
}

variable "int_hardcoded_claims" {
  type = map(object({
    value               = number
    add_to_id_token     = optional(bool, true)
    add_to_access_token = optional(bool, true)
    add_to_userinfo     = optional(bool, true)
  }))
  description = "Map of claim names to objects defining hardcoded int claims."
  default     = {}
  validation {
    condition = alltrue([
      for name, config in var.int_hardcoded_claims :
      can(regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", name))
    ])
    error_message = "Claim names must be kebab-case."
  }
}

variable "long_hardcoded_claims" {
  type = map(object({
    value               = number
    add_to_id_token     = optional(bool, true)
    add_to_access_token = optional(bool, true)
    add_to_userinfo     = optional(bool, true)
  }))
  description = "Map of claim names to objects defining hardcoded long claims."
  default     = {}
  validation {
    condition = alltrue([
      for name, config in var.long_hardcoded_claims :
      can(regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", name))
    ])
    error_message = "Claim names must be kebab-case."
  }
}

variable "boolean_hardcoded_claims" {
  type = map(object({
    value               = bool
    add_to_id_token     = optional(bool, true)
    add_to_access_token = optional(bool, true)
    add_to_userinfo     = optional(bool, true)
  }))
  description = "Map of claim names to objects defining hardcoded boolean claims."
  default     = {}
  validation {
    condition = alltrue([
      for name, config in var.boolean_hardcoded_claims :
      can(regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", name))
    ])
    error_message = "Claim names must be kebab-case."
  }
}