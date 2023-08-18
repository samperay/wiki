## cicd pipeline

we would have complete version of the cicd pipeline. 


### feature to develop branch

- Developer would create a new `feature branch` and `push`
- Once the push is detected, we would `run the workflow` against it. 
- Once they are successful, you would `create a PR` for the `dev branch` where we run `workflow actions`.
- once the `job is successful`, we would `deploy code in the staging server`. 
  
### develop to master branch

- we would create a` new PR from dev branch to master`, which makes the `actions to run`
- On successful run, we would deploy code to the production server. 

### Post deployments

- Job failures, we would create a new issue 
- successful job, would send a slack message
- successful release, we would send a slack message

![github_actions_cicd](../../images/github_actions_cicd.png)