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

- instead of static, we would write re-usable code using input parameteriation.
- flow control is key benefit
- allows to make decision during the execution of your tasks/pipelines based on input values.
  
## Results 

- tekton tasks and taskruns can accept input parameters
- flexibility using results of steps in and beyond tasks. 
The tasks is able to emit results in simple case as string, objects, arrays etc

## workspaces

- storage area that allows tasks and pipeines to share data and files
- configmap, secrets, pvc, pvc-templates etc
- why ?
  - data sharing
  - data persistance
  - isolation
- task level 
  - definition where workspace reside on its step containers
  - specifies how data should be stored and accessed during the execution of that specific task. 
- pipeline level
  - mamages data flow between thaks via worksapce collaboration
  - task A downloads code, while task B needs artifact for compiling

Who creates wokspace and who manages ?

- its reposibility of taskrun and taskrunpipeline. 
  - providing and managing the workspace
- when creating a taskrun or pipelinerun
  - specficatin necessary which workspace to use under which volume
  - tekton take care about creating and mounting volumes on pod level

write task in one workspace and read from another workspace. 
more info on examples: 4.0.7-*.yaml

## auth

## clustertask

## resolvers
