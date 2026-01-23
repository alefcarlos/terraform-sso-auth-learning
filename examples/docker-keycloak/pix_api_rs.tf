module "pix_api" {
  source   = "../../modules/confidential_client"
  name     = "pix-api"
  roles    = ["reader", "admin"]
  realm_id = keycloak_realm.acme.id
}
