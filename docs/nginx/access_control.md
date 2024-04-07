## whitelisting

you can allow traffic reahing to your web server by configuring in the nginx server, so that only those requests are sent to the webserver. 

```
vim /etc/nginx/conf.d/whilelist.conf    
allow 192.168.56.101
deny all

vim /etc/nginx/conf.g/nginx.conf 
server {
    server_name localhost.com

    location /var/www/html/webroot
    index admin.html
    include /etc/nginx/conf.d/whilelist.conf  
}

nginx -t
systemctl restart nginx

curl -I localhost.com/admin 
```
## limit connections

let's say you have a network speed of 100Mpbs, so if there are 10 users who need to download, the person who has the highest bandwidth speed would choke up the server and others won't be able to download the file. Hence we need to make sure we set the limits for downloaing.. this can be done using the module `limit_rate`

```
vim /etc/nginx/conf.g/nginx.conf 
server {
    server_name localhost.com;

    location /download;
    limit_rate 50k;

nginx -t 
systemctl restart nginx
}
```


Now, in the above usecase you have set the limits for the speed, but if we have same ip connecting to same server multiple times, we have resources being unnecesary choked up by web server.. so we need to restrict the connections by using the module 


```
vim /etc/nginx/conf.g/nginx.conf

#global config section

limit_conn_zone $binary_remote_addr zone=addr:10m;

where, 
binary_remote_addr - remote client
speed at which the remote client uses 10m

server {
    server_name localhost.com;

    location /download
    limit_rate 50k;
    limit_conn addr 1;

where, 

for the download directior, the `addr` module can have only 1 conection.

nginx -t 
systemctl restart nginx
}
```

## basic auth

There are 3 types of auth. `basic`, `digest` and `NTML`. Client would send an `GET /admin` to the webserver, who would then sees that the page is configured to have an `basic` auth sent and would respond to the client with `401`, meaning authorization required by setting header `WWW-Authenticate: Basic retain=Family` in which you see a dialog prompt asking for `username` and `password`. Once you have entered credentials, the browser would `encode` the packet with the header response to the server, where it `decodes` and then retrives the page and then sends back response to the client. 

**Configuration**

Install `apache2-utils`

sudo htpasswd -c /etc/nginx/.htpasswd user1
sudo htpasswd -c /etc/nginx/.htpasswd user2

```
vim /etc/nginx/conf.g/nginx.conf

http {
    server {
        listen 192.168.1.23:8080;
        root   /usr/share/nginx/html;

        location /api {
            api;
            satisfy all;

            deny  192.168.1.2;
            allow 192.168.1.1/24;
            allow 127.0.0.1;
            deny  all;

            auth_basic           "Administrator’s Area";
            auth_basic_user_file /etc/apache2/.htpasswd;
        }
    }
}
```

## hashing

Hashing is a technique for converting data into a fixed-size value, called a hash value or hash code. The hash value is typically used to index a data structure such as a hash table. Hashing functions are designed to be fast and efficient, and to produce a uniform distribution of hash values for a given set of input data.

- Data storage
- Data security
- Cryptography

**different hashing algorithms**

- MD5 128-bit hash value
- SHA-1  160-bit hash value.
- SHA-2

## digest authentication 

Digest authentication is a method used for authenticating users in network communication protocols, particularly in the context of web servers and clients. It's an improvement over the more basic HTTP Basic Authentication, providing stronger security by avoiding sending passwords in plaintext over the network.

**how it works**

When a client (typically a web browser) sends a request to a server that requires authentication, the server responds with a special HTTP 401 Unauthorized status code, along with a challenge in the form of a nonce (a random string of characters), and possibly other parameters. 

Upon receiving the 401 response, the client knows it needs to provide authentication. It prompts the user for their username and password, just like with HTTP Basic Authentication.

Instead of sending the password directly, the client computes a cryptographic hash function (often MD5 or SHA-1) of various pieces of information, including the username, password, and nonce received from the server. This hash is called a **digest**.

The client sends this digest along with the username and other required information to the server in another request.

The server, upon receiving the authentication information, recalculates the digest using the same algorithm and compares it with the one sent by the client. If they match, the server can authenticate the user.

Digest authentication offers several advantages over Basic Authentication:

**Security**: Passwords are not sent in plaintext over the network, making it less susceptible to eavesdropping attacks.

**Nonce**: The use of a nonce makes replay attacks difficult, as each nonce is valid only for a single authentication attempt.

**Flexibility**: Digest authentication can be integrated with existing authentication mechanisms and is compatible with proxies and caching.

**Note:** nginx doesn't support dynamic authentic
