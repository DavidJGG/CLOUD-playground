


#creating boss user


vault policy write boss_policy ./boss_policy.hcl
vault policy write my-org-entity-policy-select ./entity_policy_select.hcl
vault policy write my-org-entity-policy-deny ./entity_policy_deny.hcl
vault policy write my-org-full-it-secret-access-policy ./full_it_secret_access_policy.hcl

vault write "my_org/IT/secret1" secret1="my_secret_1"
vault write "my_org/IT/private/secret2" secret2="my_secret_2"
vault write "my_org/IT/qa/secret3" secret3="my_secret_3"

vault write auth/userpass/users/my-org-boss password="123"
vault write "auth/userpass/users/my-org-boss" policies="boss_policy"

vault write "auth/userpass/users/my-org-lead" password="123" policies="my-org-full-it-secret-access-policy"
vault write "auth/userpass/users/my-org-consumer" password="123"


# output
    # Key        Value
    # ---        -----
    # aliases    <nil>
    # id         822d507e-08d9-9824-1a24-103b971abb36
    # name       FOR-IT-TEAM


#LAS VERSIONES RESIENTES DE VAULT (>1.7.5 & >1.8.4) SOLO SOPORTAN EN LAS ENTIDADES 1 ALIAS POR METODO DE AUTENTICACION 

vault list identity/entity/id

vault auth list -format=json | jq -r '.["userpass/"].accessor' > userpass_accessor.txt

#**************************************************************************************************************************
#**************************************************************************************************************************
#**************************************************************************************************************************
#**************************************************************************************************************************
#**************************************************************************************************************************

# Create entity; generated ID: 2f1923f9-240f-008a-22e1-4c7a3fbd2169
vault write identity/entity name="The-Consumer" policies="my-org-entity-policy-deny" \
        metadata=organization="My ORG" \
        metadata=devteam="Consumer"

# Add users to entity as aliases
vault write identity/entity-alias name="my-org-consumer" canonical_id="2f1923f9-240f-008a-22e1-4c7a3fbd2169" mount_accessor=auth_userpass_928e3956

#**************************************************************************************************************************
#**************************************************************************************************************************
#**************************************************************************************************************************
#**************************************************************************************************************************

# Create entity; generated ID: 2133ba87-c464-faa8-c1c6-e9b854597903
vault write identity/entity name="The-Lead" policies="my-org-entity-policy-deny" \
        metadata=organization="My ORG" \
        metadata=devteam="Lead"

# Add users to entity as aliases
vault write identity/entity-alias name="my-org-lead" canonical_id="2133ba87-c464-faa8-c1c6-e9b854597903" mount_accessor=auth_userpass_928e3956

#**************************************************************************************************************************
#**************************************************************************************************************************
#**************************************************************************************************************************
#**************************************************************************************************************************


# Create entity; generated ID: d96797e3-7b29-e37d-7f74-ff1de094368c
vault write identity/entity name="The-Boss" \
        metadata=organization="My ORG" \
        metadata=devteam="Boss"

# Add users to entity as aliases
vault write identity/entity-alias name="my-org-boss" canonical_id="d96797e3-7b29-e37d-7f74-ff1de094368c" mount_accessor=auth_userpass_928e3956

#**************************************************************************************************************************
#**************************************************************************************************************************
#**************************************************************************************************************************
#**************************************************************************************************************************
#**************************************************************************************************************************
#**************************************************************************************************************************


vault list identity/entity/id

#ID 89f6d729-321f-b22b-ec59-ba6372f55dc8
vault write identity/group/name/my-org-group policies="my-org-entity-policy-select" type=internal
vault write identity/group/id/89f6d729-321f-b22b-ec59-ba6372f55dc8 member_entity_ids=2133ba87-c464-faa8-c1c6-e9b854597903,2f1923f9-240f-008a-22e1-4c7a3fbd2169,d96797e3-7b29-e37d-7f74-ff1de094368c


# LOGIN AS BOSS
vault login -method=userpass username=my-org-boss
vault policy write my-org-path-per-user ./path_per_user.hcl
vault write "auth/userpass/users/my-org-lead" policies="my-org-path-per-user,my-org-full-it-secret-access-policy"
vault write "auth/userpass/users/my-org-consumer" policies="my-org-path-per-user"








#TO WRITE AND READ IN THE PERSONAL FOLDER
vault write my_org/IT/personal/$(vault token lookup -format=json | jq -r ".data.entity_id" | sed 's/[\r\n]//g')/aws-dev name=lead pass="asfasfasdfasdf"
vault read my_org/IT/personal/$(vault token lookup -format=json | jq -r ".data.entity_id" | sed 's/[\r\n]//g')/aws-dev name=lead   