## vault components

### storage backends

The storage stanza configures the storage backend, which represents the location for the durable storage of Vault's information. These are configured in the file and encryted in transit. 

There is only 1 storage backend/cluster

https://developer.hashicorp.com/vault/docs/configuration/storage

### secrets engine 

Secrets engines are components which **store, generate, or encrypt data**. Secrets engines are incredibly flexible, so it is easiest to think about them in terms of their function. Secrets engines are provided some set of data, they take some action on that data, and they return a result.

Some secrets engines simply store and read data - like encrypted Redis/Memcached. Other secrets engines connect to **other services and generate dynamic credentials on demand**(GCP, AWS Secrets etc). Other secrets engines provide encryption as a service, totp generation, certificates, and much more.

Secrets engines are enabled at a **path in Vault**. When a request comes to Vault, the router automatically routes anything with the route prefix to the secrets engine

(secret engine life cycle)[https://developer.hashicorp.com/vault/docs/secrets#secrets-engines-lifecycle]

https://developer.hashicorp.com/vault/docs/secrets


### auth methods

Auth methods are the components in Vault that perform authentication and are responsible for **assigning identity and a set of policies to a user**. In all cases, Vault will enforce authentication as part of the request processing. In most cases, Vault will delegate the authentication administration and decision to the relevant configured external auth method (e.g., Amazon Web Services, GitHub, Google Cloud Platform, Kubernetes, Microsoft Azure, Okta ...).

Once authenticated, vault will issue a client token used to make all subsequent vault requests. 
- The main goal of all auth methods is to obtain a token.
- each token has an associated policy(or policies) and a TTL(token validity)

https://developer.hashicorp.com/vault/docs/auth


### audit devices

Audit devices are the components in Vault that **collectively keep a detailed log of all requests to Vault**, **and their responses**. Because every operation with Vault is an API request/response, when using a single audit device, the audit log contains every interaction with the Vault API, including errors - except for a few paths which do not go via the audit system. 

Each line in the audit log is a JSON object and any sensitive information are hashed before logging.

vault requires at least one audit device to write the log before completing the vault request. - if enabled.

## vault architecture

![vault_architecture](../images/vault_architecture.png)


## vault path structure

## vault data protection

### seal/unseal

### unseal using key shards

### unsealing using auto-unseal

### unsealing with transit auto-unseal

### pros and cons of unsealing

## vault initialization

### vault configs

## storage backends

## audit devices

## vault interfaces








