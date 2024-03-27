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
