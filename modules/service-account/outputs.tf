output "client_id" {
  description = "The generated service account client ID (e.g., 'sa-acme-pix-worker')."
  value       = keycloak_openid_client.sa.client_id
}

output "client_secret" {
  description = "The client secret for the service account (sensitive)."
  value       = keycloak_openid_client.sa.client_secret
  sensitive   = true
}