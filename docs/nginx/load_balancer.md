## Overview

LB: create set of multiple servers to distribute the traffic betweeen servers

**advantages of LB**

- traffic distribution using multiple algorithms to backend servers
- health check of backend application
- supprts SSL/TLS terminations

## implementation

### load balancing

**upstream**

upstream block can be used to specfiy the group of serves for which you want to load balanced traffic 

**nginx server**

```
[root@centos conf.d]# cat proxy.conf.backend
server {
    listen       80;
    server_name  localhost;

    location / {
        proxy_pass http://192.168.56.11;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header Host-Header $host;
    }

    location /admin {
        proxy_pass http://192.168.56.12;
        proxy_set_header X-Real-IP $remote_addr;
      }
}
[root@centos conf.d]#
```

just hitting the nginx load balancer, it would be redirected to two of the backend servers.

```
[root@centos conf.d]# curl 192.168.56.11
This is application server backend
[root@centos conf.d]# curl 192.168.56.12
this is backend server
[root@centos conf.d]#
[root@centos conf.d]# for i in `seq 1 7`
> do
> curl http://192.168.56.10
> done
this is backend server
This is application server backend
this is backend server
This is application server backend
this is backend server
This is application server backend
this is backend server
[root@centos conf.d]#
```

### health checks

health checks are used to monitor the health of HTTP servers in upstream group i.e `backend` 
if any server is not responding then nginx will stop sending the request to it. 

let's say one of the backend server has stopped so nginx would route to the healthy node. 

```
[root@centos html]# systemctl stop nginx
[root@centos html]# systemctl status nginx
● nginx.service - nginx - high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
   Active: inactive (dead) since Fri 2024-03-29 07:49:31 UTC; 5s ago
     Docs: http://nginx.org/en/docs/
  Process: 20660 ExecStop=/bin/sh -c /bin/kill -s TERM $(/bin/cat /var/run/nginx.pid) (code=exited, status=0/SUCCESS)
  Process: 607 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf (code=exited, status=0/SUCCESS)
 Main PID: 614 (code=exited, status=0/SUCCESS)

Mar 27 12:36:31 centos systemd[1]: Starting nginx - hig...
Mar 27 12:36:32 centos systemd[1]: Can't open PID file ...
Mar 27 12:36:32 centos systemd[1]: Started nginx - high...
Mar 29 07:49:31 centos systemd[1]: Stopping nginx - hig...
Mar 29 07:49:31 centos systemd[1]: Stopped nginx - high...
Hint: Some lines were ellipsized, use -l to show in full.
[root@centos html]#

```

**load balancer server**

```
[root@centos conf.d]# curl http://192.168.56.12
curl: (7) Failed connect to 192.168.56.12:80; Connection refused
[root@centos conf.d]#
```

since one of the server is down, nginx load balancer would route the entry to healthy node itself. 
this is as part of **passive health checks**

```
[root@centos conf.d]# for i in `seq 1 7`; do curl http://192.168.56.10; done
This is application server backend
This is application server backend
This is application server backend
This is application server backend
This is application server backend
This is application server backend
This is application server backend
[root@centos conf.d]#
```

One the node is up, traffic is routed across.

```
[root@centos html]# systemctl start nginx
[root@centos html]# systemctl status nginx
● nginx.service - nginx - high performance web server
   Loaded: loaded (/usr/lib/systemd/system/nginx.service; enabled; vendor preset: disabled)
   Active: active (running) since Fri 2024-03-29 07:52:10 UTC; 13s ago
     Docs: http://nginx.org/en/docs/
  Process: 20660 ExecStop=/bin/sh -c /bin/kill -s TERM $(/bin/cat /var/run/nginx.pid) (code=exited, status=0/SUCCESS)
  Process: 20673 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx.conf (code=exited, status=0/SUCCESS)
 Main PID: 20674 (nginx)
   CGroup: /system.slice/nginx.service
           ├─20674 nginx: master process /usr/sbin/ngin...
           └─20675 nginx: worker process

Mar 29 07:52:10 centos systemd[1]: Starting nginx - hig...
Mar 29 07:52:10 centos systemd[1]: Can't open PID file ...
Mar 29 07:52:10 centos systemd[1]: Started nginx - high...
Hint: Some lines were ellipsized, use -l to show in full.
[root@centos html]#
```

```
[root@centos conf.d]# for i in `seq 1 7`; do curl http://192.168.56.10; done
This is application server backend
This is application server backend
this is backend server
This is application server backend
this is backend server
This is application server backend
this is backend server
[root@centos conf.d]#
```

#### active and passive

**active** - only available in nginx plus, which is paid. In this check, the health check of an upstream server by sending special health check requests(GET /) to each server and check for the response. 

if there are any response of 2xx or 3xx then its considered and unhealthy and marked accordingly.

**passive** - nginx monitors the communication between client and the upstream server. 
if upstream server is not responding or rejecting connections, the passive health check with consider the serevr unhealthy and marked accordingly. 

#### passive healthcheck parameters

you can configure passive checks in the nginx configs.. 

max_fails - set the number of failed attempts that must occur during the fail_timeout period for the server to be marked unavailable.

fail_timeout - set the time during which number of failed attempts must happen for the server to be marked unavailable and also the time for which the server is marked unavailable.


```
[root@centos conf.d]# cat load-balancer.conf
upstream backend {
  server 192.168.56.11 max_fails=2 fail_timeout=30s;
  server 192.168.56.12 max_fails=2 fail_timeout=30s;
}

server {
    listen       80;
    server_name  localhost;

    location / {
        proxy_pass http://backend;
 }
}
[root@centos conf.d]#systemctl restart nginx
```

until the 30s for 2 attemps, nginx won't send any requests to that server.. you can configure it accordingly. 
you can use the tool called 'ab' which is `httpd-tools` to send multiple requests to nginx. 

```
ab -n 1000 localhost/ # send 1000 requests to the nginx proxy.
```

#### server weights

allows us to customizd the request flow betwen nginx acting as LB to the upstream backends...
you can send 80% of traffic to one server and 20% to another server. 

```
upstream backend {
  server 192.168.56.11;
  server 192.168.56.12 weight=2;
}
```


