# Flujo de Jenkins, Vault y App con AppRole

## bash script
```bash
# Loading policies
vault write policy jenkins-policy jenkins-policy.hcl
vault policy write app-policy app-policy.hcl

# Enabling AppRole auth
vault auth enable approle

# Creating roles
vault write auth/approle/role/jenkins policies=jenkins-policy.hcl
vault write auth/approle/role/app1 policies=app-policy.hcl

## Flow 1 y 2: Jenkins flow

    ### 1. Jenkins obtiene su token usando su propio AppRole (Jenkins-role)
    vault write auth/approle/login \
        role_id=<jenkins-role-id> \
        secret_id=<jenkins-secret-id>

    ### 2. Create the secret id wrapped
    vault write -f -wrap-ttl=5m auth/approle/role/app1/secret-id

    ### 3. Inject the info to the app

## Flow 1 app side
    # 1. Start vault agent with the vault agent file configuration
    vault agent -config=./VaultAgentFile.hcl

    # 2. The app can read secrets through the agent socket
    curl --header "X-Vault-Token: $(cat /etc/vault/token)" http://127.0.0.1:8200/v1/secret/data/myapp


## Flow 2 app side
    # 1. The app receives a wrapped token)

    # 2. Unwrap token
    export VAULT_TOKEN=s.wrapXyZabc123 
    vault unwrap -field=secret_id

    # 3. Login with role_id and secret_id
    vault write auth/approle/login \
        role_id=<role_id> \
        secret_id=<secret_id>
```



```mermaid
flowchart TD
    subgraph Jenkins
        J1(Start Jenkins pipeline)
        J2(Authenticate to Vault using Jenkins AppRole)
        J3(Generate wrapped secret_id using the specific AppRole of the application)
        J4(Inject wrapping token into app host)
    end

    subgraph App_Server
        A1(Vault Agent reads wrapping token)
        A2(Vault Agent unwraps token and authenticates)
        A3(Vault Agent caches client token)
        A4(App reads secrets locally from Vault Agent)
    end

    subgraph Vault
        V1(AppRole login endpoint)
        V2(Returns temporary token)
        V3(Serves app secrets)
    end

    J1 --> J2 --> J3 --> J4 --> A1
    A1 --> A2 --> V1 --> V2 --> A3 --> A4 --> V3
```

## Flow 2: Without Vault Agent on the app

```mermaid
flowchart TD
 subgraph Jenkins["Jenkins"]
        J1("Start Jenkins pipeline")
        J2("Authenticate to Vault using Jenkins AppRole")
        J3("Generate wrapped secret_id using the specific AppRole of the application")
        J4("Inject wrapping token into app host")
  end
 subgraph App_Server["App_Server"]
        A1("App reads role_id and wrapped secret_id token")
        A2("App unwraps the token")
        A3("App logs in to Vault with AppRole")
        A4("Vault returns client token")
        A5("App uses token to read secrets directly from Vault")
  end
 subgraph Vault["Vault"]
        V1("AppRole login endpoint")
        V2("Returns temporary token")
        V3("Serves app secrets")
  end
    J1 --> J2
    J2 --> J3
    J3 --> J4
    J4 --> A1
    A1 --> A2
    A2 --> A3
    A3 --> V1
    V1 --> V2
    V2 --> A4
    A4 --> A5
    A5 --> V3
```