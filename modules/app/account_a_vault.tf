resource "vault_mount" "a_db" {
  path = var.a_vault_database_mount
  type = "database"

  namespace = var.a_vault_namespace
}

locals {
  a_postgres_connection_url = nonsensitive("postgresql://{{username}}:{{password}}@${var.a_rds.host}:${var.a_rds.port}/${var.a_rds.database}")
}

resource "vault_database_secret_backend_connection" "a_db" {
  backend       = vault_mount.a_db.path
  name          = "postgres"
  allowed_roles = [var.a_vault_database_role]

  namespace = var.a_vault_namespace

  verify_connection = true

  postgresql {
    connection_url = local.a_postgres_connection_url

    username = var.a_rds.username
    password = var.a_rds.password
  }
}

resource "vault_database_secret_backend_role" "a_db" {
  backend   = vault_mount.a_db.path
  namespace = var.a_vault_namespace

  name    = var.a_vault_database_role
  db_name = vault_database_secret_backend_connection.a_db.name

  creation_statements = [
    "CREATE ROLE \"{{name}}\" WITH LOGIN PASSWORD '{{password}}' VALID UNTIL '{{expiration}}' INHERIT;",
    "GRANT ${var.a_rds.username} TO \"{{name}}\";",
  ]
}
