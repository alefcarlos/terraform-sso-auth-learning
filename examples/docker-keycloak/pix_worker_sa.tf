module "pix_worker" {
  source = "../../modules/confidential_client"
  name   = "pix-worker"
  permissions = {
    "pix-api"    = ["reader"]
    "cartao-api" = ["viewer"]
  }
  string_hardcoded_claims = {
    "app-role" = {
      value = "worker"
    }
    "env" = {
      value           = "prod"
      add_to_id_token = false
    }
  }
  int_hardcoded_claims = {
    "max-retries" = { value = 5 }
  }
  long_hardcoded_claims = {
    "timeout-ms" = { value = 300000 }
  }
  boolean_hardcoded_claims = {
    "debug-mode" = { value = false }
  }
  realm_id = keycloak_realm.acme.id
}
