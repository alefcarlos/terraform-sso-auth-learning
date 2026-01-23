# AGENTS.md - Coding Agent Instructions for Terraform + Keycloak Project

This file provides guidelines and commands for coding agents working on this Terraform + Keycloak project. It covers build/lint/test commands, code style guidelines, and conventions to maintain consistency and quality.

## Table of Contents
1. [Project Overview](#project-overview)
2. [Build and Deployment Commands](#build-and-deployment-commands)
3. [Linting and Formatting](#linting-and-formatting)
4. [Testing](#testing)
5. [Code Style Guidelines](#code-style-guidelines)
6. [Cursor and Copilot Rules](#cursor-and-copilot-rules)

## Project Overview
This project implements Terraform modules for provisioning Keycloak authorization components. The main module is `confidential_client`, which creates a unified client that can define roles (resource server functionality) and/or request permissions from other clients (service account functionality). Component names must be kebab-case and end with '-api', '-worker', '-ios', or '-android'. Modules are independent, reusable, and follow kebab-case naming conventions.

## Build and Deployment Commands
Use these commands to initialize, validate, and deploy the infrastructure.

### Full Initialization and Validation
```bash
# Initialize Terraform in the root or test directory
terraform init

# Validate all configurations
terraform validate

# Format all HCL files
terraform fmt -recursive

# Plan deployment (preview changes)
terraform plan

# Apply changes
terraform apply
```

### Module-Specific Commands
```bash
# For a specific module (e.g., confidential_client)
cd modules/confidential_client
terraform init
terraform validate
terraform fmt
```

### Test Environment Setup
```bash
# In test-keycloak directory
cd test-keycloak
docker-compose up -d  # Start Keycloak + PostgreSQL
terraform init
terraform plan
terraform apply
docker-compose down   # Cleanup
```

## Linting and Formatting
Terraform has built-in tools for linting and formatting.

### Linting
```bash
# Validate syntax and logic
terraform validate

# Use external linters like checkov for security/policy checks
checkov -f . --framework terraform
```

### Formatting
```bash
# Format all files recursively
terraform fmt -recursive

# Check for formatting issues without fixing
terraform fmt -check -recursive
```

### Single File Operations
```bash
# Format a specific file
terraform fmt modules/confidential_client/main.tf

# Validate a specific file
terraform validate -json modules/confidential_client/ | jq
```

## Testing
Since this is infrastructure code, testing focuses on validation and integration testing.

### Running All Tests
```bash
# Validate all modules
find modules -name "*.tf" -exec terraform validate {} \;

# Plan and apply in test environment
cd test-keycloak && terraform plan && terraform apply
```

### Running a Single Test
To test a specific module or configuration:
```bash
# Validate a single module
cd modules/confidential_client && terraform validate

# Test plan for a specific config
cd examples/docker-keycloak && terraform plan

# Integration test: Plan and apply in test env
cd test-keycloak && terraform plan -out=tfplan && terraform apply tfplan
```

For unit-like tests, use `terraform plan` with mock data or validate syntax.

## Code Style Guidelines

### General Principles
- Write clear, maintainable HCL code.
- Follow Terraform best practices for modularity and reusability.
- Use descriptive names; avoid abbreviations unless standard (e.g., `id` for identifier).
- Comment complex logic, especially in locals blocks or dynamic resources.

### Naming Conventions
- **Variables**: kebab-case (e.g., `realm_id`, `client_secret`).
- **Resources**: snake_case with meaningful prefixes (e.g., `keycloak_openid_client.rs`).
- **Modules**: kebab-case (e.g., `confidential_client`).
- **Component Names**: kebab-case ending with '-api', '-worker', '-ios', or '-android' (e.g., 'pix-api', 'cartao-worker').
- **Outputs**: snake_case (e.g., `client_id`).
- **Locals**: snake_case (e.g., `role_assignments`).
- **Files**: snake_case.tf (e.g., `main.tf`, `variables.tf`).

### Formatting
- Use `terraform fmt` for consistent formatting.
- Indent with 2 spaces.
- Align arguments for readability:
  ```hcl
  resource "keycloak_role" "example" {
    realm_id    = var.realm_id
    client_id   = keycloak_openid_client.rs.id
    name        = "example-role"
    description = "An example role"
  }
  ```
- Keep lines under 100 characters where possible.
- Use blank lines to separate logical blocks.

### Types and Variables
- Use explicit types in variable declarations:
  ```hcl
  variable "name" {
    type        = string
    description = "Description here"
    validation {
      condition     = can(regex("^[a-z][a-z0-9]*(-[a-z0-9]+)*$", var.name))
      error_message = "Must be kebab-case"
    }
  }
  ```
- Provide default values where appropriate.
- Use validation blocks for input constraints.
- For maps/lists, specify element types: `type = map(list(string))`.

### Imports and Modules
- Use relative paths for local modules: `source = "../modules/confidential_client"`.
- Avoid hardcoded paths; use variables for dynamic sources if needed.
- Import only necessary providers; specify versions exactly (e.g., `version = "5.6.0"`).
- Group providers in `providers.tf`.

### Error Handling
- Rely on Terraform's built-in error handling (e.g., plan fails on invalid references).
- Use `depends_on` sparingly; prefer implicit dependencies.
- Handle sensitive data with `sensitive = true` in outputs.
- Log errors in comments or use conditional logic for edge cases.

### Resources and Data Sources
- Use descriptive resource names: `resource "keycloak_openid_client" "rs" { ... }`.
- Prefer `for_each` over `count` for dynamic resources.
- Use data sources for external dependencies: `data "keycloak_role" "existing" { ... }`.
- Keep resource blocks focused; split complex logic into locals.

### Security Best Practices
- Never commit secrets; use `client_secret` as sensitive.
- Use bearer-only access for resource servers.
- Disable unnecessary flows in clients (e.g., `standard_flow_enabled = false`).
- Follow principle of least privilege in role assignments.

### Documentation
- Use comments for complex expressions: `# Flatten permissions into assignments`.
- Provide descriptions in variables and outputs.
- Maintain README.md files for modules with usage examples.
- Update AGENTS.md when conventions change.

### Version Control
- Commit formatted code: run `terraform fmt` before commit.
- Use meaningful commit messages.
- Separate concerns: one commit per module/feature.

## Cursor and Copilot Rules
No specific Cursor rules (.cursor/rules/ or .cursorrules) or Copilot rules (.github/copilot-instructions.md) are present in this repository. If added, they should be incorporated here.

### Example Copilot Instructions (if added to .github/copilot-instructions.md)
- Follow Terraform best practices.
- Use kebab-case for user-facing names.
- Prefer `for_each` over `count`.
- Include validations for all variables.

---

This AGENTS.md ensures consistent, high-quality contributions. Update it as the project evolves. For questions, refer to the Terraform documentation or Keycloak provider docs.