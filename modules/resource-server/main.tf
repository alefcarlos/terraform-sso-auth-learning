locals {
  roles = length(var.roles) > 0 ? var.roles : ["viewer"]
}

resource "keycloak_openid_client" "rs" {
  realm_id    = var.realm_id
  client_id   = "acme-${var.name}"
  access_type = "BEARER-ONLY"
  enabled     = true
}

resource "keycloak_role" "roles" {
  for_each    = toset(local.roles)
  realm_id    = var.realm_id
  client_id   = keycloak_openid_client.rs.id
  name        = "acme-${var.name}:${each.value}"
  description = "Role for ${each.value} access to ${var.name}"
}

resource "keycloak_openid_client_scope" "scopes" {
  for_each = keycloak_role.roles
  realm_id = var.realm_id
  name     = each.value.name
}

resource "keycloak_generic_role_mapper" "mappers" {
  for_each        = keycloak_role.roles
  realm_id        = var.realm_id
  client_scope_id = keycloak_openid_client_scope.scopes[each.key].id
  role_id         = each.value.id
}