## asymmetric cryptography

Asymmetric public-key encryption, often referred to as asymmetric cryptography or public-key cryptography, is a cryptographic system that uses pairs of keys: public keys and private keys. Unlike symmetric encryption, where the same key is used for both encryption and decryption, asymmetric encryption uses different keys for these operations.

Each user generates a pair of keys: **a public key and a private key**, The public key is made available to anyone who wishes to send an encrypted message to the user. The private key is kept secret and known only to the user.

**Encryption**

- When User A wants to send a secure message to User B, User A uses User B's public key to encrypt the message.
- The encryption process uses complex mathematical algorithms that are easy to perform in one direction (using the public key) but computationally difficult to reverse without the corresponding private key.

**Decryption**

- User B receives the encrypted message and uses their private key to decrypt it.
- Since the private key is kept secret, only User B can decrypt the message.

Because of its advantages that it offers, it can be used in variery of protocols like PGP, SSH, Bitcoin, TLS, S/MIME

## https

### handshake

- When a user's browser initiates a connection to a website over HTTPS, a process called the SSL/TLS handshake begins.
- The browser requests a secure connection to the server, and the server responds by sending its SSL/TLS certificate to the browser.
- The certificate contains the server's public key and information about the website, including the domain name and the certificate authority (CA) that issued the certificate.
- The browser verifies the certificate to ensure it's valid and trusted. This verification involves checking the certificate's digital signature against a list of trusted CAs stored in the browser, ensuring the certificate hasn't expired, and confirming that the domain name matches the one the user is trying to connect to.

### key exchange

- After verifying the certificate, the browser generates a session key, which is a randomly generated symmetric encryption key.
- The browser encrypts the session key with the server's public key from the certificate and sends it to the server.
- The server decrypts the session key using its private key, establishing a secure connection.

### data transfer

- Once the secure connection is established, data transferred between the browser and the server is encrypted using symmetric encryption with the session key.
- This encryption ensures that even if an attacker intercepts the data, they won't be able to decipher it without the session key.

## install certs

```
yum install certbot-nginx
certbot --nginx -d yourdomain.com 

# configure your configurations
# will add ssl_certs in the nginx.conf..

nginx -t 
systemctl restart nginx
```

## certs revokcations

### CRL

Certificate Revocation List(CRL) is a method used by CAs to maintain a list of revoked digital certificates.

**working**

- The CA periodically publishes a CRL, which contains the serial numbers of all certificates that have been - revoked before their expiration date.
- When a user wants to verify the validity of a certificate, they can check the CRL to see if the certificate's serial number is listed as revoked.
- CRLs are typically distributed and accessed via HTTP, LDAP, or other protocols.

**drawbacks**

- CRLs can become large and cumbersome to manage, especially for CAs with a large number of certificates.
- There can be delays between when a certificate is revoked and when it appears on the CRL, leaving a window of vulnerability.
- Frequent downloads of large CRLs can lead to network congestion and performance issues.

### OCSP

Online Certificate Status Protocol(OCSP) provides a real-time method for checking the status of a digital certificate.

**working**

- When a user wants to verify a certificate, their system sends a request to the CA's OCSP responder, providing  the certificate's serial number.
- The OCSP responder checks its records to see if the certificate is still valid or has been revoked.
- The responder then sends a response back to the user's system indicating the current status of the certificate (e.g., valid, revoked, unknown).
- OCSP provides real-time validation, reducing the window of vulnerability compared to CRLs.
- It can be more efficient than downloading and parsing large CRLs, especially for individual certificate checks.

**drawbacks**

- OCSP requests can introduce additional latency into the certificate validation process, especially if the OCSP responder is slow to respond.
- OCSP relies on the availability and reliability of the CA's OCSP responder. If the responder is unavailable, validation may fail.
- OCSP requests can also leak information about which certificates a user is accessing, potentially compromising privacy.


