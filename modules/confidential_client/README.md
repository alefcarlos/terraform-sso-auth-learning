# Confidential Client Module

This module provisions a **Client** in Keycloak, representing a component that can define roles (as a resource server) and/or request permissions from other components (as a service account).

## Usage

### As a Resource Server (defines roles)
```hcl
module "pix_api" {
  source   = "./modules/confidential_client"
  name     = "pix-api"
  roles    = ["reader", "admin"]
  realm_id = var.realm_id
}
```

### As a Service Account (requests permissions)
```hcl
module "pix_worker" {
  source = "./modules/confidential_client"
  name   = "pix-worker"
  permissions = {
    "pix-api"    = ["reader"]
    "cartao-api" = ["viewer"]
  }
  string_hardcoded_claims = {
    "app-role" = { value = "worker" }
  }
  realm_id = var.realm_id
}
```

### As Both (defines roles and requests permissions)
```hcl
module "mobile-ios" {
  source = "./modules/confidential_client"
  name   = "mobile-ios"
  roles  = ["viewer"]
  permissions = {
    "api" = ["access"]
  }
  realm_id = var.realm_id
}
```

## Inputs

- `name` (required): Kebab-case component name ending with '-api', '-worker', '-ios', or '-android', not starting with 'acme-' (e.g., "pix-api").
- `roles` (optional): List of roles to define; if empty, no roles are created.
- `permissions` (optional): Map of component names to roles to request; if provided, enables service account.
- `realm_id` (required): Realm ID.
- `string_hardcoded_claims` (optional): Hardcoded string claims for service account (only if permissions set).
- `int_hardcoded_claims` (optional): Hardcoded int claims.
- `long_hardcoded_claims` (optional): Hardcoded long claims.
- `boolean_hardcoded_claims` (optional): Hardcoded boolean claims.

## Outputs

- `client_id`: Generated client ID (e.g., "acme-pix-api").
- `role_ids`: Map of role names to IDs (if roles defined).
- `scope_ids`: Map of scope names to IDs (if roles defined).
- `client_secret`: Client secret (if service account enabled, sensitive).

## What It Creates

- **Client**: Bearer-only if no permissions, Confidential with service account if permissions provided.
- **Roles**: Client roles with prefix "acme-{name}:" (if roles defined).
- **Scopes**: 1:1 with roles (if roles defined).
- **Mappers**: Links roles to scopes (if roles defined).
- **Permissions**: Assigns requested roles to service account user (if permissions provided).
- **Hardcoded Claims**: Protocol mappers for claims (if permissions and claims provided).

## Notes

- Validates kebab-case inputs.
- Client ID is always "acme-{name}".
- If permissions provided, client is confidential; otherwise, bearer-only.