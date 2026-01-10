# Load Balancing

- Spread load across multiple downstream instances 
- Expose a single point of access (DNS) to your application 
- Seamlessly handle failures of downstream instances 
- Do regular health checks to your instances 
- Provide SSL termination (HTTPS) for your websites 
- Enforce stickiness with cookies • High availability across zones 
- Separate public traffic from private traffic

## ELB

- managed load balancer
  - AWS guarantees that it will be working
  - AWS takes care of upgrades, maintenance, high availability
  - AWS provides only a few configuration knobs
- integrated with many AWS offerings / services
   -  EC2, EC2 Auto Scaling Groups, Amazon ECS
   -  AWS Certificate Manager (ACM), CloudWatch
   -  Route 53, AWS WAF, AWS Global Accelerator
- health checks
   - load balancer to know if instances it forwards traffic to are available to reply to requests
   - health check is done on a port and a route (/health is common)
   - response is not 200 (OK), then the instance is unhealthy

## types of load balancers

**Classic Load Balancer**
- HTTP, HTTPS, TCP, SSL (secure TCP)

**Application Load Balancer**
- HTTP, HTTPS, WebSocket
- Operates at layer 7(Appliation layer)
- Routing tables to different target groups:
  - Routing based on path in URL (example.com/users & example.com/posts)
  - Routing based on hostname in URL (one.example.com & other.example.com)
  - Routing based on Query String, Headers
-  ALB are a great fit for micro services & container-based application
-  Target Groups:
   -  EC2 instances (can be managed by an Auto Scaling Group)- HTTP
   -  ECS tasks (managed by ECS itself) – HTTP
   -  Lambda functions – HTTP request is translated into a JSON event
   - ALB can route to multiple target groups
   - Health checks are at the target group level
 - Fixed hostname
 - The application servers don’t see the IP of the client directly 
   - The true IP of the client is inserted in the header X-Forwarded-For
   - We can also get Port (X-Forwarded-Port) and proto (X-Forwarded-Proto)

**Network Load Balancer**
- TCP, TLS (secure TCP), UDP
- Operates at layer 4(Network layer)

**Gateway Load Balancer**
- Operates at layer 3 (Network layer) – IP Protocol

# userdata

```
#!/bin/bash
# Use this for your user data (script from top to bottom)
# install httpd (Linux 2 version)
yum update -y
yum install -y httpd
systemctl start httpd
systemctl enable httpd
echo "<h1>Hello World from $(hostname -f)</h1>" > /var/www/html/index.html
```

## lab: ec2 load balancer 

registered target groups

![registered_tg](./images/registered_tg.png)

![health_checks](./images/health_checks.png)