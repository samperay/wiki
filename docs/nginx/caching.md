## Overview

### Benifits 

- it reduces the overhead of server's resource.
- decreases the network bankwidth.
- pages are loaded much more faster.

## cache control header

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