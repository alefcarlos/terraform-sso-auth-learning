# Example Usage of Resource Server Module

resource "keycloak_realm" "acme" {
  realm   = "acme"
  enabled = true
}

module "pix_api" {
  source   = "../../modules/resource-server"
  name     = "pix-api"
  roles    = ["reader", "admin"]
  realm_id = keycloak_realm.acme.id
}