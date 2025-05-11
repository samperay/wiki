### Docker networking

**Explain how Docker networking works.**

Docker networking provides different network drivers:

- Bridge (default for standalone containers): Containers can communicate within the same bridge network.
- Host: Removes network isolation between the container and the host.
- Overlay: Used in Swarm mode for multi-host networking.
- Macvlan: Assigns a MAC address to containers for direct communication with the physical network.
- None: No network access.

How would you connect multiple containers in a production environment?

- Use Docker Compose: Define a docker-compose.yml file to manage multi-container communication.
  
- Use Custom Networks:
```bash
docker network create my_network
docker run --network=my_network --name=app1 my_app
docker run --network=my_network --name=db my_db
```
This allows containers to resolve each other using container names.

### Persistent storage

**How would you persist data in Docker containers to ensure it is not lost when the container restarts?**

Docker provides Volumes and Bind Mounts:

**Volumes (Preferred for Docker-managed storage)**

```bash
docker volume create my_volume
docker run -d -v my_volume:/data --name my_container my_image
```

**Bind Mounts (Maps a host directory to a container)**

```bash
docker run -d -v /host/path:/container/path --name my_container my_image
```

For databases, use named volumes:
```bash
docker run -d -v db_data:/var/lib/mysql --name mysql_container mysql
```

### Docker img optimize

**Your team is building a large Docker image that takes a long time to build and deploy. How would you optimize it?**

Best Practices to Optimize Docker Images:

- Use a minimal base image ```FROM python:3.9-alpine```

- Leverage multi-stage builds

```bash
FROM golang:1.18 AS builder
WORKDIR /app
COPY . .
RUN go build -o myapp

FROM alpine:latest
COPY --from=builder /app/myapp /myapp
CMD ["/myapp"]
```

- Minimize layers and avoid unnecessary packages
- Use `.dockerignore `to exclude unnecessary files (e.g., logs, .git)

### Docker security

- Use minimal base images: Avoid bloated images.
- Scan images for vulnerabilities ```docker scan my_image```
- Run containers as non-root users
```bash
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser
```
- Restrict container privileges 
```bash 
docker run --security-opt no-new-privileges --read-only --cap-drop=ALL my_app
```
- Limit network exposure: Use internal networking instead of exposing unnecessary ports.

### Container Failures

**Your application runs in Docker containers. A container crashes unexpectedly. How do you debug it?**

- Check logs: ```docker logs container_name```
- Inspect container state : ```docker inspect container_name```
- Check for OOM (Out-of-Memory) issues: ```docker stats```
incase it has update it ```docker run -m 512m --memory-swap 1G my_app```
- Restart Policy: ```docker run --restart=always my_app```

### CICD Docker

**How would you integrate Docker into a CI/CD pipeline?**

**Use GitHub Actions, Jenkins, GitLab CI/CD:**

```bash
name: Docker Build & Push
on:
  push:
    branches:
      - main
jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
      - name: Build Docker image
        run: docker build -t myrepo/myapp:latest .
      - name: Login to Docker Hub
        run: echo "${{ secrets.DOCKER_PASSWORD }}" | docker login -u "${{ secrets.DOCKER_USERNAME }}" --password-stdin
      - name: Push Docker image
        run: docker push myrepo/myapp:latest
```

**Jenkinsfile**

```bash
pipeline {
    agent any

    environment {
        DOCKER_USERNAME = credentials('docker-username')  // Stored as a Jenkins credential
        DOCKER_PASSWORD = credentials('docker-password')  // Stored as a Jenkins credential
        IMAGE_NAME = 'myrepo/myapp:latest'
    }

    stages {
        stage('Checkout Code') {
            steps {
                checkout scm
            }
        }

        stage('Build Docker Image') {
            steps {
                script {
                    sh "docker build -t ${IMAGE_NAME} ."
                }
            }
        }

        stage('Login to Docker Hub') {
            steps {
                script {
                    sh "echo ${DOCKER_PASSWORD} | docker login -u ${DOCKER_USERNAME} --password-stdin"
                }
            }
        }

        stage('Push Docker Image') {
            steps {
                script {
                    sh "docker push ${IMAGE_NAME}"
                }
            }
        }
    }
}

```

### Troubleshooting Issues

**A container is running but you cannot access the application inside it. How do you troubleshoot?**

- Check container status: ```docker ps -a```
- check logs: ```docker logs my_container```
- Inspect container networking: ```docker inspect my_container | grep "IPAddress"```
- Exec into the container: ```docker exec -it my_container /bin/sh```
- check port binding: ```docker run -p 8080:80 my_app```


**"/bin/bash" Exited few seconds ago** 

A container lives as long as a process within it is running. If an application in a container crashes, container exits.

unlike in other application programs like httpd, nginx, mysqld bash is not a process which is running. infact its a shell process which is listening for the input, when it don't get, it would exit the container.

If we want to make the shell listen to some command for execution, you can find the below one. 

so we can make the container to sleep 30 seconds. 

```
docker run ubuntu:18.04 sleep 30s
```