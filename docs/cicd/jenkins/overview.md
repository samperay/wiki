## Build Trigger

**Trigger builds remotely**

Enable this option if you would like to trigger new builds by accessing a special predefined URL. you will pre-define the token and will pass that to the specific url to trigger build

`JENKINS_URL/job/python-app/build?token=TOKEN_NAME`

**Build after other projects are built**

Set up a trigger so that when some other projects finish building, a new build is scheduled for this project

**Build periodically**

Cron job

**Build when a change is pushed to Gogs**

when we commit the change, this would trigger the build

**Poll SCM**

Configure Jenkins to poll changes in SCM. Costly ops as it should scan the entire workspace. 

Reference: https://wiki.jenkins.io/display/JENKINS/Building-a-software-project.html

## Sample Jenkinsfile

Simple Jenkinsfile

```
pipeline {
	agent any 
	stages{
		stage('Bulid') {
			steps {
				echo "Running build id {env.BUILD_ID} on jenkins url ${env.JENKINS_URl}"
			}
		}
	}
}
```

## Environments Jenkinsfile

**Global environment variables set**

```
pipeline {
	agent any 

    // env defined globally for all the stages
    // we must avoid env to be set global

    environment {
        DB_HOSTNAME = 'rds-db.example.com'
        PORT=3023
        DB_USERNAME = 'dbuser'
        DB_PASSWORD = 'password123'
    }
	stages{
		stage('Bulid') {
			steps {
				echo "Running build id {env.BUILD_ID} on jenkins url ${env.JENKINS_URl}"
                echo "db_hostname: ${DB_HOSTNAME}"
                echo "db_username: ${DB_USERNAME}"
                echo "db_password: ${DB_PASSWORD}"
			}
		}

        stage('test') {
            steps {
                echo "this is testing stage"
                echo "stage:test db_username: ${DB_USERNAME}"
            }
        }
	}
}
```

Define env vars locally 

```
pipeline {
	agent any 

	stages{
		stage('Bulid') {
		        environment {
                DB_HOSTNAME = 'rds-db.example.com'
                PORT=3023
                DB_USERNAME = 'dbuser'
                DB_PASSWORD = 'password123'
            }
			steps {
				echo "Running build id {env.BUILD_ID} on jenkins url ${env.JENKINS_URl}"
                echo "db_hostname: ${DB_HOSTNAME}"
                echo "db_username: ${DB_USERNAME}"
                echo "db_password: ${DB_PASSWORD}"
			}
		}

        // this stage won't have access for the vars and hence the build will be failed.
        
        stage('test') {
            steps {
                echo "this is testing stage"
                echo "stage:test db_username: ${DB_USERNAME}"
            }
        }
	}
}
```

Builtin env 

```
pipeline {
	agent any 

	stages{
		stage('Bulid') {
		        environment {
                DB_HOSTNAME = 'rds-db.example.com'
                PORT=3023
                DB_USERNAME = 'dbuser'
                DB_PASSWORD = 'password123'
            }
			steps {
				echo "Running build id {env.BUILD_ID} on jenkins url ${env.JENKINS_URl}"
                echo "db_hostname: ${DB_HOSTNAME}"
                echo "db_username: ${DB_USERNAME}"
                echo "db_password: ${DB_PASSWORD}"
			}
		}

        stage('test') {
            steps {
                echo "this is testing stage"
                echo "build number ${env.BUILD_ID}"
            }
        }
	}
}
```

Reference: https://wiki.jenkins.io/display/JENKINS/Building-a-software-project.html#Buildingasoftwareproject-belowJenkinsSetEnvironmentVariables


**Accessing credentials**

There are two types of credentials

1. System - Defined for specific projects etc 
2. Global - Defined for all the projects

I am using `Global` I will create `username and password` with id as `prod-server` for the credentials and use them for the Jenkinsfile

```
pipeline {
	agent any

	environment {
		PROD_SERVER = credentials('prod-server')
	}

	stages {
		stage('Build') {
			steps {
				echo "running build stage"
				echo "${PROD_SERVER}"
				echo "${PROD_SERVER_USR}"
				echo "${PROD_SERVER_PSW}"
			}
		}
	}
}
```

when used `PROD_SERVER_USR` and `PROD_SERVER_PSW` it will display username and password. but its not recommended to use as it would provide warning message in the jenkins console. 

we must be using **Jenkins Binding Credentials**. 

```
pipeline {
	agent any 

	stages{
		stage('build') {
			steps {
				echo 'build stage'
				withCredentials([usernamePassword(credentialsId: 'prod-server', usernameVariable: 'myusername', passwordVariable: 'mypassword')])
				{
					sh '''
					echo username: ${myusername}
					echo password: ${mypassword}
					'''
				}
			}
		}
	}
}
```

Reference: https://www.jenkins.io/doc/pipeline/steps/credentials-binding/#withcredentials-bind-credentials-to-variables


## Nested and parallel stages

