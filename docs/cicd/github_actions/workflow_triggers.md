In this section, we will discuss about the Events, Schedules, External Events & Filters which can trigger the workflow run. 

## Triggerring workflow with events

We will create a new branch e.g(develop) and once created we would want the actions to run when we try to create a new PR. so we would add the event for `pull_request` which will trigger the workflow actions. 

There are types involved in the `pull_request` which tells as to what activities on PR would need your workflow to trigger run actions. e.g, when you `close` | `reopen` | `assign` ..etc

here is the link for list of activities for [pull_request](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#pull_request)

```yaml
name: actions workflow
run-name: actions workflow
on: 
    push:
    pull_request: 
        types: [opened, closed, assigned, reopened]

jobs:
    run-github-actions:
        runs-on: ubuntu-latest
        steps:
            - name: list files
              run: |
                pwd
                ls
            - name: checkout
              uses: actions/checkout@v1
            - name: list files after checkout 
              run: |
                pwd
                ls -a
            - name: simple JS actions
              id: greet
              uses: actions/hello-world-javascript-action@v1
              with:
                who-to-greet: John
            - name: Log greeting time
              run: echo "${{ steps.greet.outputs.time }}"
```

## needs

Identify any jobs that must complete successfully before another job will run.

e.g, when you have two or more jobs to run, and you have a scnerio that you must complete the first job and then it should start second job. in that case, you would use the key word `needs`

```yaml
jobs:
  run-shell-cmds:
    runs-on: ubuntu-latest
    steps:
      - name: echo string
        run: echo "hello world"

      - name: multiline script
        run: |
          node -v
          npm -v 

      - name: python command 
        run: | 
          import platform
          print(platform.processor())
        shell: python
  run-windows-cmds:
    runs-on: windows-latest
    needs: 
      - run-shell-cmds
```

References: [needs](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#jobsjob_idneeds)

## trigger using scheduler

you can use `cron` scheduler to run the action  workflow. 

Cron scheduler to run for every 5 mins, thats the minimum shortest interval you can run scheduled workflows.

```yaml
name: actions workflow
run-name: actions workflow
on: 
    schedule:
      - cron: "*/5 * * * *"
    # push:
    pull_request: 
      types: [opened, closed, assigned, reopened]
```

## trigger using dispatch_events

You can use the GitHub API to trigger a **webhook** event called **repository_dispatch** when you want to trigger a workflow for activity that happens outside of GitHub. 

Create a new **access token** for the authorization for the repo, and you can trigger it using curl or postman, on which your build would run. 

Postman configurations:

```
Authorization -> Select Basic Auth -> Password: sdhdjhdhd

Headers: 

Content-Type: application/json
Accept: application/json

Body: raw -> select JSON

{
    "event_type": "build",
		"client_payload": {
			"env" : "production"
  }
}

```

You can write any keyword for the `event_type` which you can call in the github action workflow.

```yaml
on:
  repository_dispatch:
    types: [build]
  pull_request: 
    types: [opened, closed, assigned, reopened]

jobs:
    run-github-actions:
        runs-on: ubuntu-latest
        steps:
            - name: webhook trigger build
              run: echo "${{ github.event.client_payload.env }}"
```

On triggring the event in the postman, your build should be running.

References: 

[create-a-repository-dispatch-event](https://docs.github.com/en/rest/repos/repos?apiVersion=2022-11-28#create-a-repository-dispatch-event)

[repository_dispatch](https://docs.github.com/en/actions/using-workflows/events-that-trigger-workflows#repository_dispatch)

## trigger using branches, tags, paths

you can use specific branch, tags and paths to execute scripts based on the actions. 
Note: You can't use including or excluding at same time

**including**

- branches
- tags
- paths

**excluding**

- branches-ignore
- tags-ignore
- paths-ignore

while you merge changes form one branch to another, and incase your target branch is `dev` or `feature`
then your PR would be running state. 

```yaml
on:
  push: 
    branches: 
      - "!dev1" # don't run actions if push is from dev1 branch
      - "dev" # run actions if push from dev branch

  pull_request:
    types:
      - opened
    branches:
      - "dev"
      - "feature/*" # feature/featureA, feature/featureB
      - "feature/**" # feature/feat/A, feature/feat/B
      - "!dev1" # don't run actions incase I create PR from current branch to dev1
```

References: [Filter Usage](https://docs.github.com/en/actions/using-workflows/workflow-syntax-for-github-actions#using-filters)