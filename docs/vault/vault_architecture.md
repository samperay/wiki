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

[vault architecture document](https://developer.hashicorp.com/vault/docs/internals/architecture)

## vault path structure

- Everything in vault is path-based
- path prefix tells vault which component a request should be routed
- secret engines, auth methods, audit devices are "mounts" at a specified path referred as mount
- system backend is default backend in vault which is mounted at the /sys endpoint
- vault components can be enabled at ANY path using --path flag or it does by default path
- vault has few system paths what are resrved and you cannot use it. 
    - auth/  - endpoint for auth methods configs
    - cubbyhole - endpoint for cubbyhole secrets engine
    - identity/ - endpoint for config vault identity
    - secret/  - endpoint used by key/vaulut v2 secrets engine if running in dev mode
    - sys/ - system endpoint for config vault

## vault data protection

How data is stored in vault...

**master key:** 
- used to decrypt the encryption key
- created during vault init or rekey ops
- never written to storage when using traditional **unseal** mechanism
- written to core/master(storage backend) when using **auto unseal**

**encryption key:**
- used to encrypt/decrypt data written to storage backend.
- encrypted by the master key.
- stored alongside the data in a keyring on the storage backend.
- can be easily rotated(manual ops).

### seal/unseal

- vault starts in a **sealed** state, meaning it knows where to access the data and how **but can't decrypt it**, which means there is no read or write etc.. i.e almost no ops are possible when vault in a sealed state.
- unsealing vault means that a node can reconstruct the master key in order to decrypt the encryption key and untilmately read the data, after **unsealing the encryption key is stored in the memory**, it can be unsealed using CLI/UI options
- incase you need to **seal vault** i.e "throw away" the encrytpion key, it requires another **unseal to perform** any further ops. When I need to seal vault ?
  - key shars are exposed
  - detecting of compromise or netwrom intrustions
  - spyware/malware on the vault nodes

### unseal using key shards

We know, by now that master key is required to encrypt "encryption key" to store the data in the backend.. so how do we protect the "master key". It is done by "key shards". In this key shards, vault expects alteast 3 keys to provide to unseal the master key. These key shards would be available to min of 5 members when we init the vault using diff encryption alogrithms. when you are unsealing you will provide equal number of employees to provide their key which is equal to threshold.

As part of security, no single person should have all the key shards, and it should never be stored online.

```
vault status
vault operator init
<vault status set to initialized>
<displays 5 keys along with root token>

vault status
vault operator unseal
<enter any of 3/5 keys from above until status of thershold is met>

vault status

vault login <root-token> # you would authenticate the cluster

vault secrets list
```

### unsealing using auto-unseal

When we have an vault mainteance, or restart of service, vault would seal itself. so we need a place so that it would unseal itself.. 

instead of key shards being with 5 ppl, you would have a key stored in the **cloud services**(KMS) to **encrypt/decrypt the master key**. encrypted master key is stored in the backend in core using KMS, so incase if vault restarts, it would read the encrypted master key using KMS then decrypt the master key which would then decrypt encryption key which will store in the memory to read/write secrets on the vault node.

You can find in the config file `/etc/vault/vault.hcl`

Create a new KMS key and provide an endpoint for `kms_key_id`. That would be sufficient when vault restarts or so, it would use the KMS key to get it unsealed.. 

```
seal "awskms" {
    region = REGION
    kms_key_id = "KMSKEY"
}
```

### unsealing with transit auto-unseal

We would be having an **vaulut cluster running transit secret engine** from which we would be unsealing the vault. In other words, we would use that one cluster dependent on another cluser for unsealing.

This supports key rotation and also can be configured for HA.

```
seal "transit" {
  address: "https://vault.example.com:8200",
  token ="x.Qft42..", - acl token to use if enabled.
  disable_renewal = "false" 
}

key_name = "transit_key_name", - transit key used for encryption/decryption
mount_path = "transit/", - mount path to transit secret engine
namespace = "ns1/" - namespace path to transit secret engine.
```

Configure transite secret engine..

host: 192.168.56.100

```
vault secrets enable transit
vault write -f transit/keys/unseal-key
vault list transit/keys

vim policies.hcl

path "transit/encrypt/unseal-key" {
  capabilities = ["update"]
}

path "transit/decrypt/unseal-key" {
  capabilities = ["update"]
}

vault policy write unseal policy.hcl
vault policy list
vault policy read unseal
vault token create -policy=unseal - you get token from here
```

Now, go to your vault cluster which needs to be unsealed

```
vault status
sudo vim /etc/vault/vault.hcl 

seal "transit" {
  address: "https://192.168.56.100:8200",
  token ="use above token from transit engine",
  disable_renewal = "true",
  key_name = "unseal-key",
  mount_path = "transit"
}

sudo system restart vault

vault status
vault operator init
vault status - vault would have unsealed

vault login <token>

vault secrets list

```

### pros and cons of unsealing

**pros:**

**key shards:**
- simplest form of unsealing
- works on any platform 
- config options make it flexible

**auto unseal:**
- automatic unsealing
- set and forget
- integration benefits for running on same platform

**transit unseal:**
- automatic unsealing
- set and forget
- platform agnostic
- useful when runing many vault clusters across clouds/data centres


**Cons:**

**key shards:**

- introduces risk of storing keys
- requires manual intervention
- require rotation manually

**auto unseal:**

- regional requirements for cloud HSM
- cloud/vendor lockin

**transit unseal:**

- requires centralized vault cluster
- since centralized vault cluster need highest level of uptime.

## vault initialization

- initilization vault prepares the backend storage to receive data
- only need to initialize one time via single node
- vault init is when vault creates the master key and key shares
- options to defined threshold, key shares, receovery keys and encryption
- vault init is also where the intitial root token is generated and returned to user

### vault configs

- vault written in HCL or JSOn
- config file is specified(/etc/vault/vault.hcl) when starting vault using the`--config` flag

```
vault server -config <localtion>
```

[vault config documentation](https://developer.hashicorp.com/vault/docs/configuration)

example config file 

```
storage "consul" {
  address = "127.0.0.1:8500"
  path    = "vault/"
  token   = "1a2b3c4d-1234-abdc-1234-1a2b3c4d5e6a"
}
listener "tcp" {
 address = "0.0.0.0:8200"
 cluster_address = "0.0.0.0:8201"
 tls_disable = 0
 tls_cert_file = "/etc/vault.d/client.pem"
 tls_key_file = "/etc/vault.d/cert.key"
 tls_disable_client_certs = "true"
}
seal "awskms" {
  region = "us-east-1"
  kms_key_id = "12345678-abcd-1234-abcd-123456789101",
  endpoint = "example.kms.us-east-1.vpce.amazonaws.com"
}
reporting { #only for Vault 1.14 and up
    license {
        enabled = false
   }
}
api_addr = "https://vault-us-east-1.example.com:8200"
cluster_addr = " https://node-a-us-east-1.example.com:8201"
cluster_name = "vault-prod-us-east-1"
ui = false
log_level = "INFO"
license_path = "/opt/vault/vault.hcl"
disable_mlock=true
```

## storage backends

- configures location for storage of vault data
- enterprice vault cluster use "Hashicorp Consul" or "integrated storage" 

There is only 1 storage backend / cluster

## audit devices

- keep detailed log of all autenticated req and resp to vault
- audit log is in JSON
- sensitive info is hashed 
- log files shoud be protected as a user permission can still check the values of those secrets via /sts/audit-hash API and compare to the log file

```
vault audit enable file file_path=/var/log/vault_audit_log.log
```

- Can and should have more than one audit device enabled
- if there are any sudit devices enabled, vault requires that it can write to the log before completing the client request
- if vault cannot write to a persistent log, it will stop responding to client requests - which mean its down !


## vault interfaces

- 3 interfaces interact with vault: UI, CLI, HTTP
- CLI is just a wrapper and all CLI or UI underneath uses HTTP
- Auth is required to access any of the interfaces.






