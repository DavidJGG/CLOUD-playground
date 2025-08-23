## First of all, install vault 
- https://developer.hashicorp.com/vault/install
- Verify conectivityconnectivity
- Configure ports depending on your requirements
    - 8200
    - 8201

## Generate certificates
### cert.conf
```
[req]
default_bits = 2048
prompt = no
default_md = sha256
req_extensions = req_ext
distinguished_name = dn

[dn]
CN = fqdn

[req_ext]
subjectAltName = @alt_names

[alt_names]
DNS.1 = fqdn
DNS.2 = vault.fqdn
```
### execute the comand after
```
openssl req -x509 -nodes -days 365 \
  -newkey rsa:2048 \
  -keyout certs/cert.key \
  -out certs/cert.crt \
  -config cert.conf \
  -extensions req_ext
```

### copy the certificates
```
cp  cert.crt /opt/vault/tls/
cp  cert.key /opt/vault/tls/

chmod 600 /opt/vault/tls/cert.crt
chmod 600 /opt/vault/tls/cert.key

chown vault:vault /opt/vault/tls/cert.crt
chown vault:vault /opt/vault/tls/cert.key
```

## vault HCL

put it into `/etc/vault.d/vault.hcl`. Make a copy of the current file in that directory.

```
# General parameters
cluster_name = "vault"
log_level = "Info"
ui = true

disable_mlock = false


# HA parameters
cluster_addr = "https://IPV4_ADDR:8201"
api_addr = "https://IPV4_ADDR:8200"

# Listener configuration
listener "tcp" {
 # Listener address
 address     = "0.0.0.0:8200"

 # TLS settings
 tls_disable = 0
 tls_cert_file      = "/opt/vault/tls/cert.crt"
 tls_key_file       = "/opt/vault/tls/cert.key"
 tls_min_version = "tls12"
}

# Storage configuration
#storage "raft" {
#  path    = "/opt/vault/data"
#  node_id = "vault-0"
#  retry_join {
#    leader_tls_servername = "DNS"
#    leader_api_addr = "https://DNS:8200"
#    leader_ca_cert_file = "/opt/vault/tls/cert.crt"
#    leader_client_key_file = "/opt/vault/tls/cert.key"
#  }

storage "file" {
  path = "/opt/vault/data"
}

```

## restart vault service
```
sudo systemctl stop vault
sudo systemctl start vault
journalctl -u vault //Here you can see erros, if exist
```

## see vault status and configure environment variables
```
export VAULT_ADDR=https://dns:8200
export VAULT_SKIP_VERIFY=true // if your certificate is self-signed 
```

## Extra
### Managing ports in RHEL
#### Open ports with firewall-cmd
```
sudo firewall-cmd --zone=public --add-port=8200/tcp --permanent
sudo firewall-cmd --reload
```

#### Close ports with firewall-cmd
```
sudo firewall-cmd --zone=public --remove-port=8200/tcp --permanent
sudo firewall-cmd --reload
```

#### changing zone of the interface
```
sudo firewall-cmd --zone=home --change-interface=eth0 --permanent
sudo firewall-cmd --reload
```

#### Open port with iptables
```
sudo iptables -I INPUT -p tcp --dport 8200 -j ACCEPT
sudo service iptables save
```
#### Close ports with iptables
```
sudo iptables -I INPUT -p tcp --dport 8200 -j REJECT
sudo service iptables save
```