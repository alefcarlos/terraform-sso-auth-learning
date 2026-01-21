1. Start Keycloak with PostgreSQL:
   cd test-keycloak
   docker-compose up -d

2. Wait for Keycloak to fully start (check logs: docker-compose logs -f keycloak). It may take 1-2 minutes.

3. Run Terraform commands:
   terraform init
   terraform plan
   terraform apply

4. To stop:
   docker-compose down

Note: This is for local testing only. Default admin credentials: admin/admin.