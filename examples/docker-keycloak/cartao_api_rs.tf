module "cartao_api" {
  source   = "../../modules/confidential_client"
  name     = "cartao-api"
  roles    = ["viewer"]
  realm_id = keycloak_realm.acme.id
}
