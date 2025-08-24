## Generate without pgp keys
```
vault operator init -key-shares=5 -key-threshold=3
```

## Generate pgp keys
```
gpg --batch --gen-keys keyconfig1 
gpg --batch --gen-keys keyconfig2
gpg --batch --gen-keys keyconfig3
```
or
```
gpg --gen-keys
```

save the keys in base64
```
gpg --export cto | base64 > cto.asc
gpg --export leader | base64 > leader.asc
gpg --export senior | base64 > senior.asc
```

## Use generated keys to initialize vault
```
export VAULT_SKIP_VERIFY=true
export VAULT_ADDR="https://dns:8200"
vault operator init -key-shares=3 -key-threshold=2 -pgp-keys="cto.asc,leader.asc,senior.asc"
```

Vault will give you the unseal keys. Also will give you the root token
```
echo "UNSEALED_KEY_RETURNED" | base64 --decode | gpg -u cto -dq > ctokey.txt
echo "UNSEALED_KEY_RETURNED" | base64 --decode | gpg -u leader -dq > leaderkey.txt
echo "UNSEALED_KEY_RETURNED" | base64 --decode | gpg -u senior -dq > seniorkey.txt

```

Save the keys

## Unsealed vault 
```
vault operator unseal
```
Enter the keys to unseal vault

## Login
```
vault login 
```
It will ask you for root token

#NOT FORGET TO REVOKE ROOT TOKEN AFTER CREATE ROLES, ROOT TOKEN MUST NOT BE USED AS ADMIN ROLE