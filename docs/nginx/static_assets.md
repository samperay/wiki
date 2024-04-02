when we make a request from client, it would query the nginx server and then contact the upstream server to get the response to the client. so when we want to load the index.html, all the static content has to be served from the upstream server(.png, .js, .css..etc) to get the response. 

Incase if we have configured **static content to be served from the nginx reverse proxy**, then only index.html would be loaded from the upstream server, there by providing better response time, performance on the upstream would be better.

try to load the application and check for the nginx access logs, you can find many of the GET requests to upstream server to server the static content

## configure

```
vim /etc/nginx/conf.d/proxy.conf

server {
    server_name yourweb.in

    location / {
        proxy_pass http://192.168.56.10;
        proxy_set_header Host $host;
    }

    # configue your static assets to load from the nginx reverse proxy

    location ~* \.(css|js|jp?g|JPG|png|PNG) {
        root /var/www/assets;
        try_files $uri $uri/;
    }
    
}
ngix -t
systemctl restart nginx
```

on your application server, 

```
scp -r /var/www/html/js <nginxsverer>@:/var/www/assets/
scp -r /var/www/html/css <nginxsverer>@:/var/www/assets/
scp -r /var/www/html/master <nginxsverer>@:/var/www/assets/
```

open your application /var/log/nginx/access.log and try to load the webpage , you could see the minimization of the GET requests from the upstream server.

