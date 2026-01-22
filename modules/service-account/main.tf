locals {
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
}

resource "keycloak_openid_client" "sa" {
  realm_id                 = var.realm_id
  client_id                = "sa-acme-${var.name}"
  access_type              = "CONFIDENTIAL"
  service_accounts_enabled = true
  enabled                  = true
  full_scope_allowed       = false

  # Disable flows not needed for service accounts
  standard_flow_enabled        = false
  implicit_flow_enabled        = false
  direct_access_grants_enabled = false
}

data "keycloak_openid_client_service_account_user" "sa_user" {
  realm_id  = var.realm_id
  client_id = keycloak_openid_client.sa.id
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
  service_account_user_id = data.keycloak_openid_client_service_account_user.sa_user.id
  client_id               = data.keycloak_openid_client.resource_servers[each.value.rs].id
  role                    = "acme-${each.value.rs}:${each.value.role}"
}

resource "keycloak_openid_client_optional_scopes" "sa_scopes" {
  realm_id        = var.realm_id
  client_id       = keycloak_openid_client.sa.id
  optional_scopes = local.sa_optional_scopes
}

resource "keycloak_openid_hardcoded_claim_protocol_mapper" "string_hardcoded_claims" {
  for_each = var.string_hardcoded_claims

  realm_id            = var.realm_id
  client_id           = keycloak_openid_client.sa.id
  name                = "hardcoded-${each.key}"
  claim_name          = each.key
  claim_value         = each.value.value
  claim_value_type    = each.value.claim_value_type
  add_to_id_token     = each.value.add_to_id_token
  add_to_access_token = each.value.add_to_access_token
  add_to_userinfo     = each.value.add_to_userinfo
}

resource "keycloak_openid_hardcoded_claim_protocol_mapper" "int_hardcoded_claims" {
  for_each = var.int_hardcoded_claims

  realm_id            = var.realm_id
  client_id           = keycloak_openid_client.sa.id
  name                = "hardcoded-${each.key}"
  claim_name          = each.key
  claim_value         = each.value.value
  claim_value_type    = each.value.claim_value_type
  add_to_id_token     = each.value.add_to_id_token
  add_to_access_token = each.value.add_to_access_token
  add_to_userinfo     = each.value.add_to_userinfo
}

resource "keycloak_openid_hardcoded_claim_protocol_mapper" "long_hardcoded_claims" {
  for_each = var.long_hardcoded_claims

  realm_id            = var.realm_id
  client_id           = keycloak_openid_client.sa.id
  name                = "hardcoded-${each.key}"
  claim_name          = each.key
  claim_value         = each.value.value
  claim_value_type    = each.value.claim_value_type
  add_to_id_token     = each.value.add_to_id_token
  add_to_access_token = each.value.add_to_access_token
  add_to_userinfo     = each.value.add_to_userinfo
}

resource "keycloak_openid_hardcoded_claim_protocol_mapper" "boolean_hardcoded_claims" {
  for_each = var.boolean_hardcoded_claims

  realm_id            = var.realm_id
  client_id           = keycloak_openid_client.sa.id
  name                = "hardcoded-${each.key}"
  claim_name          = each.key
  claim_value         = each.value.value
  claim_value_type    = each.value.claim_value_type
  add_to_id_token     = each.value.add_to_id_token
  add_to_access_token = each.value.add_to_access_token
  add_to_userinfo     = each.value.add_to_userinfo
}
