mock_provider "keycloak" {}

############################
# ✅ SUCCESS CASES
############################

run "valid_minimal" {
  command = plan

  variables {
    name      = "pix-worker"
    realm_id = "test-realm"
    permissions = {
      "pix-api" = ["reader"]
    }
  }
}

run "valid_multiple_permissions" {
  command = plan

  variables {
    name      = "batch-worker"
    realm_id = "realm-123"
    permissions = {
      "pix-api"     = ["reader", "writer"]
      "cartao-api" = ["viewer"]
    }
  }
}

run "valid_all_claim_types" {
  command = plan

  variables {
    name      = "claims-worker"
    realm_id = "realm-claims"
    permissions = {
      "core-api" = ["reader"]
    }

    string_hardcoded_claims = {
      "app-role" = {
        value = "worker"
      }
    }

    int_hardcoded_claims = {
      "max-retries" = {
        value = 5
      }
    }

    long_hardcoded_claims = {
      "timeout-ms" = {
        value = 300000
      }
    }

    boolean_hardcoded_claims = {
      "debug-mode" = {
        value = false
      }
    }
  }
}

############################
# ❌ FAILURE CASES
############################

run "invalid_name_uppercase" {
  command = plan

  variables {
    name      = "Pix-Worker"
    realm_id = "test"
    permissions = {
      "pix-api" = ["reader"]
    }
  }

  expect_failures = [
    var.name
  ]
}

run "invalid_name_underscore" {
  command = plan

  variables {
    name      = "pix_worker"
    realm_id = "test"
    permissions = {
      "pix-api" = ["reader"]
    }
  }

  expect_failures = [
    var.name
  ]
}

run "invalid_permissions_rs_name" {
  command = plan

  variables {
    name      = "pix-worker"
    realm_id = "test"
    permissions = {
      "PixApi" = ["reader"]
    }
  }

  expect_failures = [
    var.permissions
  ]
}

run "invalid_permissions_role_name" {
  command = plan

  variables {
    name      = "pix-worker"
    realm_id = "test"
    permissions = {
      "pix-api" = ["Read_Only"]
    }
  }

  expect_failures = [
    var.permissions
  ]
}

run "invalid_string_claim_name" {
  command = plan

  variables {
    name      = "pix-worker"
    realm_id = "test"
    permissions = {
      "pix-api" = ["reader"]
    }

    string_hardcoded_claims = {
      "app_role" = {
        value = "worker"
      }
    }
  }

  expect_failures = [
    var.string_hardcoded_claims
  ]
}

run "invalid_boolean_claim_name" {
  command = plan

  variables {
    name      = "pix-worker"
    realm_id = "test"
    permissions = {
      "pix-api" = ["reader"]
    }

    boolean_hardcoded_claims = {
      "DebugMode" = {
        value = true
      }
    }
  }

  expect_failures = [
    var.boolean_hardcoded_claims
  ]
}
