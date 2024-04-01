## Overview

### Benefits

- it reduces the overhead of server's resource.
- decreases the network bankwidth.
- pages are loaded much more faster.

## caching subsystems

### caching control(headers)

these are used to speificy directives for caching mechanism, they are used to defined caching policies with various directives provided by the header. you would specify whether you need your web page to be cached or not to be cached by using these headers..

use cases..

- do not store any kind of cache at all 
- store the cache, but verify with webserver wheather file is modified
- store the cache for 24 hours

varipus cache control headers

- Cache-Control: no-store
- Cache-Control: no-cache
- Cache-Control: no-store, must-revalidate
- Cache-Control: public
- Cache-Control: private

Configure all your .png files don't need your browser to store cache.

```
server {
    listen       80;
    server_name  localhost;

    location / {
        root   /usr/share/nginx/html;
        index  index.html index.htm;
    }

    location ~ \.(.png) {
       root   /usr/share/nginx/html;
       add_header Cache-Control no-store;    
    }

}

systemctl nginx restart
```

From your client cli, reqeust the .png, when you check the response, you would see the cache header as response.

```
curl -I http://your-web-server/myseed.png
```

### if modified header

when you request for the webpage by client, the nginx would first give an GET request to the server and check's for the timestamp header (Last-Modified) and if there's no response it would be 302 message to the client saying there is no change in the webpage and hence it can serve from the cache server. 

incase if ther's change, it would serve a new request to cache and then to the client.

### cache control header

The amount of time the webpage needs to be in the cache.

```
location ~ \.(.png) {
    root   /usr/share/nginx/html;
    expires 1h;    
}
```

```
curl -I http://your-web-server/myseed.png
```

### cache: no-store, must-revalidate


### cache: max-age, s-max-age


### cache time 


### expires headers


### keep-alive connections


### date-time expires
