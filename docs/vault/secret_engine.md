## secrets

### static secrets

what issues you get while using static secrets

![static_secrets_issue](../images/static_secrets_issue.png)

### dynamic secrets

![dynamic_secrets](../images/dynamic_secrets.png)

### example for application using vault 

![dynamic_secrets_example](../images/dynamic_secrets_example.png)


![dynamic_secrets_example_1](../images/dynamic_secrets_example_1.png)


## secret engine 

Secrets engines are components that can store, generate, or encrypt data
- Many secrets engines can be enabled in Vault
- You can even enable multiple instances of the same secrets engine
- Secrets engines are plugins that extend the functionality of Vault

Secrets engines are enabled and isolated at a path
- All interactions with the secrets engine are done using the path
- Path must be unique

### secrets-as-a-service

Use Vault to generate and manage the lifecycle of credentials on-demand
• No more sharing credentials
• Credentials get revoked automatically at the end of its lease
• Audit trail can identify points of compromise
• Use policies to control the access based on the client's role

![secret_as_service](../images/secret_as_service.png)

### enable secret engine

- Cubbyhole and Identity are enabled by default (can’t disable)
- Any other secrets engine must be enabled, enable using the CLI, API, or UI (most)

Secrets engines are enabled and isolated at a path
- All interactions with the secrets engine are done using the path
- Path must be unique
- Paths do not need to match the secrets engines name or type
- Make them meaningful for you and your organization

### responsibilities

**vault admin/securtiy team**
1. Enable the Secrets Engine
2. Configure the connection to the backend platform (AWS, Database, etc.)
3. Create roles that define permissions to the backend platform
4. Create policies that grant permission to read from the secrets engine

**vault client(app/sercvices/users/machines)**

1. Read a set of credentials using token and associated policy
2. Renew the lease before its expiration if needed (or permitted)
3. Renew the token if needed (or permitted)

**How to enable vault secrets**

```
vault secrets enable aws
vault secrets tune -default-lease-ttl=72h pki/

vault secrets list
vault secrets list –detailed
vault secrets enable –path=developers kv
vault secrets enable –description="my first kv" kv
```

### configure secret engine

configuring a secrets engine that will generate dynamic credentials. vault client must be authenticated before it can be requested for dynamic credentials.

**Step 1: Configure Vault with access to the platform**

Example 1: Vault to AWS 

The path is the default path for aws to configure `aws/config/root`

Provide credentials to a secrets engine that gives Vault permission to create, list, and delete credentials on the platform:

```
vault write aws/config/root access_key=AKIAIOSFODNN7EXAMPLE secret_key= wJalrXUtnFEMI/K7MDENGbPxRfiCYEXAMPLEKEY region=us-east-1
```

Example 2: vault to db

default path for vault to configure database `database/config/prod-database`

```
vault write database/config/prod-database \
plugin_name=mysql-aurora-database-plugin \
connection_url="{{username}}:{{password}}@tcp(prod.cluster.us-east-1.rds.amazonaws.com:3306)/" \
allowed_roles="app-integration, app-lambda" \
username="vault-admin" \
password="vneJ4908fkd3084Bmrk39fmslslf#e&349"
```

For other services, you need to refer to the documentation.

**Step 2: Configure Roles based on permissions needed**

Vault does not know what permissions, groups, and policies you want to attach to generated credentials. Each role maps to a set of permissions on the targeted platform.

![aws_generate_credentials](../images/aws_generate_credentials.png)

```
vault read aws/creds/data-consultant
```

![db_generate_credentials](../images/db_generate_credentials.png)

```
vault read database/creds/oracle-reporting
```

## kv secret engine

Key/Value secrets engine is used to store static secrets
- There are two versions: v2 (kv-v2) is versioned but v1 (v1) is not.
- Secrets are accessible via UI, CLI, and API – interactive or automated
- Access to KV paths are enforced via policies (ACLs).

like everything else in Vault, secrets written to the KV secrets engine are encrypted using 256-bit AES.

Key/Value secrets engine can be enabled at different paths, each key/value secrets engine is isolated and unique
- Secrets are stored as key-value pairs at a defined path – (e.g.,secret/applications/web01)
- Writing a new secret will replace the old value (i.e v1 or v2).
- Writing a new secret requires the create capability.
- Updating/overwriting a secret to an existing path requires update capability.

When you run Vault in **–dev server mode**, Vault enables a KV v2 secrets engine at the secret/ path, by default

### organize kv engine

Organize Data However It Makes Sense to Your Organization

![organize_kv_engine](../images/organize_kv_engine.png)

![organize_kv_engine_1](../images/organize_kv_engine_1.png)

```
vault secrets enable kv
vault secrets enable –path=training kv
vault secrets list –detailed

vault secrets enable kv-v2
vault secrets enable –path=training –version=2 kv
vault secrets list –detailed
```

how v2 is different from v1?

Introduces two prefixes that must be accounted for when referencing secrets and/or metadata

- cloud/data – data is where the actual K/V data is stored
- cloud/metadata – the metadata prefix stores our metadata about a secret
  
The data/ and metadata/ prefix is required for API and when writing Vault policies
It does NOT change the way you interact with the KV store when using the CLI.

### working with kv engine

Use the vault kv command
• put - write data to the KV
• get - read data from the KV
• delete - delete data from the KV
• list - list data within the KV (paths)

Only available for KV V2

• undelete - undelete version of secret
• destroy - permanently destroy data
• patch - add specific key in the KV
• rollback - recover old data in the KV


```
vault kv put kv/app/db pass=123 
vault kv put kv/app/db pass=123 user=admin api=a8ee4b50cce124
vault kv put kv/app/db @secrets.json

vault kv get kv/app/db
vault kv put kv/app/db api=39cms1204mfi2m

vault kv rollback -version=1 kv/app/db
vault kv patch kv/app/db user=bryan
vault kv get kv/app/db
vault kv get -format=json kv/app/db

vault kv get –version=3 kv/app/db
```


  

### deleting kv

If the latest version of the secret has been deleted (KV V2), it will return the related metadata.

You can read a previous version of a secret (if one exists) by adding the –version=x flag to the request

- A delete on KV V1 is a delete – the data is destroyed
- You'd have to restore Vault/Consul to retrieve the old data
- A delete on KV V2 is a soft delete – data is not destroyed
- Data can be restored with a undelete/rollback action
- A destroy (only KV V2) is a permanent action – destroyed on disk
- Cannot be restored except for a Vault/Consul restore action

```
vault kv delete secret/app/database #latest version is deleted
vault kv delete secret/app/database --version=2 # previous version deleted
vault kv get secret/app/database
```

```
vault kv destroy –versions=3 secret/app/web
```

## cubbyhole 

cubbyhole secret engine is used to store the arbitary secrets enabled by default at cubbyhole/ path. Its lifeline is linked to the token used to write data. 

- no concept of TTL or any refresh tokens
- even root token cannot be read if its not written by root. 

cubbyhole secrets engine cannot be disabled, moved, or enabled multiple times. 

- each service will have its own cubbyhole. 
- one token of cubbyhole cannot access another services cubbyhole. 
- cubbyhole expires when token expires. 

```
vault secrets list
vault write cubbyhole/training certification=hcvop
vault read cubbyhole/training

curl \
    --header "X-Vault-Token: ..." \
    --request POST \
    --data '{"certification":"hcvop"}' \
    http://127.0.0.1:8200/v1/cubbyhole/training


curl \
    --header "X-Vault-Token: ..." \
    --request LIST \
    http://127.0.0.1:8200/v1/cubbyhole/training

```

### wrapping response

If one user has to send slack token to another, it can't be shared across any messager as it would be sent in the plain text, hence we use wrapping resonse where the token creates a cubbyhole and the other user can access using it. 

When requested, Vault can take the response it would have sent to an HTTP client and instead insert it into the cubbyhole of a single-use token, returning that single-use token instead. 

Logically speaking, the response is wrapped by the token, and retrieving it requires an unwrap operation against this token. Functionally speaking, the token provides authorization to use an encryption key from Vault's keyring to decrypt the data.

![wrap_response](../images/wrap_response.png)

### benefits

- privacy
- malfeasance detection
- limitation of the lifetime secret exposure

Reference: https://developer.hashicorp.com/vault/docs/concepts/response-wrapping

```
vault kv get -wrap-ttl=5m secrets/certification/hcvop
vault token lookup <wrap_token>


vault unwrap <wrap-token>
OR
vault VAULT_TOKEN=<wrap-token> vault unwrap
OR
vault login <wrap-token>
vault unwrap
```

## vault transit secret engine 

Transit secrets engine provides functions for encrypting/decrypting data,  Enables organizations to outsource/centralize encryption to Vault.

Applications can send cleartext data to Vault for encryption
• Vault encrypts using the specified key and returns ciphertext to the app
• The application NEVER has access to the encryption key (stored in Vault)
• Decouples storage from encryption and access control

![transit_secret_engine](../images/transit_secret_engine.png)

Note: Transit secrets engine DOES NOT STORE the encrypted data. It would encrypt and returns cipher teext back to application.

Encryption keys are created and stored in Vault to process data
• Each application can have its own encryption key (or more!)
• Apps must have permission to use the key for encryption/decryption operations, which is bound by the policy attached to its token.

Keys can be easily rotated as often as needed
• Keys are stored on keyring
• Can limit what version(s) of keys can be used for decryption
• You can create, rotate, delete, and export a key (need permissions)
• Easily rewrap ciphertext with a newer version of a key

![transit_secret_engine_multiple_key](../images/transit_secret_engine_multiple_key.png)


![transit_secret_engine_keytypes](../images/transit_secret_engine_keytypes.png)


Vault also supports convergent encryption mode
• Means that every time you encrypt the same data, you'll get the same
ciphertext back
• This enables you to have searchable ciphertext

### working with vault transit secret engine

Before you can use the Transit secrets engine to encrypt data, it must first be enabled
we can use the default path of transit or enable on another path.

The next step is to create one or many encryption keys used to encrypt/decrypt data

**Encrypt**

```
vault secrets enable transit
vault write -f transit/keys/vault_training
vault write -f transit/keys/training_rsa type="rsa-4096"
```

Pass the cleartext data to Vault – specifying the action and desired encryption key to use

```
vault write transit/encrypt/training plaintext=$(base64 <<< "Getting Started with HashiCorp Vault")
```

![transit_secret_engine_desc](../images/transit_secret_engine_desc.png)


**Decrypt**

```
vault write transit/decrypt/training ciphertext="vault:v1:Fpyph6C7r5MUILiEiFhCoJBxelQbsGeEahal5LhDPSoN6HkTO………"
```

### Rotating encryption keys

Transit allows for a simplified key rotation process
• keys can be rotated manually or by an <external> automated process

Vault maintains a versioned keyring
• All versions of the encryption key are stored
• Vault admins can limit the minimum key version allowed to be used for decryption operations (older keys won't work)
• You can rewrap encrypted data (ciphertext) to use a newer version of the encryption key

```
vault write –f transit/keys/training/rotate
vault read transit/keys/training
```

#### key configuration 

We can limit what version of the key can be used to decrypt data
• Maybe we have old data that we have converted and don't want anybody to be able to decrypt it
• This is configured using the minimum key version configuration
• It can be configured for each encryption key (not key version)

```
vault write transit/keys/training/config min_decryption_version=4
vault read transit/keys/training
```

#### Rewrapping Ciphertex 

How can we upgrade our **encrypted data to be encrypted by the latest version of the key**?

The data was never available in plaintext when rewrapping the data with the latest version of the key

```
 vault write transit/rewrap/training \
ciphertext="vault:v1:Fpyph6C7r5MUILiEiFhCoJBxelQbsGeEahal5LhDPSoN6
HkTOhwn79DCwt0mct1ttLokqikAr0PAopzm2jQAKJg=2/QGPTMnzKPlw4cCPGTbkzE
PlX5OyPkLIgX+erFWdUXKkKUIEbb6D2Gm5ZjTaola314LsVkbLF5G1RkBTACtskk="
```
