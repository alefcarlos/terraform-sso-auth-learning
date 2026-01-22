terraform {
  required_providers {
    keycloak = {
      source  = "keycloak/keycloak"
      version = "5.6.0"
    }
  }
}

provider "keycloak" {
  url       = "http://localhost:8080"
  client_id = "admin-cli"
  username  = "admin"
  password  = "admin"
}

resource "keycloak_realm" "acme" {
  realm   = "acme"
  enabled = true
}
