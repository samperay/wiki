## access logs

what we could determine from the nginx access logs ..

- ip address of the requester
- date and time
- type of request (GET, POST, PUT ..etc)
- path to which request was asked
- response of the request 
- browser name from which request was sent.

logger file from the config goes below 

```
log_format main "" ... 
```

## configure custom logs


vim /etc/nginx/conf.d/virualhost.conf
```
access_log /var/log/nginx/example.log main;
```

ls /var/log/nginx/example.log would have your log in the defined format.

## logging


**logging levels**

no custom error logs can be configured

emerg, alert, crit, error, warn, notice, info, debug 

```
vim /etc/nginx/conf.d/nginx.conf

error_log /var/log/nginx.log emerg
error_log /var/log/example.log crit
error_log /var/log/domain_info.log info
```

