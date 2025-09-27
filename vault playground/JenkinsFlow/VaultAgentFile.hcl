auto_auth {
  method "approle" {
    config = {
      role_id_file_path = "/etc/vault/role_id"
      wrapped_token_file_path = "/etc/vault/wrapped_secret_id"
      unwrap_response = true
    }
  }

  sink "file" {
    config = {
      path = "/etc/vault/token"
    }
  }
}

cache {
  use_auto_auth_token = true
}

listener "tcp" {
  address = "127.0.0.1:8200"
}
