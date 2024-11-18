# Virtual Server

Application: https://github.com/samperay/jenkins-project/tree/single-server-deploy

Spinned up a new ec2 machine(prod-server) where the application is deployed. we would be configuring the application to have an Continious deployment. This is on a `single-server-deployment` 

```
mkdir /home/ec2-user/
cd /home/ec2-user/app
python3 -m venv venv
vi /etc/systemd/system/flaskapp.service
   
[Unit]
Description=flask app 
After=network.target

[Service]
User=ec2-user
Group=ec2-user
WorkingDirectory=/home/ec2-user/app/
Environment="PATH=/home/ec2-user/app/venv/bin"
ExecStart=/home/ec2-user/app/venv/bin/python3 /home/ec2-user/app/app.py

[Install]
WantedBy=multi-user.target


sudo systemctl enable flaskapp.service
sudo systemctl start flaskapp.service
```

# Jenkins server installation 

EC2 machine has been spinned `t2.medium` without which the jenkins server won't be able to schedule the job.

## Installation

```
sudo yum update –y
sudo wget -O /etc/yum.repos.d/jenkins.repo https://pkg.jenkins.io/redhat-stable/jenkins.repo
sudo rpm --import https://pkg.jenkins.io/redhat-stable/jenkins.io-2023.key
sudo dnf install java-17-amazon-corretto docker -y
sudo yum install jenkins -y
sudo systemctl enable jenkins
sudo systemctl start jenkins
sudo systemctl status jenkins
sudo systemctl start docker.service
sudo systemctl enable docker.service
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
sudo usermod -a -G docker ec2-user
sudo usermod -a -G docker jenkins
sudo chown jenkins /var/run/docker.sock
```

## Pipelines

In Jenkins configure the `pipeline` job, and run the build to see the deployed version.
https://github.com/samperay/jenkins-project/tree/single-server-deploy

```
pipeline {
	agent any 

	environment {
		SERVER_IP = credentials('prod-server-ip')
	}

	stages {
		stage('Setup') {
			steps {
				sh "pip install -r requirements.txt"
			}
		}

		stage('Test') {
			steps {
				sh "pytest"
			}
		}

		stage('Package code') {
			steps {
				sh "zip -r myapp.zip ./* -x '*.git*'"
				sh "ls -lart"
			}
		}

		stage("Deploy to Prod") {
			steps {
				withCredentials([sshUserPrivateKey(credentialsId: 'ssh-key', keyFileVariable: 'MY_SSH_KEY', usernameVariable: 'username')]) {
					sh '''
					scp -i $MY_SSH_KEY -o StrictHostKeyChecking=no myapp.zip ${username}@${SERVER_IP}:/home/ec2-user/
					ssh -i $MY_SSH_KEY -o StrictHostKeyChecking=no ${username}@${SERVER_IP} << EOF 
					  unzip -o /home/ec2-user/myapp.zip -d /home/ec2-user/app/
					  source app/venv/bin/activate
					  cd /home/ec2-user/app
					  pip install -r requirements.txt
					  sudo systemctl restart flaskapp.service
					'''
				}
			}
		}

	}
}
```


# Docker

In Jenkins configure the `pipeline` job to build and push the docker image to hub. 
https://github.com/samperay/jenkins-project/tree/docker-image

```
pipeline 
{
	agent any

	environment {
		IMAGE_NAME='sunlnx/jenkins-flask-app'
		IMAGE_TAG="${IMAGE_NAME}:${env.GIT_COMMIT}"
	}
    
	stages 
    {
        
		stage('Setup') 
        {
			steps {
				sh "pip install -r requirements.txt"
			}
        }

		stage('Test')
        {
			steps {
				sh "pytest"
			}
		}

	    		stage('Build Docker Image') 
        {
			steps {
				sh 'docker build -t ${IMAGE_TAG} .'
				echo "Docker image build successfully"
				sh 'docker images ls'
			}
		}

		stage('Login to Dockerhub') 
        {
			steps {
				withCredentials([usernamePassword(credentialsId: 'docker-creds', usernameVariable: 'USERNAME', passwordVariable: 'PASSWORD')]) {

				sh 'echo ${PASSWORD} | docker login -u ${USERNAME} --password-stdin' 
				echo 'login successful'
				}

			}
		}

		stage('Push Docker image') 
        {
			steps {
				sh "docker push ${IMAGE_TAG}"
				echo "Docker image pushed successfully."
			}
		}

	}

}
```