# Hands-on private PKI lab

A private certificate chain built on one Ubuntu VM and trusted from a Mac. The chain is Root CA, then Intermediate CA, then a server certificate for `192.168.56.10`. Nginx serves it on port 443.

Public websites use this same shape. Their root is already in the browser. This root exists only where we installed it.

## Passport picture

| Piece | Name in this lab | Role |
| --- | --- | --- |
| Root CA | Hands-on PKI Lab Root CA | National passport authority. Browsers keep this in their trust book. |
| Intermediate CA | Hands-on PKI Lab Intermediate CA | Regional office. The root licensed it. It stamps server passports. `pathlen:0` means it cannot open another office. |
| Server certificate | `CN=192.168.56.10` | This machine's passport. `CA:FALSE`, so it cannot stamp other certificates. |
| Private key | `root-ca.key`, `intermediate-ca.key`, `server.key` | The stamp. It stays on the VM. |
| CSR | `intermediate-ca.csr`, `server.csr` | The application. It carries the public key and the requested name. |
| SAN | IPs and DNS names on the server certificate | The list of names the passport covers. Chrome and curl check this list. |
| `fullchain.crt` | Server certificate, then intermediate | The two papers handed to the visitor. The root is not in this file. |
| Trust store | VM `/etc/ssl/certs`, Mac System keychain | The book of authorities that visitor already believes. |

Checking walks up: server passport, regional license, national office. The national office has to already be in the visitor's book.

## Machines

| Machine | Address | Role |
| --- | --- | --- |
| Ubuntu VM, interface `enp0s9` | `192.168.56.10/24` | Lab server. Host-only address used by the Mac. |
| Ubuntu VM, interface `enp0s8` | `10.0.2.15/24` | NAT address. Also listed on the certificate. Not used from the Mac. |
| Mac | `192.168.56.1/24` | Client. Ping, curl, and Safari reach the VM. |

Ports:

| Port | Service |
| --- | --- |
| 80 | Existing plain HTTP site. Also used to hand out the public root file. |
| 443 | HTTPS for this lab. |
| 9443 | Second HTTPS listener configured with the same certificate. |

## Files

All paths are under `~/pki-lab` on the VM.

```text
root-ca/root-ca.key              root private key, mode 600
root-ca/root-ca.crt              root certificate
intermediate-ca/intermediate-ca.key
intermediate-ca/intermediate-ca.csr
intermediate-ca/intermediate.ext
intermediate-ca/intermediate-ca.crt
server/server.key                server private key, 2048-bit
server/server.csr
server/server.ext
server/server.crt
server/fullchain.crt             server certificate, then intermediate
nginx-pki-lab.conf
```

Nginx site enabled at `/etc/nginx/sites-available/pki-lab`.

The root installed for the VM trust store:

```text
/usr/local/share/ca-certificates/hands-on-pki-lab-root.crt
```

That file must be mode `644`. The private keys stay mode `600`.

## 1. Root CA

The root signs its own certificate. Subject and issuer are the same name.

```bash
mkdir -p ~/pki-lab/root-ca
cd ~/pki-lab
umask 077
openssl genrsa -out root-ca/root-ca.key 4096

openssl req -x509 -new \
  -key root-ca/root-ca.key \
  -sha256 -days 3650 \
  -out root-ca/root-ca.crt \
  -subj "/C=IN/O=Hands-on PKI Lab/CN=Hands-on PKI Lab Root CA" \
  -addext "basicConstraints=critical,CA:TRUE" \
  -addext "keyUsage=critical,keyCertSign,cRLSign" \
  -addext "subjectKeyIdentifier=hash"
```

Result:

```text
subject = issuer = Hands-on PKI Lab Root CA
notBefore = Nov 22 13:49:53 2026 GMT
notAfter  = Nov 19 13:49:53 2036 GMT
CA:TRUE
Key Usage: Certificate Sign, CRL Sign
Subject Key Identifier = Authority Key Identifier
  BA:17:B2:D3:02:AA:D6:42:B8:09:FE:46:9A:1E:F7:04:31:E8:74:AF
```

`umask 077` made both files mode `600`. That is correct for the private key. It later blocked the trust-store copy of the certificate. See the trust section below.

## 2. Intermediate CA

The intermediate has its own key. The CSR is only the application. The root grants the powers in `intermediate.ext` at signing time.

```bash
mkdir -p intermediate-ca
openssl genrsa -out intermediate-ca/intermediate-ca.key 4096

openssl req -new \
  -key intermediate-ca/intermediate-ca.key \
  -out intermediate-ca/intermediate-ca.csr \
  -subj "/C=IN/O=Hands-on PKI Lab/CN=Hands-on PKI Lab Intermediate CA"

cat > intermediate-ca/intermediate.ext <<'EOF'
basicConstraints=critical,CA:TRUE,pathlen:0
keyUsage=critical,keyCertSign,cRLSign
extendedKeyUsage=serverAuth
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
EOF

openssl x509 -req \
  -in intermediate-ca/intermediate-ca.csr \
  -CA root-ca/root-ca.crt \
  -CAkey root-ca/root-ca.key \
  -CAcreateserial \
  -out intermediate-ca/intermediate-ca.crt \
  -days 1825 -sha256 \
  -extfile intermediate-ca/intermediate.ext

openssl verify -CAfile root-ca/root-ca.crt intermediate-ca/intermediate-ca.crt
```

Result: `intermediate-ca.crt: OK`

```text
subject: Hands-on PKI Lab Intermediate CA
issuer:  Hands-on PKI Lab Root CA
notAfter: Nov 21 14:08:21 2031 GMT
CA:TRUE, pathlen:0
Extended Key Usage: TLS Web Server Authentication
Subject Key Identifier:   1A:EC:49:4B:F6:08:B4:75:29:44:7E:33:5E:33:E6:C9:56:46:0A:F0
Authority Key Identifier: BA:17:B2:D3:02:AA:D6:42:B8:09:FE:46:9A:1E:F7:04:31:E8:74:AF
```

The authority key id matches the root. The subject key id is the intermediate's own key.

## 3. Server certificate

The intermediate signs this certificate. The root key is not used here. Names that clients accept are written in `server.ext`.

```bash
mkdir -p server
openssl genrsa -out server/server.key 2048

openssl req -new \
  -key server/server.key \
  -out server/server.csr \
  -subj "/C=IN/O=Hands-on PKI Lab/CN=192.168.56.10"

cat > server/server.ext <<'EOF'
basicConstraints=critical,CA:FALSE
keyUsage=critical,digitalSignature,keyEncipherment
extendedKeyUsage=serverAuth
subjectKeyIdentifier=hash
authorityKeyIdentifier=keyid,issuer
subjectAltName=IP:192.168.56.10,IP:10.0.2.15,IP:127.0.0.1,DNS:localhost,DNS:ubuntu,DNS:pki.lab
EOF

openssl x509 -req \
  -in server/server.csr \
  -CA intermediate-ca/intermediate-ca.crt \
  -CAkey intermediate-ca/intermediate-ca.key \
  -CAcreateserial \
  -out server/server.crt \
  -days 825 -sha256 \
  -extfile server/server.ext

openssl verify \
  -CAfile root-ca/root-ca.crt \
  -untrusted intermediate-ca/intermediate-ca.crt \
  server/server.crt
```

Result: `server/server.crt: OK`

```text
subject: CN=192.168.56.10
issuer:  Hands-on PKI Lab Intermediate CA
notAfter: Feb 24 14:18:10 2029 GMT
CA:FALSE
Key Usage: Digital Signature, Key Encipherment
Extended Key Usage: TLS Web Server Authentication
Authority Key Identifier: 1A:EC:49:4B:F6:08:B4:75:29:44:7E:33:5E:33:E6:C9:56:46:0A:F0
SAN: IP 192.168.56.10, IP 10.0.2.15, IP 127.0.0.1,
     DNS localhost, DNS ubuntu, DNS pki.lab
```

The authority key id matches the intermediate.

## 4. Chain file

The visitor receives two certificates. The server certificate is first. The intermediate is second. The root stays out of the bundle.

```bash
cat server/server.crt intermediate-ca/intermediate-ca.crt > server/fullchain.crt
```

Confirmed contents:

```text
subject CN=192.168.56.10
  issuer Intermediate CA
subject Intermediate CA
  issuer Root CA
```

Verification with only the root fails, because the regional license is missing:

```text
openssl verify -CAfile root-ca/root-ca.crt server/server.crt
error 20: unable to get local issuer certificate
```

The same check succeeds when the intermediate is supplied with `-untrusted`.

## 5. Nginx

```nginx
server {
    listen 443 ssl;
    listen 9443 ssl;
    server_name _;

    ssl_certificate     /home/ubuntu/pki-lab/server/fullchain.crt;
    ssl_certificate_key /home/ubuntu/pki-lab/server/server.key;
    ssl_protocols TLSv1.2 TLSv1.3;

    location / {
        default_type text/plain;
        return 200 "The building showed its passport.\n";
    }
}
```

```bash
sudo cp nginx-pki-lab.conf /etc/nginx/sites-available/pki-lab
sudo ln -sfn /etc/nginx/sites-available/pki-lab /etc/nginx/sites-enabled/pki-lab
sudo nginx -t
sudo systemctl reload nginx
```

`openssl s_client` to `192.168.56.10:443` showed both certificates. Before the root was trusted, the result was `Verify return code: 20`. Curl with `--cacert root-ca/root-ca.crt` returned the page on port 443 and on port 9443.

Curl also succeeded with `--cacert intermediate-ca/intermediate-ca.crt`. The intermediate is a CA, and it signed the server certificate, so naming it as the trusted office is enough for that one command. The permanent trust store received the root, and the intermediate continues to travel in `fullchain.crt`.

## 6. Trust on the VM

```bash
sudo cp root-ca/root-ca.crt /usr/local/share/ca-certificates/hands-on-pki-lab-root.crt
sudo chmod 644 /usr/local/share/ca-certificates/hands-on-pki-lab-root.crt
sudo update-ca-certificates
```

The first copy was mode `600` because `umask 077` was still set and `cp` kept that mode. Curl reads `/etc/ssl/certs/ca-certificates.crt`, which root was able to build, so curl succeeded. `openssl s_client` reads the hash link in `/etc/ssl/certs` and could not open the mode `600` file, so it still reported error 20. `chmod 644` and a second `update-ca-certificates` fixed that.

After the fix:

```text
echo | openssl s_client -connect 192.168.56.10:443 -verify_ip 192.168.56.10
Verify return code: 0 (ok)
```

`s_client` prints that line more than once. It is one result.

## 7. Trust on the Mac

The Mac's host-only address is `192.168.56.1`. Ping to `192.168.56.10` succeeds, three replies, no loss.

The root was added to the System keychain and is marked trusted for all users. It expires 19 November 2036. Keychain Access shows it under **System → Certificates** as **Hands-on PKI Lab Root CA**.

A double-click import earlier failed with error **-25294** (the item already existed, and the certificate list being viewed did not show it). The working install is the System keychain entry.

Curl from the Mac:

```text
curl -vk --max-time 5 https://192.168.56.10/
Connected to 192.168.56.10 port 443
TLSv1.3 / AEAD-AES256-GCM-SHA384
subject: CN=192.168.56.10
issuer: Hands-on PKI Lab Intermediate CA
SSL certificate verify ok.
HTTP/1.1 200 OK
The building showed its passport.
```

Safari loads the same page. Wi-Fi proxy settings on the Mac are all off.

Chrome was left for later. An early Chrome attempt reported `ERR_ADDRESS_UNREACHABLE` before the host-only route was confirmed. After the route and the System keychain trust were in place, curl and Safari succeeded. Chrome was not rechecked after that.

## Commands used to read a certificate

```bash
openssl x509 -in root-ca/root-ca.crt -noout \
  -subject -issuer -dates \
  -ext basicConstraints,keyUsage,subjectKeyIdentifier,authorityKeyIdentifier

openssl x509 -in root-ca/root-ca.crt -noout -fingerprint -sha256
```

## Troubleshooting

Each scenario below happened in this lab, or it is the check we used while the lab was running. Run the commands from `~/pki-lab` on the VM unless the step says Mac.

### How to read a failure

Three different layers fail in three different ways.

| Layer | What is broken | What the error looks like |
| --- | --- | --- |
| Chain | A certificate in the path is missing or was signed by the wrong key | `unable to get local issuer certificate`, verify code 20 |
| Name | The chain is trusted, and the address you typed is not on the passport | `no alternative certificate subject name matches` |
| Network | The client never reaches port 443 | `ERR_ADDRESS_UNREACHABLE`, `Connection refused`, ping fails |

A certificate warning means the TCP connection succeeded. "Site can't be reached" means the certificate was never examined.

### 1. Verify fails when the intermediate is left out

Symptom:

```text
openssl verify -CAfile root-ca/root-ca.crt server/server.crt
C = IN, O = Hands-on PKI Lab, CN = 192.168.56.10
error 20 at 0 depth lookup: unable to get local issuer certificate
error server/server.crt: verification failed
```

The server passport names the intermediate as its issuer. The command was given only the root, so the checker cannot climb.

Look at who signed whom:

```bash
openssl x509 -in server/server.crt -noout -subject -issuer
openssl x509 -in intermediate-ca/intermediate-ca.crt -noout -subject -issuer
openssl crl2pkcs7 -nocrl -certfile server/fullchain.crt | openssl pkcs7 -print_certs -noout
```

The working check supplies the regional license without treating it as the trusted office:

```bash
openssl verify \
  -CAfile root-ca/root-ca.crt \
  -untrusted intermediate-ca/intermediate-ca.crt \
  server/server.crt
```

Expected: `server/server.crt: OK`

Also confirm the key ids link. The server certificate's Authority Key Identifier must equal the intermediate's Subject Key Identifier (`1A:EC:49:4B:…`). The intermediate's Authority Key Identifier must equal the root's Subject Key Identifier (`BA:17:B2:D3:…`).

```bash
openssl x509 -in server/server.crt -noout -ext authorityKeyIdentifier
openssl x509 -in intermediate-ca/intermediate-ca.crt -noout -ext subjectKeyIdentifier,authorityKeyIdentifier
openssl x509 -in root-ca/root-ca.crt -noout -ext subjectKeyIdentifier
```

`fullchain.crt` must list the server certificate first and the intermediate second. Nginx sends that file. The root stays out of it.

### 2. s_client shows the chain and still returns code 20

Symptom, before the root is in the VM trust store:

```text
 0 s:CN = 192.168.56.10
   i:CN = Hands-on PKI Lab Intermediate CA
 1 s:CN = Hands-on PKI Lab Intermediate CA
   i:CN = Hands-on PKI Lab Root CA
Verify return code: 20 (unable to get local issuer certificate)
```

The same line can appear three times. `s_client` prints it more than once. It is one result.

The two certificates were delivered. The VM's book does not yet contain the root.

One-shot proof that the chain itself is valid:

```bash
curl --cacert root-ca/root-ca.crt https://192.168.56.10/
```

Expected body: `The building showed its passport.`

Install the root, then test again with no `--cacert`:

```bash
sudo cp root-ca/root-ca.crt /usr/local/share/ca-certificates/hands-on-pki-lab-root.crt
sudo chmod 644 /usr/local/share/ca-certificates/hands-on-pki-lab-root.crt
sudo update-ca-certificates
curl https://192.168.56.10/
```

`update-ca-certificates` should report `1 added` the first time.

### 3. Curl succeeds after install, and s_client still returns code 20

This is the failure we hit after `update-ca-certificates`.

Curl:

```text
curl https://192.168.56.10:9443/
The building showed its passport.
```

s_client at the same time:

```text
Verify return code: 20 (unable to get local issuer certificate)
```

Curl and `s_client` read the trust book differently.

- Curl reads `/etc/ssl/certs/ca-certificates.crt`. Root built that file, so curl can read it.
- `s_client` follows the hash link in `/etc/ssl/certs`. That link points at the certificate we copied into `/usr/local/share/ca-certificates/`. `umask 077` was still set, `cp` kept mode `600`, and the user running `s_client` cannot open the file.

Check:

```bash
ls -l root-ca/root-ca.crt
ls -l /usr/local/share/ca-certificates/hands-on-pki-lab-root.crt
HASH=$(openssl x509 -in root-ca/root-ca.crt -noout -subject_hash)
ls -l /etc/ssl/certs/${HASH}.0 /etc/ssl/certs/hands-on-pki-lab-root.pem
head -1 /usr/local/share/ca-certificates/hands-on-pki-lab-root.crt
```

The failure looks like:

```text
-rw------- root-ca.crt
-rw------- /usr/local/share/ca-certificates/hands-on-pki-lab-root.crt
ac72d4c4.0 -> hands-on-pki-lab-root.pem
head: cannot open '.../hands-on-pki-lab-root.crt' for reading: Permission denied
```

`ac72d4c4` is the hash of this root's subject name. A new root with the same name keeps that hash and a different fingerprint.

Confirm curl's ledger already has the certificate, which is why curl passed:

```bash
echo | openssl s_client -connect 192.168.56.10:443 \
  -CAfile /etc/ssl/certs/ca-certificates.crt \
  -verify_ip 192.168.56.10 2>/dev/null | awk '/Verify return code/'
```

Expected with the ledger: `Verify return code: 0 (ok)`

Fix the file the hash link opens. The private key stays `600`. Only the public certificate in the trust directory changes.

```bash
sudo chmod 644 /usr/local/share/ca-certificates/hands-on-pki-lab-root.crt
sudo update-ca-certificates
echo | openssl s_client -connect 192.168.56.10:443 \
  -verify_ip 192.168.56.10 2>/dev/null | awk '/Verify return code/'
```

Expected: `Verify return code: 0 (ok)`

### 4. Trusting the intermediate also makes curl succeed

We ran:

```bash
curl --cacert intermediate-ca/intermediate-ca.crt https://localhost:9443
```

It returned the page. `--cacert` replaces the trust book for that one command. The intermediate has `CA:TRUE` and it signed the server certificate, so the climb ends at the regional office.

The installed trust anchor for the lab is still the root. Check which file is in the system store:

```bash
ls -l /usr/local/share/ca-certificates/hands-on-pki-lab-root.crt
openssl x509 -in /usr/local/share/ca-certificates/hands-on-pki-lab-root.crt -noout -subject
```

Expected subject: `Hands-on PKI Lab Root CA`

### 5. HTTPS pointed at the HTTP port

Port 80 on this VM speaks plain HTTP. Asking it for TLS produces:

```text
curl: (35) error:0A00010B:SSL routines::wrong version number
```

Check which ports are listening:

```bash
ss -tln | grep -E ':443|:80 '
curl --max-time 5 https://192.168.56.10/
curl --max-time 5 http://192.168.56.10/
```

Use `https://192.168.56.10/` for port 443. Use `http://` for port 80.

### 6. The name in the address bar is not on the passport

A trusted chain still fails when the typed name is absent from the SAN:

```text
SSL: no alternative certificate subject name matches target host name
```

Read the list:

```bash
openssl x509 -in server/server.crt -noout -ext subjectAltName
```

This passport lists `IP:192.168.56.10`, `IP:10.0.2.15`, `IP:127.0.0.1`, `DNS:localhost`, `DNS:ubuntu`, and `DNS:pki.lab`. An IP has to be an `IP:` entry. `https://pki.lab/` also needs `192.168.56.10 pki.lab` in the client's hosts file.

### 7. The Mac cannot reach the VM

Chrome showed:

```text
This site can't be reached
https://192.168.56.10/ is unreachable.
ERR_ADDRESS_UNREACHABLE
```

That page appears before TLS. The certificate is not involved.

On the VM, confirm the address and the door:

```bash
ip -4 addr
ss -tln | grep -E ':443|:80 '
curl --max-time 5 https://192.168.56.10/
```

We saw `enp0s9` as `192.168.56.10/24`, port 443 listening on `0.0.0.0:443`, and curl printing the passport line.

On the Mac:

```bash
ifconfig | grep -A 3 "192.168.56"
ping -c 3 192.168.56.10
nc -vz 192.168.56.10 443
```

The working result was Mac address `192.168.56.1`, netmask `255.255.255.0`, and three ping replies. `nc` should report the port open.

`10.0.2.15` is the VM's NAT address. The Mac uses `192.168.56.10`. The VirtualBox host-only adapter has to be up, with the VM on `vboxnet0` and the Mac interface in `192.168.56.0/24`.

### 8. Mac Keychain import error -25294

Double-clicking the root certificate showed:

```text
An error occurred. Unable to import "Hands-on PKI Lab Root CA".
Error: -25294
```

**-25294** means the item is already in a keychain. The Login certificate list was empty when we looked. The System list at first showed only `com.apple.kerberos.kdc` and `com.apple.systemdefault`.

Find it from the Mac, not the VM:

```bash
openssl x509 -in ~/Downloads/hands-on-pki-lab-root.crt -noout -subject -fingerprint -sha256
security find-certificate -a -c "Hands-on PKI Lab"
sudo security find-certificate -a -c "Hands-on PKI Lab" /Library/Keychains/System.keychain
```

Compare that fingerprint with the VM:

```bash
openssl x509 -in ~/pki-lab/root-ca/root-ca.crt -noout -fingerprint -sha256
```

The two fingerprints must match. A certificate with the same name and a different fingerprint is an older root.

Put this root in the System keychain, which Safari and curl on the Mac both used successfully:

```bash
sudo security delete-certificate -c "Hands-on PKI Lab Root CA" /Library/Keychains/System.keychain
sudo security add-trusted-cert -d -r trustRoot \
  -k /Library/Keychains/System.keychain \
  ~/Downloads/hands-on-pki-lab-root.crt
```

The delete command may say the certificate was not found. Run the add command after it.

Keychain Access, **System → Certificates**, should then show **Hands-on PKI Lab Root CA**, expiring 19 November 2036, with "This certificate is marked as trusted for all users."

If `openssl x509` on the Mac cannot read the downloaded file, copy it again:

```bash
scp ubuntu@192.168.56.10:/home/ubuntu/pki-lab/root-ca/root-ca.crt ~/Downloads/hands-on-pki-lab-root.crt
```

### 9. Safari and curl work, Chrome does not

Curl from the Mac already completed the visit:

```text
* Connected to 192.168.56.10 (192.168.56.10) port 443
* SSL connection using TLSv1.3 / AEAD-AES256-GCM-SHA384
* subject: CN=192.168.56.10
* issuer: CN=Hands-on PKI Lab Intermediate CA
* SSL certificate verify ok.
< HTTP/1.1 200 OK
The building showed its passport.
```

Safari showed the page. The Wi-Fi network `bluebird5` had every proxy switch off: Auto proxy discovery, Automatic proxy configuration, Web proxy, Secure web proxy, and SOCKS proxy.

So a Chrome failure at that point is inside Chrome.

| Chrome text | Meaning | What to do |
| --- | --- | --- |
| `ERR_ADDRESS_UNREACHABLE` | Chrome never opened TCP 443 | Quit Chrome with Cmd+Q and retry. Try an Incognito window so extensions are off. Check Settings, System, for a proxy. |
| `NET::ERR_CERT_AUTHORITY_INVALID` or "Your connection is not private" | TCP worked and Chrome does not trust this root | Confirm the root is under System, trusted for all users, and the fingerprint matches the VM. Cmd+Q Chrome and open it again. |
| The passport sentence | Done | Padlock path: Root CA, Intermediate CA, `192.168.56.10`. |

Chrome was not rechecked after the System keychain trust and the successful Mac curl.

### Quick checks

```bash
# VM: who is listening, and does local HTTPS succeed?
ip -4 addr
ss -tln | grep -E ':443|:80 '
curl --max-time 5 https://192.168.56.10/

# VM: chain and names
openssl verify -CAfile root-ca/root-ca.crt -untrusted intermediate-ca/intermediate-ca.crt server/server.crt
openssl x509 -in server/server.crt -noout -ext subjectAltName
openssl s_client -connect 192.168.56.10:443 -verify_ip 192.168.56.10 </dev/null 2>/dev/null | awk '/Verify return code/'

# VM: trust file is readable
ls -l /usr/local/share/ca-certificates/hands-on-pki-lab-root.crt

# Mac: route, port, and trust
ping -c 3 192.168.56.10
nc -vz 192.168.56.10 443
curl -vk --max-time 5 https://192.168.56.10/
```

## What this lab is for

The root private key can sign a certificate for any name. Every machine that trusts this root will accept it. Keep `root-ca.key` on this lab VM. Rebuilding the root creates a new authority with the same name. The old root must be removed from the Mac System keychain, and the new file installed, before clients will trust the new chain.
