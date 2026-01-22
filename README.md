# Terraform + Keycloak SSO Modules

This repository provides reusable Terraform modules for provisioning Keycloak authorization components, enabling secure service-to-service authentication and authorization in microservices architectures.

## Overview

The project implements two main abstractions:
- **Resource Server**: A bearer-only client that defines permissions (roles and scopes) for protected APIs.
- **Service Account**: A confidential client that authenticates via `client_credentials` and consumes permissions from Resource Servers.

Modules are designed for independence, allowing deployment in separate repositories or environments.

## Prerequisites

- [Terraform](https://www.terraform.io/) >= 1.0
- [Docker](https://www.docker.com/) (for testing)
- [Docker Compose](https://docs.docker.com/compose/) (for testing)
- Keycloak instance (or use the provided test setup)

## Quick Start

1. Clone the repository:
   ```bash
   git clone https://github.com/your-org/tf-sso-acme.git
   cd tf-sso-acme
   ```

2. Set up a test Keycloak instance:
   ```bash
   cd test-keycloak
   docker-compose up -d
   ```

3. Initialize and apply Terraform:
   ```bash
   terraform init
   terraform plan
   terraform apply
   ```

4. Verify in Keycloak UI: `http://localhost:8080` (admin/admin).

## Modules

### Resource Server Module

Creates a bearer-only client with roles and scopes.

#### Usage
```hcl
module "pix_api" {
  source   = "./modules/resource-server"
  name     = "pix-api"
  roles    = ["reader", "admin"]
  realm_id = keycloak_realm.acme.id
}
```

#### Outputs
- `client_id`: Generated client ID.
- `role_ids`: Map of role names to IDs.
- `scope_ids`: Map of scope names to IDs.

### Service Account Module

Provisions a confidential OpenID Connect client for service accounts, enabling client_credentials authentication. Assigns permissions from resource servers and optionally includes hardcoded claims in tokens.

Supports claims of types: strings, integers, longs, booleans, with configurable inclusion in ID tokens, access tokens, and UserInfo responses.

#### Example

```hcl
module "my_service_account" {
  source = "./modules/service-account"

  name        = "my-worker"
  permissions = {
    "api-server" = ["read", "write"]
  }
  string_hardcoded_claims = {
    "env" = { value = "production" }
  }
  int_hardcoded_claims = {
    "max-retries" = { value = 5, add_to_userinfo = false }
  }
  realm_id = keycloak_realm.example.id
}
```

#### Outputs
- `client_id`: Generated client ID.
- `client_secret`: Sensitive secret for authentication.

## Testing

### Automated Testing
Run validation and formatting:
```bash
terraform fmt -recursive
terraform validate
```

### Manual Testing
Use the `test-keycloak` directory:
```bash
cd test-keycloak
docker-compose up -d
terraform plan
terraform apply
```

Clean up:
```bash
terraform destroy
docker-compose down
```

### Single Module Test
```bash
cd modules/resource-server
terraform init
terraform validate
```

## Architecture

- **Modules**: Independent and reusable.
- **Naming**: Kebab-case for inputs; prefixed internals (e.g., `acme-{name}`).
- **Provider**: Keycloak Terraform provider v5.6.0.
- **Validation**: Built-in input validations for security and consistency.

## Contributing

1. Follow the guidelines in `AGENTS.md`.
2. Use descriptive commit messages.
3. Run tests before submitting PRs.
4. Update documentation as needed.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues or questions, open a GitHub issue or refer to the Terraform/Keycloak documentation.