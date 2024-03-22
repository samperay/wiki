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
