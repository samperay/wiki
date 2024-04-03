## Overview

When the data is transferred from the server to client, if there is more data, then we would have more packets transferred after calculating the MTU size. 

So if there is compression from the server, then we would have less packats to reach to the client. 
This is called as compressing.

**Client**

After the handshake, the client requests(GET /) from the server, in which the client would have an header set to the server i.e `Accept-Encoding: gzip, deflate, compress` 

**Server**

Server already knows about the data header, so it knows that the client can decode so while it sends the data back to the client it would use a header `Content-Encoding: gzip, defalte, compress` . 

Once the data is received to client, it would use its `gzip, defalte, compress` decoder to decode the data. 
There by, you would have less number of packets between **server-client**

**Note:**

- When client has not set any header, which means it would accept all types of decoding mechanism
- although, the server sends data back to the client in compressed way, the `Context-Type: text/plain` always remains plain text.

## configure

```
vim /etc/nginx/conf.d/nginx.conf
http { 
    <snip>
    gzip on;
    gzip_types text/plain text/css test/xml text/javascript;
    gzip_disable "MSIE [1-6]\.*;
    gzip_comp_level 9;
}

service nginx restart
```

**testing**

```
curl http://<your-web-server>/<somefile> > c1.txt
curl -H "Accept-Encoding:gzip" http://<your-web-server>/<somefile> > c2.txt

ls -l *.txt
```

Check their sizes, you would have found differences.

## referer

When there is the need for your context images not be copied due to copyrights or etc, you can configure the referer field so that imags don't get loaded. 

**Usecase**

When you like someone's website or blog, you tend to copy and write on your own, so in that case you can restrict your nginx server as to not to load any websites/url's accessing from it..

```
vim /etc/nginx/conf.d/nginx

server {
    location ~ \.(jpe?g|png|gif)$ {
        valid_referes none blocked servera.com *.serverb.com;
        if ($invalid_referer) {
            return 403;
        }
    }
}

system restart nginx
```

## accept-language 

Client can send the request in the preferred lanuguare by setting the header, so that we could get the resopinse in they way browser is set to.

```
curl -H "Accept-Language: en" <your-webserver.com/index.html>
curl -H "Accept-Language: jp" <your-webserver.com/index.html>
```





