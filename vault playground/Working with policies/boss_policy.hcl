path "my_org*" {
    capabilities=["create", "update", "read", "delete", "list"]
}

path "my_org/IT/*" {
    capabilities=["create", "update", "delete"]
}

path "auth/userpass/users/my-org-*" {
    capabilities=["sudo"]
}

path "sys/policies/acl/my-org-*" {
  capabilities = ["create", "update", "read", "delete", "list"]
}