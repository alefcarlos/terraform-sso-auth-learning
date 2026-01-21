output "client_id" {
  description = "The generated resource server client ID."
  value       = keycloak_openid_client.rs.client_id
}

output "role_ids" {
  description = "Map of role names to their IDs."
  value       = { for k, v in keycloak_role.roles : k => v.id }
}

output "scope_ids" {
  description = "Map of scope names to their IDs."
  value       = { for k, v in keycloak_openid_client_scope.scopes : k => v.id }
}