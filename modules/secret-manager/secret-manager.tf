resource "google_secret_manager_secret" "db-url" {
  secret_id = "db-url"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "db-url" {
  secret      = google_secret_manager_secret.db-url.id
  secret_data = var.db_url
}

resource "google_secret_manager_secret" "db-username" {
  secret_id = "db-username"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "db-username" {
  secret      = google_secret_manager_secret.db-username.id
  secret_data = var.db_username
}

resource "google_secret_manager_secret" "db-password" {
  secret_id = "db-password"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "db-password" {
  secret      = google_secret_manager_secret.db-password.id
  secret_data = var.db_password
}

resource "google_secret_manager_secret" "root" {
  secret_id = "root-db-password"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "root" {
  secret      = google_secret_manager_secret.root.id
  secret_data = var.root_db_password
}

resource "google_secret_manager_secret" "moodle-admin-pass" {
  secret_id = "moodle-admin-pass"
  replication {
    automatic = true
  }
}

resource "google_secret_manager_secret_version" "moodle-admin-pass" {
  secret      = google_secret_manager_secret.moodle-admin-pass.id
  secret_data = var.moodle-admin-pass
}