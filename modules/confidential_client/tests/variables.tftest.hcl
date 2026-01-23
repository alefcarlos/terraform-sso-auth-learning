mock_provider "keycloak" {}

#################################
# ✅ SUCCESS CASES
#################################

# Resource server only (no service account)
run "valid_resource_server_only" {
  command = plan

  variables {
    name      = "pix-api"
    realm_id = "test-realm"

    roles = ["reader", "writer"]
  }
}

# Minimal confidential client (permissions only)
run "valid_confidential_client_minimal" {
  command = plan

  variables {
    name      = "pix-worker"
    realm_id = "test-realm"

    permissions = {
      "pix-api" = ["reader"]
    }
  }
}

# Full confidential client with claims
run "valid_confidential_client_full" {
  command = plan

  variables {
    name      = "batch-worker"
    realm_id = "realm-123"

    permissions = {
      "pix-api"     = ["reader", "writer"]
      "cartao-api" = ["viewer"]
    }

    string_hardcoded_claims = {
      "app-role" = {
        value = "worker"
      }
    }

    int_hardcoded_claims = {
      "max-retries" = {
        value = 3
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

#################################
# ❌ FAILURE CASES
#################################

# Invalid component name strating with acme-
run "invalid_name_format_starting_with_acme" {
  command = plan

  variables {
    name      = "acme-pix-Worker"
    realm_id = "test"

    roles = ["reader"]
  }

  expect_failures = [
    var.name
  ]
}

# Invalid component name
run "invalid_name_format" {
  command = plan

  variables {
    name      = "Pix_Worker"
    realm_id = "test"

    roles = ["reader"]
  }

  expect_failures = [
    var.name
  ]
}

# Invalid role name
run "invalid_role_name" {
  command = plan

  variables {
    name      = "pix-api"
    realm_id = "test"

    roles = ["Read_Only"]
  }

  expect_failures = [
    var.roles
  ]
}

# Invalid permissions resource server key
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

# Invalid permissions role name
run "invalid_permissions_role_name" {
  command = plan

  variables {
    name      = "pix-worker"
    realm_id = "test"

    permissions = {
      "pix-api" = ["ReadOnly"]
    }
  }

  expect_failures = [
    var.permissions
  ]
}

# Invalid string claim name
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

# Invalid boolean claim name
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
