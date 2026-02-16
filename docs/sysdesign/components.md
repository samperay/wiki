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

## Load Balancing Algorithms

### RR

It assigns a request to the first server, then moves to the second, third, and so on .. 

Pros:

- equal distribution among servers.
- easy implementation and understand
- works well when server has similar capabilities

Cons:

- no load awareness: does not take into account the current load or capacity of each servers. all are treated equally regardless of their current state. 
- no sesstion affinity: prob for staeful servers as request may reach to other server. 
- performace issue with different capacities.
- Predictable Distribution Pattern: Round Robin is predictable in its request distribution pattern, which could potentially be exploited by attackers who can observe traffic patterns and might find vulnerabilities in specific servers by predicting which server will handle their requests.

**Good usecases**

Homogeneous Environments: Suitable for environments where all servers have similar capacity and performance.
Stateless Applications: Works well for stateless applications where each request can be handled independently.

### least connections

The Least Connections algorithm is a dynamic load balancing technique that assigns incoming requests to the server with the fewest active connections at the time of the request
useful especially in environments where traffic patterns are unpredictable and request processing times vary.

Pros:

- Load Awareness: Takes into account the current load on each server by considering the number of active connections, leading to better utilization of server resources.
- Dynamic Distribution: Adapts to changing traffic patterns and server loads, ensuring no single server becomes a bottleneck.
- Efficiency in Heterogeneous Environments: Performs well when servers have varying capacities and workloads, as it dynamically allocates requests to less busy servers.

Cons:

- Higher Complexity: More complex to implement compared to simpler algorithms like Round Robin, as it requires real-time monitoring of active connections.
- State Maintenance: Requires the load balancer to maintain the state of active connections, which can increase overhead.
- Potential for Connection Spikes: In scenarios where connection duration is short, servers can experience rapid spikes in connection counts, leading to frequent rebalancing.

Use Cases
- Heterogeneous Environments: Suitable for environments where servers have different capacities and workloads, and the load needs to be dynamically distributed.
- Variable Traffic Patterns: Works well for applications with unpredictable or highly variable traffic patterns, ensuring that no single server is overwhelmed.
- Stateful Applications: Effective for applications where maintaining session state is important, as it helps distribute active sessions more evenly.

### Weighted RR

It assigns weights to each server based on their capacity or performance, distributing incoming requests proportionally according to these weights. This ensures that more powerful servers handle a larger share of the load, while less powerful servers handle a smaller share.

Pros

- Load Distribution According to Capacity: Servers with higher capacities handle more requests, leading to better utilization of resources.
- Flexibility: Easily adjustable to accommodate changes in server capacities or additions of new servers.
- Improved Performance: Helps in optimizing overall system performance by preventing overloading of less powerful servers.

Cons

- Complexity in Weight Assignment: Determining appropriate weights for each server can be challenging and requires accurate performance metrics.
- Increased Overhead: Managing and updating weights can introduce additional overhead, especially in dynamic environments where server performance fluctuates.
- Not Ideal for Highly Variable Loads: In environments with highly variable load patterns, WRR may not always provide optimal load balancing as it doesn't consider real-time server load.

Use Cases
- Heterogeneous Server Environments: Ideal for environments where servers have different processing capabilities, ensuring efficient use of resources.
- Scalable Web Applications: Suitable for web applications where different servers may have varying performance characteristics.
- Database Clusters: Useful in database clusters where some nodes have higher processing power and can handle more queries.

### weighted least connections

combines the principles of the Least Connections and Weighted Round Robin algorithms. It takes into account both the current load (number of active connections) on each server and the relative capacity of each server (weight)

Pros
Dynamic Load Balancing: Adjusts to the real-time load on each server, ensuring a more balanced distribution of requests.
Capacity Awareness: Takes into account the relative capacity of each server, leading to better utilization of resources.
Flexibility: Can handle environments with heterogeneous servers and variable load patterns effectively.
Cons
Complexity: More complex to implement compared to simpler algorithms like Round Robin and Least Connections.
State Maintenance: Requires the load balancer to keep track of both active connections and server weights, increasing overhead.
Weight Assignment: Determining appropriate weights for each server can be challenging and requires accurate performance metrics.
Use Cases
Heterogeneous Server Environments: Ideal for environments where servers have different processing capacities and workloads.
High Traffic Web Applications: Suitable for web applications with variable traffic patterns, ensuring no single server becomes a bottleneck.
Database Clusters: Useful in database clusters where nodes have varying performance capabilities and query loads.

### IP Hash

The load balancer uses a hash function to convert the client's IP address into a hash value, which is then used to determine which server should handle the request. This method ensures that requests from the same client IP address are consistently routed to the same server, providing session persistence.

Pros
Session Persistence: Ensures that requests from the same client IP address are consistently routed to the same server, which is beneficial for stateful applications.
Simplicity: Easy to implement and does not require the load balancer to maintain the state of connections.
Deterministic: Predictable and consistent routing based on the client's IP address.
Cons
Uneven Distribution: If client IP addresses are not evenly distributed, some servers may receive more requests than others, leading to an uneven load.
Dynamic Changes: Adding or removing servers can disrupt the hash mapping, causing some clients to be routed to different servers.
Limited Flexibility: Does not take into account the current load or capacity of servers, which can lead to inefficiencies.
Use Cases
Stateful Applications: Ideal for applications where maintaining session persistence is important, such as online shopping carts or user sessions.
Geographically Distributed Clients: Useful when clients are distributed across different regions and consistent routing is required.

### least response time

TODO

## Usea of load balancing

### HA and Fault tolerance: 

A load balancer performs Health Checks. It acts as the heartbeat monitor for your cluster. It constantly pings your backend servers ("Are you alive? Can you take a request?"). If a server fails to answer or returns a 5xx error, the LB cuts it off instantly. It stops sending traffic to the corpse and reroutes it to the living.

### Horizontal Scalability

The LB acts as the Unified Entry Point (Virtual IP). Clients only know the LB's address. When traffic spikes, you spin up more backend instances, register them with the LB, and boom, you have more capacity.


### Blue/Green deployments

Load balancers allow for Connection Draining and strategies like Blue-Green Deployment. You can signal the LB to stop sending new connections to a specific server while allowing existing connections to finish naturally, then take it offline for patching.

### Shield

A Load Balancer acts as a **Reverse Proxy**. It terminates the connection. The client talks to the LB; the LB talks to the server. The internet never touches your backend. Furthermore, the LB can absorb DDoS attacks (Distributed Denial of Service) and filter malicious traffic before it even reaches your expensive application logic.

### SSL Termination (The "Offloader")

Encryption is expensive. Handshaking SSL/TLS (decrypting HTTPS traffic) takes significant CPU power. You can offload this to the Load Balancer. This is called **SSL Termination**. The client speaks HTTPS to the Load Balancer. The Load Balancer decrypts it and speaks HTTP (or lighter encryption) to your backend servers inside your secure private network.


### DNS Load Balancing and High Availability

DNS load balancing and high availability techniques, such as round-robin DNS, geographically distributed servers, anycast routing, and Content Delivery Networks (CDNs), help distribute the load among multiple servers, reduce latency for end-users, and maintain uninterrupted service, even in the face of server failures or network outages.

## LB types

### Hardware Load Balancing

They use specialized hardware components, such as Application-Specific Integrated Circuits (ASICs) or Field-Programmable Gate Arrays (FPGAs), to efficiently distribute network traffic

Use case: A large e-commerce company uses a hardware load balancer to distribute incoming web traffic among multiple web servers, ensuring fast response times and a smooth shopping experience for customers.

### Software Load Balancing

Software load balancers are applications that run on general-purpose servers or virtual machines. They use software algorithms to distribute incoming traffic among multiple servers or resources.

Use case: A startup with a growing user base deploys a software load balancer on a cloud-based virtual machine, distributing incoming requests among multiple application servers to handle increased traffic.

### Cloud-based Load Balancing

Cloud-based load balancers are provided as a service by cloud providers. They offer load balancing capabilities as part of their infrastructure, allowing users to easily distribute traffic among resources within the cloud environment.

Use case: A mobile app developer uses a cloud-based load balancer provided by their cloud provider to distribute incoming API requests among multiple backend servers, ensuring smooth app performance and quick response times.

### DNS Load Balancing

DNS (Domain Name System) load balancing relies on the DNS infrastructure to distribute incoming traffic among multiple servers or resources. It works by resolving a domain name to multiple IP addresses, effectively directing clients to different servers based on various policies.

Use case: A content delivery network (CDN) uses DNS load balancing to direct users to the closest edge server based on their geographical location, ensuring faster content delivery and reduced latency.

### Global Server Load Balancing 

GSLB is a technique used to distribute traffic across geographically dispersed data centers. It combines DNS load balancing with health checks and other advanced features to provide a more intelligent and efficient traffic distribution method.

Use case: A multinational corporation uses GSLB to distribute incoming requests for its web applications among several data centers around the world, ensuring high availability and optimal performance for users in different regions.

### Hybrid Load Balancing

Hybrid load balancing combines the features and capabilities of multiple load balancing techniques to achieve the best possible performance, scalability, and reliability. It typically involves a mix of hardware, software, and cloud-based solutions to provide the most effective and flexible load balancing strategy for a given scenario.

Use case: A large-scale online streaming platform uses a hybrid load balancing strategy, combining hardware load balancers in their data centers for high-performance traffic distribution, cloud-based load balancers for scalable content delivery, and DNS load balancing for global traffic management. This approach ensures optimal performance, scalability, and reliability for their millions of users worldwide.

### Layer 4 Load Balancing

Layer 4 load balancing, also known as transport layer load balancing, operates at the transport layer of the OSI model (the fourth layer). It distributes incoming traffic based on information from the TCP or UDP header, such as source and destination IP addresses and port numbers.

Use case: An online gaming platform uses Layer 4 load balancing to distribute game server traffic based on IP addresses and port numbers, ensuring that players are evenly distributed among available game servers for smooth gameplay.

### Layer 7 Load Balancing

Layer 7 load balancing, also known as application layer load balancing, operates at the application layer of the OSI model (the seventh layer). It takes into account application-specific information, such as HTTP headers, cookies, and URL paths, to make more informed decisions about how to distribute incoming traffic.

Use case: A web application with multiple microservices uses Layer 7 load balancing to route incoming API requests based on the URL path, ensuring that each microservice receives only the requests it is responsible for handling.


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

# Network essentials

Differences Between HTTP and HTTPS

## HTTP vs HTTPS Comparison

| Feature        | HTTP                                                   | HTTPS                                                   |
|----------------|--------------------------------------------------------|---------------------------------------------------------|
| **Security**   | No encryption; data is sent in plain text             | Encrypted using SSL/TLS protocols                        |
| **Port**       | 80                                                    | 443                                                      |
| **Performance**| Slightly faster due to lack of encryption overhead    | Slightly slower due to encryption processes              |
| **SEO Ranking**| Lower search engine ranking                           | Higher search engine ranking                             |
| **Use Cases**  | Non-sensitive data transmission                       | Sensitive transactions (e.g., banking, e-commerce)       |


## TCP vs UDP

these two of the main protocols used for transmitting data over the internet.


**TCP (Transmission Control Protocol)**

TCP is a connection-oriented protocol that ensures reliable, ordered, and error-checked delivery of a stream of bytes between applications.

**Characteristics**
- Reliability: TCP ensures that data is delivered accurately and in order, retransmitting lost or corrupted packets.
- Connection-Oriented: Establishes a connection between sender and receiver before transmitting data.
- Flow Control: Manages data transmission rate to prevent network congestion.
- Congestion Control: Adjusts the transmission rate based on network traffic conditions.
- Acknowledgements and Retransmissions: Uses acknowledgments to confirm receipt of data and retransmits if necessary.

e.g: Loading a webpage: TCP is used to ensure all web content is loaded correctly and in the right order.


**UDP(User Datagram Protocol)**

UDP is a connectionless protocol that sends messages, called **datagrams**, without establishing a prior connection and without guaranteeing reliability or order.

**Characteristics**
- Low Overhead: Does not establish a connection, leading to lower overhead and latency.
- Unreliable Delivery: Does not guarantee message delivery, order, or error checking.
- Speed: Faster than TCP due to its simplicity and lack of retransmission mechanisms.
- No Congestion Control: Does not reduce transmission rates under network congestion.

e.g: Streaming a live sports event: UDP is used for faster transmission, even if it means occasional pixelation or minor video artifacts.

**TCP vs UDP Comparison**

| Feature | TCP | UDP |
|----------|------|------|
| **Reliability** | Reliable transmission, ensuring data is delivered accurately and in order | Unreliable transmission; data may be lost or arrive out of order |
| **Connection** | Connection-oriented; establishes a connection before transmitting data | Connectionless; sends data without establishing a connection |
| **Speed and Overhead** | Slower due to handshaking, acknowledgments, and congestion control | Faster with minimal overhead, suitable for real-time applications |
| **Data Integrity** | High data integrity, suitable for applications like file transfers and web browsing | Lower data integrity, acceptable for applications like streaming where perfect accuracy is less critical |
| **Use Case Suitability** | Used when data accuracy is more critical than speed | Used when speed is more critical than accuracy |

# HTTP/1.0 vs HTTP/1.1 vs HTTP/2 vs HTTP/3

## 📌 Executive Summary

HTTP has evolved to improve:
- ⚡ Performance (faster loading)
- 🔐 Security (stronger encryption)
- 📡 Efficiency (better bandwidth usage)
- 🌍 Scalability (handling modern traffic)

Each version builds upon the previous one to address web scalability challenges.

---

# 🔎 High-Level Comparison

| Feature | HTTP/1.0 | HTTP/1.1 | HTTP/2 | HTTP/3 |
|----------|-----------|-----------|---------|---------|
| **Release Year** | 1996 | 1997 | 2015 | 2020 |
| **Connection Model** | New TCP connection per request | Persistent connections (Keep-Alive) | Multiplexed streams over single TCP connection | Multiplexed streams over QUIC (UDP) |
| **Protocol Format** | Text | Text | Binary | Binary |
| **Multiplexing** | ❌ No | ❌ No | ✅ Yes | ✅ Yes |
| **Header Compression** | ❌ No | ❌ Limited | ✅ HPACK | ✅ QPACK |
| **Head-of-Line Blocking** | Yes | Yes | Yes (TCP-level) | No |
| **Transport Protocol** | TCP | TCP | TCP | UDP (QUIC) |
| **Security** | Optional | Optional | Usually HTTPS | Mandatory TLS 1.3 |
| **Latency** | High | Medium | Low | Very Low |
| **Packet Loss Handling** | Poor | Poor | Better | Excellent |
| **Typical Use Case** | Static websites | Dynamic web apps | High-traffic apps | Real-time applications |

---

# 📚 Version-by-Version Summary

---

## 🚀 HTTP/1.0 (1996)

### Characteristics
- One request = one TCP connection
- Stateless
- Basic headers
- High latency

### Limitations
- Connection overhead
- Slow page loads
- Not suitable for modern resource-heavy websites

### Best Used For
- Simple static websites
- Early web applications

---

## 🚀 HTTP/1.1 (1997)

### Improvements Over 1.0
- Persistent connections (Keep-Alive)
- Chunked transfer encoding
- Host header (virtual hosting)
- Better caching

### Benefits
- Reduced latency
- Efficient resource usage
- Enabled shared hosting

### Still Has
- Head-of-line blocking
- Text-based inefficiencies

### Best Used For
- Dynamic websites
- E-commerce platforms
- APIs

---

## 🚀 HTTP/2 (2015)

### Major Enhancements
- Binary protocol
- Multiplexing (multiple requests over one connection)
- Header compression (HPACK)
- Server Push

### Benefits
- Significant performance improvement
- Faster page loads
- Efficient bandwidth usage

### Limitation
- Still uses TCP → TCP-level head-of-line blocking

### Best Used For
- Social media platforms
- Streaming services
- Large web applications

---

## 🚀 HTTP/3 (2020)

### Built On
- QUIC protocol (UDP-based)

### Major Advantages
- Eliminates TCP head-of-line blocking
- 0-RTT handshake (faster connection setup)
- Better packet loss handling
- Built-in TLS 1.3 (mandatory encryption)

### Benefits
- Lower latency
- More resilient on unstable networks
- Better mobile performance

### Best Used For
- Video conferencing (Zoom, Teams)
- Online gaming
- Live streaming
- Real-time apps

---

# 📊 Evolution Summary

| Improvement Area | 1.0 | 1.1 | 2 | 3 |
|------------------|------|------|------|------|
| Connection Efficiency | ❌ | ✅ | ✅ | ✅ |
| Multiplexing | ❌ | ❌ | ✅ | ✅ |
| Header Compression | ❌ | ❌ | ✅ | ✅ |
| TCP Head-of-Line Fix | ❌ | ❌ | ❌ | ✅ |
| Built-in Encryption | ❌ | ❌ | ❌ | ✅ |

---

## 🎯 Why Upgrade to Newer Versions?

- ⚡ Faster performance
- 🔐 Better security
- 📉 Reduced latency
- 📈 Improved scalability
- 🌐 Better real-world network handling

---

## 🧠 Quick Memory Trick

- **HTTP/1.0** → One request, one connection  
- **HTTP/1.1** → Keep connection alive  
- **HTTP/2** → Multiplex everything  
- **HTTP/3** → Replace TCP with QUIC (UDP)

---

# 🏁 Final Conclusion

The evolution from HTTP/1.0 to HTTP/3 represents:

> From simple request-response communication  
> ➜ to high-performance, encrypted, multiplexed, real-time web communication.

Modern web applications should use:
- **HTTP/2 or HTTP/3** whenever possible.
- HTTP/3 is ideal for mobile-heavy and real-time workloads.

## URL vs. URI vs. URN

URL: Specifies both the identity and the location of a resource (How and Where). (https://www.example.com/path?query=term#section)
URI: A more comprehensive term covering both URLs (identifying and locating) and URNs (just identifying). (https://www.example.com/path?query=term#section)
URN: Focuses only on uniquely identifying a resource, not on where it is located or how to access it. (urn:isbn:0451450523)

