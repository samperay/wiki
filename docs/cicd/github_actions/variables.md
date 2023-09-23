## Default & custom env vars

Variables provide a way to store and reuse non-sensitive configuration information.

You can set your own custom variables or use the default environment variables that GitHub sets automatically. For more information, see [Default environment variables](https://docs.github.com/en/actions/learn-github-actions/variables#default-environment-variables).

```yaml
name: custom vars
on:
    push
env:
    WF_ENV: env for workflow

jobs:
    log-env:
        runs-on: ubuntu-latest
        env: 
            JOB_ENV: env for job
        steps:
            - name: display all envs
              env:
                STEP_ENV: env for step
              run: |
                echo "WF_ENV: ${WF_ENV}"
                echo "JOB_ENV: ${JOB_ENV}"
                echo "STEP_ENV: ${STEP_ENV}"

            - name: display workflow and job env
              run: |
                echo "WF_ENV: ${WF_ENV}"
                echo "JOB_ENV: ${JOB_ENV}"
                echo "STEP_ENV: ${STEP_ENV}"
    log-default-env:
        runs-on: ubuntu-latest
        steps:
            - name: display all default envs
              run: |
                echo "GITHUB_ACTOR: ${GITHUB_ACTOR}"
                echo "GITHUB_JOB: ${GITHUB_JOB}"
                echo "RUNNER_ARCH: ${RUNNER_ARCH}"
                echo "RUNNER_OS: ${RUNNER_OS}"
                echo "WF_ENV: ${WF_ENV}"
                echo "JOB_ENV: ${JOB_ENV}"
                echo "STEP_ENV: ${STEP_ENV}"

```

References: [about variables](https://docs.github.com/en/actions/learn-github-actions/variables#about-variables)

## secrets variables

incase you need to add secrets to the workflow, in your github, **settings->Secrets and Variables->add secrets vars** and save it. You can ue those values in your workflow, so that it won't be able to display in the output. 

```yaml
on:
    push
env:
    WF_ENV: ${{ secrets.WF_ENV }} # reference the secrets

jobs:
    log-env:
        runs-on: ubuntu-latest
        env: 
            JOB_ENV: env for job
```

## Calling REST API to create issue

You can use the GITHUB_TOKEN to make authenticated API calls. This example workflow creates an issue using the GitHub REST API

```yaml
jobs:
  create_issue:
    runs-on: ubuntu-latest
    permissions:
      issues: write
    steps:
      - name: Create issue using REST API
        run: |
          curl --request POST \
          --url https://api.github.com/repos/${{ github.repository }}/issues \
          --header 'authorization: Bearer ${{ secrets.GITHUB_TOKEN }}' \
          --header 'content-type: application/json' \
          --data '{
            "title": "Automated issue for commit: ${{ github.sha }}",
            "body": "This issue was automatically created by the GitHub Action workflow **${{ github.workflow }}**. \n\n The commit hash was: _${{ github.sha }}_."
            }' \
          --fail
```

## Pull and push using GITHUB_TOKEN variable

```yaml
jobs:
    create_issue:
        runs-on: ubuntu-latest
        permissions:
            write-all
        steps:
          - name: push a random file
            run: |
                git init 
                git remote add origin "https://samperay:${{ secrets.GITHUB_TOKEN }}@github.com/$GITHUB_REPOSITORY.git"
                git config --global user.email "samperay@gmail.com"
                git config --global user.name "samperay"
                git fetch
                git checkout master
                git branch --set-upstream-to=origin/master
                git pull 
                ls -la
                echo $RANDOM >> random.txt
                ls -la
                git add -A
                git commit -m "added random file"
                git push 
```

## Encrypting and Decrypting files

we could use the file to store credentials if data >64KB where we store **api_username** or **api_token**. 
we could encrypt those file and later in the workflow we can decrypt to use those. Create **PASSPHRASE** in the github secrets and use that for decryption for the files to get **api_username** or **api_token**. 

```
vim secrets.json
{
    api_username: 'assasas'
    api_token: 'as8qwe78qwshhshhwhsd_sd!e7we'
}

gpg --symmetric --cipher-algo AES256 /tmp/secrets.json
git add /tmp/secrets.json.gpg
git commit -m 'added secretfile'
git push
```

```yaml
on:
    push

jobs:
    decrypt: 
        runs-on: ubuntu-latest
        steps:
            - uses: actions/checkout@v1

            - name: Decrypt file
              run: gpg --quiet --batch --yes --decrypt --passphrase="$PASSPHRASE" --output $HOME/secret.json secrets.json.gpg
              env: 
                PASSPHRASE: ${{ secrets.PASSPHRASE }}
              
            - name: print file secret contents
              run: cat $HOME/secret.json
```

References: [encrypted secrets](https://docs.github.com/en/actions/security-guides/encrypted-secrets)

## Contexts

Contexts are a way to access information about workflow runs, variables, runner environments, jobs, and steps. Each context is an object that contains properties, which can be strings or other objects.

```yaml
name: Context testing
runs-name: "contexts example"
on: push

jobs:
  dump_contexts_to_log:
    runs-on: ubuntu-latest
    steps:
      - name: Dump GitHub context
        env:
          GITHUB_CONTEXT: ${{ toJson(github) }}
        run: echo "$GITHUB_CONTEXT"
      - name: Dump job context
        env:
          JOB_CONTEXT: ${{ toJson(job) }}
        run: echo "$JOB_CONTEXT"
      - name: Dump steps context
        env:
          STEPS_CONTEXT: ${{ toJson(steps) }}
        run: echo "$STEPS_CONTEXT"
      - name: Dump runner context
        env:
          RUNNER_CONTEXT: ${{ toJson(runner) }}
        run: echo "$RUNNER_CONTEXT"
      - name: Dump strategy context
        env:
          STRATEGY_CONTEXT: ${{ toJson(strategy) }}
        run: echo "$STRATEGY_CONTEXT"
      - name: Dump matrix context
        env:
          MATRIX_CONTEXT: ${{ toJson(matrix) }}
        run: echo "$MATRIX_CONTEXT"

```

References: [context](https://docs.github.com/en/actions/learn-github-actions/contexts#about-contexts)

## Functions and expressions

You can use expressions to programmatically set environment variables in workflow files and access contexts. An expression can be any combination of literal values, references to a context, or functions

```yaml
  functions_expressions:
    runs-on: ubuntu-latest
    steps:
        - name: expressions
          run: |
            echo ${{ contains(fromJSON('["push", "pull_request"]'), github.event_name) }}
            echo ${{ startsWith('Hello world', 'He') }}
            echo ${{ endsWith('Hello world', 'ld') }}

  func_status_checks:
    runs-on: ubuntu-latest
    steps:
        - name: step to fail
          run: echooo "hello"
          
        - name: run even if failed
          if: failure()
          run: echo "I need this step to execute even if previous step fails"
          
        - name: run always
          if: always()
          run: echo "this step will always run, success or failed step"
          
        - name: run success
          run: echo "run when none of previous step failed" 
          if: success()
```

Note: line # 216, if we add `continue-on-error: true` we don't need line # 219. 
Both functions work in same manner.


References: [expressions](https://docs.github.com/en/actions/learn-github-actions/expressions)