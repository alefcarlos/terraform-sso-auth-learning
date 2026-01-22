module "cartao_api" {
  source   = "../../modules/resource-server"
  name     = "cartao-api"
  realm_id = keycloak_realm.acme.id
}
