# Service Account Module

This module provisions a **Service Account** in Keycloak, representing a consumer that authenticates via client_credentials and consumes permissions from Resource Servers.

## Usage

```hcl
module "pix_worker" {
  source      = "./modules/service-account"
  name        = "pix-worker"
  permissions = {
    "pix-api" = ["reader"]
  }
  realm_id = var.realm_id
}
```

## Inputs

- `name` (required): Kebab-case name (e.g., "pix-worker").
- `permissions` (required): Map of RS names to role lists.
- `realm_id` (required): Realm ID.

## Outputs

- `client_id`: Generated client ID (e.g., "sa-acme-pix-worker").
- `client_secret`: Sensitive secret for authentication.

## What It Creates

- **Client**: Confidential client with service accounts enabled.
- **Role Assignments**: Associates existing roles from RS clients to the SA's user.

## Notes

- Assumes RS modules have created roles with naming convention.
- Fails if roles don't exist.