## Nginx architecture

**Configuration file:** /etc/nginx/nginx.conf

**User:** nginx

**Log:** /var/log/nginx

**rpm:** nginx-1.20.1-1.el7.ngx.x86_64.rpm

**OS:** CentOS7

```
[root@centos ~]# ps -ef | grep nginx | grep -v grep
root       623     1  0 Mar26 ?        00:00:00 nginx: master process /usr/sbin/nginx
nginx      627   623  0 Mar26 ?        00:00:00 nginx: worker process
[root@centos ~]#
```

**master process**
read and evaluate config file and maintain worker process. worker process can be 1 or more.

**worker process**
they do the actual processing.

`worker_processes` in the nginx config file, it would auto detect the number of CPU and then will launch the worker process accordingly. you have `error_log` and `pid` in the config file which is self explanatory. 

we can also include other modules instead of any modification in the main file. 
`include /usr/share/nginx/modules/*.conf;`. To read more, please check the configuration file.

`worker_connections` sets max number of simultaneous connections that can be opened by a worker process. 

## contexts

nginx config file is divided across rage of contexts(sections)
each context contains its own set of directives to control specific aspect of nginx ., i.e 

Any directive that exists entirely outside of the context is said to inhabit  the "main" context
Main context is used to configure details that effect the entire application on a basic level
- main
- events
- http
- mail


```
cat /etc/nginx/nginx.conf
<snip>
events {
    worker_connections 1024;
}

http {
    log_format  main
}
<snip>
```
### http

contails all of the directives and other contexts necessary to define how to handle HTTP/HTTPS connections and associated parameters.

```
http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    #tcp_nopush     on;

    keepalive_timeout  65;

    #gzip  on;

    include /etc/nginx/conf.d/*.conf;
}
```

### custom config

You can create your custom config file using below file. you can change the `location` to your desired one for youe pplciation. 

```
[root@centos conf.d]# pwd
/etc/nginx/conf.d
[root@centos conf.d]# cat default.conf  | grep -v '#'
server {
    listen       80;
    server_name  localhost;
    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm; 
    }
    error_page   500 502 503 504  /50x.html;
    location = /50x.html {
        root   /usr/share/nginx/html;
    }
}
```

### Configure multiple websites or domains

```
[root@centos conf.d]# cat /etc/nginx/conf.d/dexter.conf
server {
    listen       8080;
    server_name  localhost;

    access_log  /var/log/nginx/dexter.access.log  main;

    location / {
        root   /usr/share/nginx/html/dexter;
        index  index.html;
    }
}
[root@centos conf.d]# systemctl restart nginx
[root@centos conf.d]# curl http://192.168.56.10:8080/index.html
this is an multiple site configured at nginx for domain dexter
[root@centos conf.d]#


[root@centos conf.d]# ls /var/log/nginx/dexter.access.log
/var/log/nginx/dexter.access.log
[root@centos conf.d]# cat /var/log/nginx/dexter.access.log
192.168.56.1 - - [27/Mar/2024:10:45:26 +0000] "GET /index.html HTTP/1.1" 200 63 "-" "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36" "-"
192.168.56.10 - - [27/Mar/2024:10:45:40 +0000] "GET /index.html HTTP/1.1" 200 63 "-" "curl/7.29.0" "-"
192.168.56.10 - - [27/Mar/2024:10:46:27 +0000] "GET /index.html HTTP/1.1" 200 63 "-" "curl/7.29.0" "-"
[root@centos conf.d]#
```

## nginx cli

```
nginx -v # version
nginx -V # more detail
nginx -t # check syntax
nginx -c new_nginx.conf # testing purpose
nginx -h # help menu
```


## modular architecture

referes to any system composed of seperate componets that can be connected together i.e its a collection of modules, we can also extend the functionality by adding 3rd party modules.

### static modules

- Modules that are compiled into nginx server binary at compile time
- Single package, portable and works out of box
- Creates issue when one of the module has bug, hence difficult to troubleshoot

### dynamic modules

- Create/download dynamic module files.
- Reference the path of the module with the `load_module` directive.

### install using source module

```
http://nginx.org/en/download.html

wget http://nginx.org/download/nginx-1.16.0.tar.gz
tar -xzvf nginx-1.16.0.tar.gz
yum -y install gcc make zlib-devel pcre-devel openssl-devel wget nano

./configure --prefix=/usr/share/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --http-client-body-temp-path=/var/lib/nginx/tmp/client_body --pid-path=/var/run/nginx.pid --lock-path=/var/lock/subsys/nginx --user=nginx --group=nginx --with-http_mp4_module --add-module=../nginx-hello-world-module

useradd Nginx
mkdir -p /var/lib/nginx/tmp/
chown -R nginx.nginx /var/lib/nginx/tmp/

SystemD file

https://www.nginx.com/resources/wiki/start/topics/examples/systemd/
```

### build dynamic module

```
yum -y install git
git clone https://github.com/perusio/nginx-hello-world-module
./configure --add-dynamic-module=../nginx-hello-world-module

vim /etc/nginx/conf.d/nginx.conf
load_module /etc/nginx/modules/something.so # it should be in global section

server {
    listen 8080;

    location = /test {
        hello_world;
    }
}

curl -i http://example.com/test #this will be loaded from the dynamic module
```

Reference: https://github.com/perusio/nginx-hello-world-module


### build static module

You don't have to use `load_module` directive, its same as the src compilation but you would add the static compile method `--add-module` as referenced here https://github.com/perusio/nginx-hello-world-module

```
./configure --prefix=/usr/share/nginx --sbin-path=/usr/sbin/nginx --modules-path=/usr/lib64/nginx/modules --conf-path=/etc/nginx/nginx.conf --error-log-path=/var/log/nginx/error.log --http-log-path=/var/log/nginx/access.log --http-client-body-temp-path=/var/lib/nginx/tmp/client_body --pid-path=/var/run/nginx.pid --lock-path=/var/lock/subsys/nginx --user=nginx --group=nginx --with-http_mp4_module --add-module=../nginx-hello-world-module

make
make install


server {
listen 8080;
 
location / {
     hello_world;
  }
}


systemctl restart nginx
curl localhost:8080
```

### web application firewall(waf)

A Web Application Firewall (WAF) is a security solution designed to protect web applications by monitoring, filtering, and potentially blocking HTTP traffic between a web application and the Internet. WAFs are deployed to provide an additional layer of defense, thereby protecting against data breaches, unauthorized access, and service disruption

- SQL Injection (SQLi)
- Cross-Site Scripting (XSS)
- Cross-Site Request Forgery (CSRF)
- File Inclusion
- Directory Traversal
- Brute Force Attacks
- Denial-of-Service (DoS) 
- Distributed Denial-of-Service(DDoS)

**Signature-based Detection:** WAFs use predefined signatures or patterns to identify known attacks and malicious traffic.

**Behavioral Analysis:** Some advanced WAFs employ machine learning or heuristic algorithms to analyze traffic patterns and detect anomalies indicative of attack attempts.

**Request Inspection:** WAFs inspect HTTP requests and responses, analyzing parameters, headers, payloads, and other attributes to identify suspicious activity.

**Traffic Filtering:** WAFs can filter and block traffic based on predefined rules, such as IP addresses, user agents, request methods, or payloads.

**Protocol Validation:** WAFs validate incoming requests against known HTTP standards and application-specific protocols to detect and block malformed or malicious requests.

**Logging and Reporting:** WAFs provide logs and reports detailing detected threats, blocked requests, and other security events for analysis and investigation.

