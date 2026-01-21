# Resource Server Module

This module provisions a **Resource Server** in Keycloak, representing a service that exposes protected endpoints and defines permissions.

## Usage

```hcl
module "pix_api" {
  source   = "./modules/resource-server"
  name     = "pix-api"
  roles    = ["reader", "admin"]
  realm_id = var.realm_id
}
```

## Inputs

- `name` (required): Kebab-case name (e.g., "pix-api").
- `roles` (optional): List of roles; defaults to ["viewer"].
- `realm_id` (required): Realm ID.

## Outputs

- `client_id`: Generated client ID (e.g., "acme-pix-api").
- `role_ids`: Map of role names to IDs.
- `scope_ids`: Map of scope names to IDs.

## What It Creates

- **Client**: Bearer-only client for authorization.
- **Roles**: Client roles with prefix "acme-{name}:".
- **Scopes**: 1:1 with roles.
- **Mappers**: Links roles to scopes.

## Notes

- Validates kebab-case inputs.
- If no roles, creates "viewer" role.