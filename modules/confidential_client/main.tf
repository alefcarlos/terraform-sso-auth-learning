locals {
  roles = length(var.roles) > 0 ? var.roles : []
  role_assignments = flatten([
    for rs, roles in var.permissions : [
      for role in roles : {
        rs   = rs
        role = role
      }
    ]
  ])
  sa_optional_scopes = distinct([
    for item in local.role_assignments :
    "acme-${item.rs}:${item.role}"
  ])
  has_permissions = length(var.permissions) > 0
  has_roles       = length(var.roles) > 0
}

resource "keycloak_openid_client" "client" {
  realm_id                 = var.realm_id
  client_id                = "acme-${var.name}"
  access_type              = local.has_permissions ? "CONFIDENTIAL" : "BEARER-ONLY"
  service_accounts_enabled = local.has_permissions
  enabled                  = true
  full_scope_allowed       = false
}

resource "keycloak_role" "roles" {
  for_each    = toset(local.roles)
  realm_id    = var.realm_id
  client_id   = keycloak_openid_client.client.id
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

data "keycloak_openid_client_service_account_user" "sa_user" {
  count     = local.has_permissions ? 1 : 0
  realm_id  = var.realm_id
  client_id = keycloak_openid_client.client.id
}

data "keycloak_openid_client" "resource_servers" {
  for_each  = toset(keys(var.permissions))
  realm_id  = var.realm_id
  client_id = "acme-${each.key}"
}

resource "keycloak_openid_client_service_account_role" "assignments" {
  for_each = {
    for idx, item in local.role_assignments :
    "${item.rs}-${item.role}" => item
  }

  realm_id                = var.realm_id
  service_account_user_id = data.keycloak_openid_client_service_account_user.sa_user[0].id
  client_id               = data.keycloak_openid_client.resource_servers[each.value.rs].id
  role                    = "acme-${each.value.rs}:${each.value.role}"
}

resource "keycloak_openid_client_optional_scopes" "sa_scopes" {
  count           = local.has_permissions ? 1 : 0
  realm_id        = var.realm_id
  client_id       = keycloak_openid_client.client.id
  optional_scopes = local.sa_optional_scopes
}

resource "keycloak_openid_hardcoded_claim_protocol_mapper" "string_hardcoded_claims" {
  for_each = local.has_permissions ? var.string_hardcoded_claims : {}

  realm_id            = var.realm_id
  client_id           = keycloak_openid_client.client.id
  name                = "hardcoded-${each.key}"
  claim_name          = each.key
  claim_value         = each.value.value
  claim_value_type    = "String"
  add_to_id_token     = each.value.add_to_id_token
  add_to_access_token = each.value.add_to_access_token
  add_to_userinfo     = each.value.add_to_userinfo
}

resource "keycloak_openid_hardcoded_claim_protocol_mapper" "int_hardcoded_claims" {
  for_each = local.has_permissions ? var.int_hardcoded_claims : {}

  realm_id            = var.realm_id
  client_id           = keycloak_openid_client.client.id
  name                = "hardcoded-${each.key}"
  claim_name          = each.key
  claim_value         = each.value.value
  claim_value_type    = "int"
  add_to_id_token     = each.value.add_to_id_token
  add_to_access_token = each.value.add_to_access_token
  add_to_userinfo     = each.value.add_to_userinfo
}

resource "keycloak_openid_hardcoded_claim_protocol_mapper" "long_hardcoded_claims" {
  for_each = local.has_permissions ? var.long_hardcoded_claims : {}

  realm_id            = var.realm_id
  client_id           = keycloak_openid_client.client.id
  name                = "hardcoded-${each.key}"
  claim_name          = each.key
  claim_value         = each.value.value
  claim_value_type    = "long"
  add_to_id_token     = each.value.add_to_id_token
  add_to_access_token = each.value.add_to_access_token
  add_to_userinfo     = each.value.add_to_userinfo
}

resource "keycloak_openid_hardcoded_claim_protocol_mapper" "boolean_hardcoded_claims" {
  for_each = local.has_permissions ? var.boolean_hardcoded_claims : {}

  realm_id            = var.realm_id
  client_id           = keycloak_openid_client.client.id
  name                = "hardcoded-${each.key}"
  claim_name          = each.key
  claim_value         = each.value.value
  claim_value_type    = "boolean"
  add_to_id_token     = each.value.add_to_id_token
  add_to_access_token = each.value.add_to_access_token
  add_to_userinfo     = each.value.add_to_userinfo
}