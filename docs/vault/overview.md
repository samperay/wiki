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


**References:**

- https://hashicorp.com/certification/vault-associate
- https://learn.hashicorp.com/tutorials/vault/associate-study
- https://vaultproject.io/docs
- https://vaultproject.io/api-docs