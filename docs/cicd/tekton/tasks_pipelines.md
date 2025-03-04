## Task

re-usale atomic work, a specific job that needs to be built or testing. it executes as a pod in the cluster. it has be initiated by taskRun.

```yml
# tasks.yml
apiVersion: tekton.dev/v1beta1
kind: Task
metadata:
  name: 4-01-echo-task
spec:
  description: A simple example Tekton Task
  steps:
    - name: echo-step
      image: alpine:3.14
      script: |
        #!/bin/sh
        echo "Message: Hello, Tekton!"
```
```
kubectl create -f tasks.yaml
kubectl get tasks
kubectl describe task 4-01-echo-task
```

## TaskRun

- individual runs of the tekton tasks. 
- actual work carried out for CICD tasks. 
- tasksRun are initated from the tasks for execution
- each taskRun is executed only once. 

```yml
# tasks_run.yml
apiVersion: tekton.dev/v1beta1
kind: TaskRun
metadata:
  name: 4-02-echo-task-run
spec:
  taskRef:
    name: 4-01-echo-task
```

```
kubectl create -f tasks_run.yml
kubectl get pods 
kubectl logs <pod_name>
```

## Pipeline

- define and manage CICD pipelines
- seq of tasks together for CICD
- customize the execution conditions according to business needs

```yml
# pipeline.yml
apiVersion: tekton.dev/v1beta1
kind: Pipeline
metadata:
  name: 4-03-example-pipeline
spec:
  tasks:
    - name: echo-task
      taskRef:
        name: 4-01-echo-task
```
```
kubectl create -f pipeline.yml 
kubectl get pipelines 
kubectl describe pipeline 4-03-example-pipeline
```

## PipelineRun

- instance of pipeline
- representatin of actual instantition of CICD workflow
- pipelineRuns are building constructs from those blueprints
- each pipelineRun is a unique execution of pipeline

```yml
# pipeline_run.yml
apiVersion: tekton.dev/v1beta1
kind: PipelineRun
metadata:
  name: 4-04-example-pipeline-run
spec:
  pipelineRef:
    name: 4-03-example-pipeline
```

```
kubectl create -f pipeline_run.yml 
kubectl get pipelineruns  / kubectl get taskruns
kubectl get pods 
kubectl logs 4-04-example-pipeline-run-echo-task-pod 
```

if you are deleting pipelineRuns, assicoated taskRuns also deleted. 

## input parameterizing

## Results 

## workspaces

## auth

## clustertask

## resolvers
