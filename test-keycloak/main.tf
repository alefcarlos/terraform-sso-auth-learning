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

module "pix_api" {
  source   = "../modules/resource-server"
  name     = "pix-api"
  roles    = ["reader", "admin"]
  realm_id = keycloak_realm.acme.id
}

module "pix_worker" {
  source = "../modules/service-account"
  name   = "pix-worker"
  permissions = {
    "pix-api" = ["reader"]
  }
  realm_id = keycloak_realm.acme.id
}

