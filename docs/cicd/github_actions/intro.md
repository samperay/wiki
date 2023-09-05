In this intro page, we would look for couple of examples that we learnt from the overview section. 


## examples

As part of testing, create a new file in `.github/workflows/example.yml` on push to repository. Check from your `actions` of the github repository to see the results overview. 

```yml
name: example
run-name: example
on: push
jobs:
    demo:
        runs-on: ubuntu-latest
        steps:
            - name: first step
              run: echo "Hello world !"

            - name: second step
              run: echo "Hello World again !"
```

For, any python application in the repository, you need to check for the `requirements.txt` file and add all your dependencies to it, which will do **repository checkout, python setup, install libs, setup linter and unit testing.**

```yml
name: python application
on:
    push:
        branches: ["master"]
jobs:
    preinstall:
        runs-on: ubuntu-latest
        steps:
            - name: repository checkout
              uses: actions/checkout@v3

            - name: python3.10 setup 
              uses: actions/setup-python@v4
              with:
                python-version: '3.10'
                check-latest: true

            - name: install dependencies
              run: |
                pip install fastapi["all"]
                if [ -f requirements.txt ]; then pip install -r requirements.txt; fi

            - name: install flake8
              run: |
                flake8 . --count --exit-zero --max-complexity=10 --max-line-length=127 --statistics

            - name: test with pytest
              run: |
                pytest   
```

We can checkout our repository using the steps, however we can do the same things using `uses` or `checkout`

```yaml
name: checkout the git repo in the runner machine
on:
  - push
jobs:
    checkout_repo:
    runs-on: ubuntu-latest
    steps:
      - name: download the current repo
        run: |
          git init 
          git remote add origin "https://$GITHUB_ACTOR:${{ secrets.GITHIB_TOKEN }}@github.com/$GITHIB_REPOSITORY.git"
          git fetch origin 
          git checkout main
      
      - name: list all the files from download repository
        run: ls -a          
```

- using `uses` to download any repo

  ```yaml
  name: download the repo
  on:
    - push
  jobs:
      checkout_repo:
      runs-on: ubuntu-latest
      steps:
        - name: download the repository
          uses: actions/<your repository name>@[<commit_id>|<tag>|<release_version>]
        - name: list the files from repository
          run: ls -a
  ```

- using `checkout` to download the current repo, using `with` you can specify any repository you need to download
  
  ```yaml
    name: download the current repo
    on:
      - push
    jobs:
      checkout_repo_1:
      runs-on: ubuntu-latest
      steps:
        - name: files before checkout repository
          run: ls -a

        - name: download the repository
          uses: actions/checkout@v3

        - name: files after checkout repository
          run: ls -a
  ```

  References: https://github.com/actions/checkout 