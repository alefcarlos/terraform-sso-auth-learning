output "client_id" {
  description = "The generated client ID."
  value       = keycloak_openid_client.client.client_id
}

output "role_ids" {
  description = "Map of role names to their IDs (if roles defined)."
  value       = local.has_roles ? { for k, v in keycloak_role.roles : k => v.id } : {}
}

output "scope_ids" {
  description = "Map of scope names to their IDs (if roles defined)."
  value       = local.has_roles ? { for k, v in keycloak_openid_client_scope.scopes : k => v.id } : {}
}

output "client_secret" {
  description = "The client secret (if service account enabled, sensitive)."
  value       = local.has_permissions ? keycloak_openid_client.client.client_secret : null
  sensitive   = true
}