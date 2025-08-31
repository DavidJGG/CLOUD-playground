


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


vault write identity/entity name="FOR-IT-TEAM" policies="my-org-entity-policy-select,my-org-entity-policy-deny" \
        metadata=organization="The Company" \
        metadata=devteam="DEVS"
# output
    # Key        Value
    # ---        -----
    # aliases    <nil>
    # id         822d507e-08d9-9824-1a24-103b971abb36
    # name       FOR-IT-TEAM


#LAS VERSIONES RESIENTES DE VAULT (>1.7.5 & >1.8.4) SOLO SOPORTAN EN LAS ENTIDADES 1 ALIAS POR METODO DE AUTENTICACION 

vault auth list -format=json | jq -r '.["userpass/"].accessor' > userpass_accessor.txt

# Create entity; generated ID: cf942351-db7c-c0c1-9a99-4ebf5c899282
vault write identity/entity name="george-smith" policies="my-org-entity-policy-select,my-org-entity-policy-deny" \
        metadata=organization="Globomantics Inc." \
        metadata=devteam="The A Team" \
        metadata=secondrole="trainer"

# Add users to entity as aliases
vault write identity/entity-alias name="my-org-consumer" \
        canonical_id="cf942351-db7c-c0c1-9a99-4ebf5c899282" \
        mount_accessor=$(cat userpass_accessor.txt)

#este comando dara error
vault write identity/entity-alias name="my-org-lead" \
        canonical_id="cf942351-db7c-c0c1-9a99-4ebf5c899282" \
        mount_accessor=$(cat userpass_accessor.txt)