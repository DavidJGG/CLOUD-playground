path "jenkins/data/pipeline1/*" {
  capabilities=["read", "list", "create"]
}

path "auth/microservices/role/micro1/*" {
  capabilities=["read", "list", "create", "update", "delete"]
}