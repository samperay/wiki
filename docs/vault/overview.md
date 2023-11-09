Manage Secrets and Protect Sensitive Data and provides a Single Source of Secrets for both Humans and Machines

**Secret**

- Anything your organization deems sensitive:
- Usernames and passwords
- API keys
- Certificates
- Encryption Keys

**Lifecycle Management for Secrets**

- Eliminates secret sprawl
- Securely store any secret
- Provide governance for access to secrets

Vault has mainly 3 ways you can interact, **CLI, UI and API**

As a human, you would authenticate to vault server with credentials(**username/password | roleid | secretid| tls certs | cloud creds.**.etc), which gives you an **generated token **to carry out certain taks that you need for like (**read/write/delete//list**) to perform some actions(**writing to path or reading from path**) on the applications with certain time limit(TTL).

When we want to retrive the data from path, we would proivde the token generated from auth and vault would validate the below tokens

1. token provided is correct/valid
2. token is not expired
3. token has permission

Once above are successful, you would be retrived the data from th path.

## Benefits

- Store Long-Lived, Static Secrets
- Dynamically Generate Secrets, upon Request
- Fully-Featured API
- Identity-based Access Across different Clouds and Systems
- Provide Encryption as a Service(secret engine)
- Act as a Root or Intermediate Certificate Authority 

## Usecases

- Centralize The Storage Of Secrets  
    - Chef 
    - Jenkins 
    - AWS secrets
    - Azure key

- Migrate to Dynamically Generated Secrets 
    - short-lived
    - follows principle of least priv 
    - auotmatically revoked
    - each system can retrive unique creds
    - prog retrived
    - no human interactions

- Secure Data with a centralized workflow for Encryption Operations (secret engine)
    - transit
    - KMIP
    - Key mgmt
    - transform
  
- Automate the Generation of X.509 Certificates ( can work like PKI)
you would provide an Certificate Request, in which valut would sign and provide the certtficate and key returned

- Migrate to IdentityBased Access

    - Quickly Scale Up and Down
    - Reduce/Eliminate Ticket-based Access
    - Increase Time to Value
  
## Installations

- Install vault
- Create Configuration file 
- Initialize vault 
- Unseal vault

## vault dev server features

- Quickly run Vault without configuration
- Automatically initialized and unsealed
- Enables the UI – available at localhost
- Provides an Unseal Key
- AutomaBcally logs in as root
- Non-Persistent – Runs in memory
- Insecure – doesn’t use TLS 
- Sets the listener to 127.0.0.1:8200
- Mounts a K/V v2 Secret Engine
- Provides a root token

Why do we need to use vault dev ?

- POC
- New dev integrations
- testing new vault features
- experiment new features

### Start the vault dev server

```
vault server -dev
```

Open another terminal and set the env vars

```
➜  ~ export VAULT_ADDR='http://127.0.0.1:8200'
➜  ~ vault status
Key             Value
---             -----
Seal Type       shamir
Initialized     true
Sealed          false
Total Shares    1
Threshold       1
Version         1.15.1
Build Date      2023-10-20T19:16:11Z
Storage Type    inmem
Cluster Name    vault-cluster-49bd9ee3
Cluster ID      e5a97669-5d1d-386f-5eb3-a72d5b72f744
HA Enabled      false

➜  ~ vault kv put secret/vault/sunil sunil=sunil
```

Running Vault Server in Production

- Deploy one or more persistent nodes via configuration file
- Use a storage backend that meets the requirements
- Multiple Vault nodes will be configured as a cluster
- Deploy close to your applications
- Most likely, you’ll automate the provisioning of Vault

To start Vault, run the vault `server –config=<file>` command

- In a production environment, you'll have a service manager executing
and managing the Vault service (systemctl, Windows Service Manager,
etc.)

- For Linux, you also need a systemd file to manage the service for Vault
(and Consul if you're running Consul)

Step-by-Step manual install process for vault

- Download Vault from HashiCorp
- Unpackage Vault to a Directory
- Set Path to Executable
- Add ConfiguraBon File & Customize
- Create Systemd Service File
- Download Consul from HashiCorp
- Configure and Join Consul Cluster
- Launch Vault Service


**MacOS**

Download the vault server from below link..
https://releases.hashicorp.com/vault/1.15.1/





**References:**

- https://hashicorp.com/certification/vault-associate
- https://learn.hashicorp.com/tutorials/vault/associate-study
- https://vaultproject.io/docs
- https://vaultproject.io/api-docs