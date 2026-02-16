## Linux security checklist

- Keep the system Updated with Latest Security Patches
- Keep Yourself updated with latest vulnerabilities through mailing lists, forums etc.
- Disable and stop unwanted services on the server
- Use SUDO to limit ROOT Access
- SSH security settings
- Check the integrity of critical files using checksum
- Tunnel all of your X-Window Sessions through SSH
- Use SeLinux If required.
- Only create required no of users
- Maintain a good firewall policy
- Configure SSL/TLS if you are using FTP
- check file permissions accross filesystems.
- Use tools like adeos for potential file state
- Ensure sticky bit on /tmp Directory
- check and lock users with blank passwords.
- Bootloader and BIOS security
- Give special attention to portmap related services
- Deploy your NFS shares with Kerberos Authentication.
- Enable remote Logging
- Disable root Logins by editing /etc/securetty
- Keep A good Pasword Policy


# Setup self signed certificate on EC2. 

Create Ec2 instance with public ip installed with nginx server by default. Now, when you run public ip it would default to "http".. make SG to allow 80, 443 and 22. 
we wil generate self signed certificate and load the nginx server so that only https would be re-directed. 

Install nginx server after logging to ec2 machine.

```
sudo yum update -y
sudo yum install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
```

curl http://<public-ip>

**Generate Self-Signed Certificate**

```
sudo mkdir /etc/nginx/ssl
cd /etc/nginx/ssl
sudo openssl genrsa -out private.key 2048
sudo openssl req -new -x509 -key private.key -out certificate.crt -days 365

Common Name (CN): <public_ip>
.
.
.

```

This would have generated `private.key` and `certificate.crt` . Configure the nginx to load tls certs. 

```
sudo vi /etc/nginx/conf.d/ssl.conf

server {
    listen 443 ssl;
    server_name <public-ip>;

    ssl_certificate /etc/nginx/ssl/certificate.crt;
    ssl_certificate_key /etc/nginx/ssl/private.key;

    location / {
        root /usr/share/nginx/html;
        index index.html;
    }
}

sudo nginx -t
sudo systemctl restart nginx

```

https://<public_ip>, you can see that connection is not private.. click Advance and proceed as its self-signed not signed by CA so browser is complaining.



```
    Client (Browser)
        |
        |  HTTPS Request
        v
EC2 + Nginx Server
        |
        |-- Sends Certificate
        |
Self-Signed Certificate
        |
         Signed by Itself

```

Verify certificate from cli

```
openssl s_client -connect <public_ip>:443 
Verify return code: 18 (self signed certificate)
```

# Build Internal PKI

**Build a secure internal architecture where:**

- You create your own Root CA
- You create an Intermediate CA
- You sign server certificates
- You enable HTTPS
- You enable mTLS between services
- You troubleshoot certificate issues


```
                   Your Laptop
                        |
                        | HTTPS
                        v
                EC2-1 (Web Server)
                        |
                        | mTLS
                        v
                EC2-2 (Internal API)
                        |
                        |
                Signed by Intermediate CA
                        |
                        |
                   Root CA (Offline)
```

**Setup**

Create 2 EC2 machines (t2.micro)

EC2-1 → Public facing web server

sg-1
Allow 22 (SSH)
Allow 443 (HTTPS)

sg-2
EC2-2 → Private internal API

Allow 22 (SSH)
Allow 8443 (Custom HTTPS)
Allow inbound only from EC2-1 sg1


                        Internet
                            |
                            |
                    +----------------+
                    |  Internet GW   |
                    +----------------+
                            |
                     -------------------
                     |                 |
              Public Subnet       Private Subnet
              (10.0.1.0/24)      (10.0.2.0/24)
                     |                 |
               +-------------+   +-------------+
               |   EC2-1     |   |   EC2-2     |
               | Web Server  |-->| Internal API|
               | Public IP   |   | No Public IP|
               +-------------+   +-------------+
                     |
              Security Group 1
              Allow:
                22 (SSH)
                443 (HTTPS)

                                  Security Group 2
                                  Allow:
                                  22 (SSH)
                                  8443 (HTTPS)
                                  Source = EC2-1 only



**Create Enterprise-Style PKI**

```
Root CA (offline)
        |
Intermediate CA
        |
Server Certificates
```