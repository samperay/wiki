# Compenents for system design architecting

## Load Balancing

### Working principle 

Load balancers work by distributing incoming network traffic across multiple servers or resources to ensure efficient utilization of computing resources and prevent overload. Here are the general steps that a load balancer follows to distribute traffic:

The load balancer receives a request from a client or user.
The load balancer evaluates the incoming request and determines which server or resource should handle the request. This is done based on a predefined load-balancing algorithm that takes into account factors such as server capacity, server response time, number of active connections, and geographic location.

The load balancer forwards the incoming traffic to the selected server or resource.
The server or resource processes the request and sends a response back to the load balancer.
The load balancer receives the response from the server or resource and sends it to the client or user who made the request.

![simple_lb](./images/simple_lb.png)

Typically a load balancer sits between the **client and the server accepting incoming network and application traffic and distributing the traffic** across multiple backend servers using various algorithms. By balancing application requests across multiple servers, a **load balancer reduces the load** on individual servers and prevents any **one server from becoming a single point of failure**, thus improving overall application availability and responsiveness.

To utilize **full scalability and redundancy**, we can try to balance the load at each layer of the system. We can add LBs at three places:

Between the user and the web server
Between web servers and an internal platform layer, like application servers or cache servers
Between internal platform layer and database.

![internal_lb](./images/internal_lb.png)

### Key terminology and concepts

Load Balancer: A device or software that distributes network traffic across multiple servers based on predefined rules or algorithms.

Backend Servers: The servers that receive and process requests forwarded by the load balancer. Also referred to as the server pool or server farm.

Load Balancing Algorithm: The method used by the load balancer to determine how to distribute incoming traffic among the backend servers.

Health Checks: Periodic tests performed by the load balancer to determine the availability and performance of backend servers. Unhealthy servers are removed from the server pool until they recover.

Session Persistence: A technique used to ensure that subsequent requests from the same client are directed to the same backend server, maintaining session state and providing a consistent user experience.

SSL/TLS Termination: The process of decrypting SSL/TLS-encrypted traffic at the load balancer level, offloading the decryption burden from backend servers and allowing for centralized SSL/TLS management.

### Misc terms

#### Availability & Realibility
availability is about whether a system is "up," while reliability is about whether it "works correctly" once it’s up

A Car: If you have a car in your driveway ready to drive, it is available. However, if that car stalls every time you hit 60 mph, it is unreliable.
A Website: A site that loads but gives you an error every time you click "Checkout" has high availability (it's online) but low reliability (it fails to perform its function).

#### Upstream and Downstream
The exact meaning depends on the point of reference in the architecture
e.g 

```User requests → Load Balancer → App Server → Database```

**Upstream** = Traffic **going OUT(moving away)** from your system to another system/service. 
**Downstream** = Traffic **coming INTO(coming into)** your system from another system/service.

From the App Server’s perspective:

Downstream → User requests / Load Balancer (requests coming in)
Upstream → Database (requests going out)

From the Load Balancer perspective:

Downstream -> User requests
upstream -> App server(backend servers) 

### DNS Load Balancing and High Availability

DNS load balancing and high availability techniques, such as round-robin DNS, geographically distributed servers, anycast routing, and Content Delivery Networks (CDNs), help distribute the load among multiple servers, reduce latency for end-users, and maintain uninterrupted service, even in the face of server failures or network outages.

#### RR DNS

Round-robin DNS is a simple load balancing technique in which multiple IP addresses are associated with a single domain name. When a resolver queries the domain name, the DNS server responds with one of the available IP addresses, rotating through them in a round-robin fashion. This distributes the load among multiple servers or resources, improving the performance and availability of the website or service.

However, **round-robin DNS does not take into account the actual load** on each server or the geographic location of the client, which can lead to uneven load distribution or increased latency in some cases.

#### Geographically distributed DNS servers

By distributing DNS servers across different regions, they can provide faster and more reliable DNS resolution for users located closer to a server.

Geographically distributed servers also offer increased redundancy, reducing the impact of server failures or network outages. If one server becomes unreachable, users can still access the service through other available servers in different locations.

#### Anycast routing

Anycast routing is a networking technique that allows multiple servers to share the same IP address. When a resolver sends a query to an anycast IP address, the network routes the query to the nearest server, based on factors like network latency and server availability.

Anycast provides several benefits for DNS:

Load balancing: Anycast distributes DNS queries among multiple servers, preventing any single server from becoming a bottleneck.
Reduced latency: By directing users to the nearest server, anycast can significantly reduce the time it takes for DNS resolution.
High availability: If a server fails or becomes unreachable, anycast automatically redirects queries to the next closest server, ensuring uninterrupted service.

#### CDN && DNS

A Content Delivery Network (CDN) is a network of distributed servers that cache and deliver web content to users based on their geographic location. CDNs help improve the performance, reliability, and security of websites and web services by distributing the load among multiple servers and serving content from the server closest to the user.

When a user requests content from a website using a CDN, the CDN's DNS server determines the best server to deliver the content based on the user's location and other factors. The DNS server then responds with the IP address of the chosen server, allowing the user to access the content quickly and efficiently.