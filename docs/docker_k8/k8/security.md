# Security

The Kube API server is at the heart of Kubernetes operations because all cluster interactions

## Authentication

Authentication verifies the identity of a user or service before granting access to the API server.

- Static user IDs and passwords(users/admins)

One simple method for authentication is using a static password file. This CSV file contains user details and is structured with three columns: password, username, and user ID. An optional fourth column can be added to assign users to specific groups.

```yaml
kube-apiserver --basic-auth-file=user-details.csv
```

- Tokens(service accounts)

you can authenticate using a static token file. This file includes a token, username, user ID, and an optional group assignment

```yaml
kube-apiserver --token-auth-file=user-token-details.csv
curl -v -k https://master-node-ip:6443/api/v1/pods --header "Authorization: Bearer <token>"
```

Note: not recommented due to security issues, instead use RBAC.

- Client certificates
- Integration with external authentication providers (e.g., LDAP)
- Service accounts


## Authorization

After authentication, authorization determines what actions a user or service is allowed to perform.

- Role-Based Access Control (RBAC) - default

RBAC simplifies user permission management by defining roles instead of directly associating permissions with individual users. For example, you can create a "developer" role that encompasses only the necessary permissions for application deployment. Developers are then associated with this role, and modifications in user access can be handled by updating the role, affecting all associated users immediately.

- Attribute-Based Access Control (ABAC)

Attribute-based authorization associates specific users or groups with a defined set of permissions.  For example, you can grant a user called "dev-user" permissions to view, create, and delete pods. This is achieved by creating a policy file in JSON format and passing it to the API server. Each time security requirements change, you must manually update this policy file and restart the Kube API Server. This manual process can be tedious and set the stage for more streamlined methods such as Role-Based Access Control (RBAC).

- Node Authorization

The Kubernetes API Server is the central component accessed by both management users and internal components, such as kubelets, which retrieve and report metadata about services, endpoints, nodes, and pods. 

Requests from kubelets—typically using certificates with names prefixed by "system:node" as part of the system:nodes group—are authorized by a special component known as the node **authorizer**.

- Webhook authorization


Methods to authorize..

- static file
- static token file
- certificates
- identity services

Note:  both these methods are not recommended due to security issues. 
RBAC is the most recommened method.

```yaml
# static file method
curl -v -k http://master-node-ip:6443/api/v1/pods -u "user1:password123" 

# token method
curl -v -k http://master-node-ip:6443/api/v1/pods --header "Authorization: Bearer <Token>"
```

we will study more on the [RBAC](#rbac).

## TLS Certificates

Secure communications between Kubernetes components are enabled via TLS encryption. This ensures that data transmitted between key components remains confidential and tamper-proof. 

- Communication within the etcd cluster
- Interactions between the Kube Controller Manager and Kube Scheduler
- Links between worker node components such as the Kubelet and Kube Proxy

Communication between the applications within cluster is defined by **network policies**

- What are TLS certificates?
- How does kubernetes use certificates?
- How to generate them?
- How to configure them?
- How to view them?
- How to troubleshoot issues related to certificates

A certificate is used to gurantee trust between 2 parties during a transaction. tls certificates ensure that the communication between them is encrypted.

**Symmetric** - uses single key to encrypt and decrypt the data and the key has to be exchanged between the sender and the receiver.
**Asymmetric** - instead of using single key, asymmetric encryption uses a pair of keys, **private key(*.pem) and a public key**(*.crt).

Asymmetric encryption is used only during the handshake(securely agree on a shared secret), to encrypt all actual website data you use 
Symmetric. 

- Browser connects to server (https://example.com)

- Server sends public key inside an SSL certificate

- Browser verifies certificate (CA trust)

- Browser creates a random Session Key (AES)

- Browser encrypts the session key with server’s public key

- Server decrypts using private key

- Both now share the same symmetric key

- All further communication is encrypted with fast AES symmetric encryption

```
# Generate a private key
openssl genrsa -out my-bank.key 1024

# Extract the public key
openssl rsa -in my-bank.key -pubout > mybank.pem or mybank.crt
```

```

                  HTTPS Communication Flow
       -----------------------------------------------------

            (1) Client Hello
       Browser ----------------------------------> Server

            (2) Server sends Certificate (Public Key)
       Browser <----------------------------------- Server
                          |
                          | Public Key (from cert)
                          |
                    Certificate verified?
                       (Trusted CA)

            (3) Browser generates "Session Key" (AES)
            (4) Browser encrypts Session Key with
                Server's Public Key
       Browser ----------------------------------> Server
              Encrypted(SessionKey, ServerPublicKey)


            (5) Server decrypts Session Key using
                Private Key

       Server: SessionKey = decrypt_with_private_key(encrypted_key)

            Both now have SAME Session Key!

       -----------------------------------------------------
       FROM HERE ON:
       All data encrypted with AES (Symmetric Encryption)
       -----------------------------------------------------

       Browser <======== TLS Encrypted Traffic ========> Server

```

Browsers rely on Certificate Authorities (CAs) to sign and validate certificates. Renowned CAs, such as Symantec, DigiCert, Komodo, and GlobalSign, use their private keys to sign certificate signing requests (CSRs). When you generate a CSR for your web server, it is sent to a CA for signing:

```openssl req -new -key my-bank.key -out my-bank.csr -subj "/C=US/ST=CA/O=MyOrg, Inc./CN=my-bank.com"```

## Kubernetes TLS Certificates

Since, the method is being used for creation cluster is *kubeadm*, all the certificates are stored in below location `/etc/kubernetes/pki/`

- Server Certificates for Servers

- Client Certificates for Clients

- Public keys
```
apiserver-etcd-client.crt  
apiserver-kubelet-client.crt  
apiserver.crt
ca.crt
front-proxy-ca.crt  
front-proxy-client.crt
```

- Private keys
```
apiserver-etcd-client.key  
apiserver-kubelet-client.key  
apiserver.key
ca.key
front-proxy-ca.key  
front-proxy-client.key  
sa.key
```

Viewing, certiticate details : ```openssl x509 -in /etc/kubernetes/pki/apiserver.crt -text -noout```

Fields to be viewed :  ```Issuer - Validity - Subject - Subject Alternative Names```

Troubleshooting, kubeadm installation method.

```yaml
kubectl logs etcd-master
docker ps -a
docker logs <container-id>
```

## Certificate API

The CA is really just the pair of **key and certificate files** that we have generated, whoever gains access to these pair of files can sign any certificate for the kubernetes environment.
Kubernetes has a built-in certificates API that can do this for you.

- CertificateSigningRequest
- Review Requests
- Approve Requests
- Share to Users

All the certificate releated operations are carried out by the controller manager.

[Certificate signing requests](./cmdref.md#csr)

## kubeconfig

Client uses the certificate file and key to query the kubernetes Rest API for a list of pods using curl.

```kubectl get pods --kubeconfig config ```

The kubeconfig file has 3 sections

- Clusters
- Contexts
- Users

[kubectl config references](./cmdref.md#kubeconfig)

## API Groups

Kubernetes organizes its API into multiple groups based on specific functionality. These groups help in managing versioning, health metrics, logging, and more. For instance, the /version endpoint provides cluster version data, while endpoints like /metrics and /healthz offer insights into the cluster’s performance and health.

These APIs are catagorized into two.

**Core API Group:**
Contains the essential features of Kubernetes such as namespaces, pods, replication controllers, events, endpoints, nodes, bindings, persistent volumes, persistent volume claims, config maps, secrets, and services.

**Named API Groups:**
Provides an organized structure for newer features. These groups include apps, extensions, networking, storage, authentication, and authorization.

Every API group includes various resources along with associated actions (verbs) such as list, get, create, delete, update, and watch

```yaml
curl http://localhost:6443 -k # query API Server
curl http://localhost:6443/apis -k
```

## RBAC

                       ( WHO? )
       +---------------------------------------------+
       |        Users / Groups / ServiceAccounts     |
       +-------------------------+-------------------+
                                 |
                                 |  RoleBinding / ClusterRoleBinding
                                 v
        +-------------------------------------------------------------+
        |          RBAC BINDINGS (connect WHO ↔ WHAT)                |
        |  - RoleBinding (namespaced)                                |
        |  - ClusterRoleBinding (cluster-wide)                       |
        +-------------------------+-----------------------------------+
                                  |
                                  | points to
                                  v
       +-------------------------------------------------------------+
       |          Roles / ClusterRoles (WHAT actions allowed)        |
       |  rules:                                                     |
       |   - apiGroups                                              |
       |   - resources                                              |
       |   - verbs                                                  |
       +-------------------------+-----------------------------------+


**RBAC Object Summary**

+----------------------+----------------------+----------------------------------+
| RBAC Object          | Scope               | Purpose                          |
+----------------------+----------------------+----------------------------------+
| Role                 | Namespace            | Define permissions within a NS   |
| ClusterRole          | Cluster-wide         | Define global permissions        |
| RoleBinding          | Namespace            | Bind Role to subject             |
| ClusterRoleBinding   | Cluster-wide         | Bind ClusterRole to subject      |
+----------------------+----------------------+----------------------------------+

**Resource Types & API Groups**

Core API Group (""): pods, configmaps, secrets, services, nodes, persistentvolumes

apps API Group ("apps"): deployments, daemonsets, replicasets, statefulsets

rbac API Group ("rbac.authorization.k8s.io"): roles, clusterroles, bindings

batch API Group ("batch"): jobs, cronjobs


**Verbs Cheat Sheet**

get        → Read a single object
list       → List all objects
watch      → Watch changes
create     → Create objects
update     → Modify
patch      → Partial modification
delete     → Delete object
deletecollection → Delete multiple
exec       → Execute command in pods
logs       → View logs (pods/log subresource)


**Test RBAC**

```yaml
kubectl auth can-i <verb> <resource> --as <user>

kubectl auth can-i create pods --as dev-user -n dev
kubectl auth can-i delete nodes --as audit-bot
kubectl auth can-i list secrets --as=system:serviceaccount:prod:app-sa


```

All the examples are found here.. 

[role|rolebinding|clusterrole|clusterrolebindings|examples](./cmdref.md#rbac-practice-examples)

### Role

Namespace-scoped, defines permission inside a namespace.

Roles can be described with below three parameters.
- apiGroups
- resources
- verbs [ get, list, watch, create, update, patch, delete ] 

linking user to the role is called **rolebinding**

## ClusterRole

Not namespaced, 
Used for:
  Cluster-wide resources (nodes, CRDs) Or reusable Role across namespaces

## RoleBinding

Binds a Role → Subject (user / group / service account) within a namespace

## ClusterRoleBinding

Binds a ClusterRole → Subject cluster-wide

## Images Security

when we pull image from "nginx" we are pulling from the nginx/nginx of the private docker.io hub.
so you need to login to your hub.docker.com so that kubelet will try to pull image from the repository and deploy applications in the worker nodes.

```
containers:
- name: nginx
  image: nginx
```

what if the repository is private, then you need to specify the DNS name prefixed with the docker image.
```
containers:
- name: nginx
  image: private-repo/nginx:latest
```

If you have to modify the docker containers which has to be provided with the secrets, kubernets have secrets where you can store your credentials.

```
kubectl create secret docker-registry private-reg-cred --docker-username=dock_user --docker-password=dock_password --docker-server=myprivateregistry.com:5000 --docker-email=dock_user@myprivateregistry.com
```
you would be using these credentials for the pod in applications to be up and running.

```
spec:
  containers:
  - name: private-reg-container
    image: <your-private-image>
  imagePullSecrets:
  - name: private-reg-cred
```

## Secrurity Contexts
You may choose to configure the security settings at a container level or at a pod level.

To add security context on the container and a field called securityContext under the spec section.

```
spec:
  securityContext:
    runAsUser: 1010
  containers:
  - name: ubuntu
```

To add security context at security level,

```
spec:
  containers:
  - name: ubuntu
    image: ubuntu
    command: ["sleep", "3600"]
    securityContext:
      runAsUser: 1000
      capabilities:
        add: ["MAC_ADMIN"]
```