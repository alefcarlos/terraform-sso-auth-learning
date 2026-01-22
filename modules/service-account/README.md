# Service Account Module

This module provisions a **Service Account** in Keycloak, representing a consumer that authenticates via client_credentials and consumes permissions from Resource Servers.

## Usage

```hcl
module "pix_worker_claims" {
  source      = "./modules/service-account"
  name        = "pix-worker"
  permissions = {
    "pix-api" = ["reader"]
  }
  string_hardcoded_claims = {
    "app-role" = {
      value           = "worker"
      add_to_userinfo = false  # Override default
    }
    "env" = {
      value = "prod"  # Uses all defaults
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
  realm_id = var.realm_id
}
```

## Inputs

- `name` (required): Kebab-case name (e.g., "pix-worker").
- `permissions` (required): Map of RS names to role lists.
- `realm_id` (required): Realm ID.
- `string_hardcoded_claims` (optional): Map of claim names (kebab-case) to objects defining hardcoded string claims. Each object has:
  - `value` (required): The string value for the claim.
  - `add_to_id_token` (optional): Whether to add to ID token (default: true).
  - `add_to_access_token` (optional): Whether to add to access token (default: true).
  - `add_to_userinfo` (optional): Whether to add to UserInfo response (default: true).
  - `claim_value_type` (optional): Serialization type (default: "String"; options: String, JSON, long, int, boolean).
- `int_hardcoded_claims` (optional): Map of claim names to objects defining hardcoded int claims (similar structure, `value` is number, default `claim_value_type`: "int").
- `long_hardcoded_claims` (optional): Map of claim names to objects defining hardcoded long claims (similar structure, default `claim_value_type`: "long").
- `boolean_hardcoded_claims` (optional): Map of claim names to objects defining hardcoded boolean claims (similar structure, `value` is bool, default `claim_value_type`: "boolean").

## Outputs

- `client_id`: Generated client ID (e.g., "sa-acme-pix-worker").
- `client_secret`: Sensitive secret for authentication.

## What It Creates

- **Client**: Confidential client with service accounts enabled.
- **Role Assignments**: Associates existing roles from RS clients to the SA's user.
- **Hardcoded Claim Mappers** (if configured): Adds specified claims to tokens.

## Notes

- Assumes RS modules have created roles with naming convention.
- Fails if roles don't exist.