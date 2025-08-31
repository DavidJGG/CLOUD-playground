path "my_org*" {
    capabilities=["create","list"]
}

path "auth/userpass/users/my-org-*" {
    capabilities=["sudo"]
}

path "sys/policies/acl/my-org-*" {
  capabilities = ["create", "update", "read", "delete", "list"]
}