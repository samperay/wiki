## Nginx architecture

**Configuration file:** /etc/nginx/nginx.conf
**User:** nginx
**Log:** /var/log/nginx

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
    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main; 

    sendfile            on;
    tcp_nopush          on;
    tcp_nodelay         on;
    keepalive_timeout   65;
    types_hash_max_size 4096;

    include             /etc/nginx/mime.types;
    default_type        application/octet-stream;

    include /etc/nginx/conf.d/*.conf;
}
```

### test config file

```
nginx -v
nginx -V # more detail
nginx -t # check syntax
nginx -c new_nginx.conf # testing purpose
nginx -h
```


