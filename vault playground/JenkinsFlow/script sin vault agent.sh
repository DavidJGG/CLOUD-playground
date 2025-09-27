
vault secrets enable -path=jenkins kv-v2
vault secrets enable -path=microservices kv-v2

vault kv put jenkins/pipeline1/database user="my-user" password="123"
vault kv put microservices/microservice1/database user="my-user-microservice" password="123micro"


# Loading policies
vault policy write jenkins-policy jenkins-policy.hcl
vault policy write app-policy app-policy.hcl


# Enabling AppRole auth
vault auth enable -path=devops approle
vault auth enable -path=microservices approle

# Creating roles


vault write auth/devops/role/jenkins policies=jenkins-policy
vault write auth/microservices/role/micro1 policies=app-policy

vault read auth/devops/role/jenkins/role-id > jenkins-role.txt
vault write -f auth/devops/role/jenkins/secret-id >> jenkins-role.txt

vault write auth/devops/login \
        role_id=bdc0e381-2774-6ce5-bbfc-e82cf03e9462 \
        secret_id=f3e2bdef-f4f4-0d41-b5ba-ab62179c94a1

## jenkins-role.txt contains the info to provide in jenkins

## THIS SECTION CONTAINS THE INTERACTION OF JENKINS WITH VAULT

# Jenkins request a secret id for micro1 
vault read auth/microservices/role/micro1/role-id > micro1-role.txt
vault write -f -wrap-ttl=15m auth/microservices/role/micro1/secret-id >> micro1-role.txt

# Take the wrapping_token and pass it to the APP

## THIS SECTION IS THE APP takes the token and unwrap it
export VAULT_TOKEN=<token>
vault unwrap 
# Key                   Value
# ---                   -----
# secret_id             47a15607-7c0b-f60f-09e0-6a644ac74687
# secret_id_accessor    88842d18-9d29-2d3d-97b2-04d739f3c36b
# secret_id_num_uses    0
# secret_id_ttl         0s

# La app hace un login 
vault write auth/microservices/login \
        role_id=6922ca19-bd18-10de-7c38-4b750ed44c05 \
        secret_id=47a15607-7c0b-f60f-09e0-6a644ac74687





## EXTRA
# to see roles id 
vault read auth/microservices/role/micro1/role-id
vault list auth/microservices/role/micro1/secret-id

vault write auth/microservices/role/micro1/secret-id/destroy \
  accessor=<secret_id_accessor>

vault write auth/microservices/role/micro1/secret-id/destroy accessor=$(vault list auth/microservices/role/micro1/secret-id | tail -n +3)