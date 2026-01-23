variable "name" {
  type        = string
  description = "Name of the component (kebab-case, ending with '-api', '-worker', '-ios', or '-android', e.g., 'pix-api')."
  validation {
    condition     = can(regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*-(api|worker|ios|android)$", var.name))
    error_message = "Name must be kebab-case ending with '-api', '-worker', '-ios', or '-android' (e.g., 'pix-api')."
  }
}

variable "roles" {
  type        = list(string)
  description = "Optional list of roles (kebab-case). If empty, no roles are defined."
  default     = []
  validation {
    condition = alltrue([
      for role in var.roles : can(regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", role))
    ])
    error_message = "Each role must be kebab-case (lowercase letters, numbers, and hyphens only; start with letter)."
  }
}

variable "permissions" {
  type        = map(list(string))
  description = "Optional map of resource server names to list of roles (e.g., {'pix-api' = ['reader']}). If provided, enables service account."
  default     = {}
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
  description = "ID of the Keycloak realm where resources will be created."
}

variable "string_hardcoded_claims" {
  type = map(object({
    value               = string
    add_to_id_token     = optional(bool, true)
    add_to_access_token = optional(bool, true)
    add_to_userinfo     = optional(bool, true)
  }))
  description = "Map of claim names to objects defining hardcoded string claims (e.g., {'app-role' = { value = 'worker', add_to_id_token = false }}). Only used if permissions is provided."
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
  description = "Map of claim names to objects defining hardcoded int claims. Only used if permissions is provided."
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
  description = "Map of claim names to objects defining hardcoded long claims. Only used if permissions is provided."
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
  description = "Map of claim names to objects defining hardcoded boolean claims. Only used if permissions is provided."
  default     = {}
  validation {
    condition = alltrue([
      for name, config in var.boolean_hardcoded_claims :
      can(regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", name))
    ])
    error_message = "Claim names must be kebab-case."
  }
}