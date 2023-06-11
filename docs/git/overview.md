# Overview

## Explain 3 tier architecture of git

![git architecture](../images/git_three_tier_arch.png)

- working directory - current files that are stored, it's also called as **untracked files**
- staging area - files that you wish to commit(to create snapshot of the files). These are also called as **tracked files**
- git directory - after commit is fired, files which are in staging area will move to git repository.

## What would you do when you want to remove a staged/tracked file from repo

git reset HEAD -- path/to/file

## what are the three types of undoing the commits
    
- ## git checkout
  you would use the commit id and move your **HEAD** to that particular commit and then you would **branch** from there. 

  ```
  git commit <commit_id>
  git checkout -b <new_branch>```

  Incase you don't need to branch out, this method is not suitable

  second way,

  ```
  git log --oneline
  git checkout <commit-id> -- filename.txt
  git status
  git log --oneline
  git commit -m 'new commit id'
  ```

- ## git reset 
    reset cannot be used when working with a remote repository. 

    you would undo the commit using git commit id. there are three modes, **soft**, **mixed** and **hard**. all are the same, but they differ in how they treat changes in the working directory and the staging area. 

    **soft** - won't effect working directory or staging area. e.g if just a commit needs to be changed. 
    ```git reset --soft commitid```

    **mixed** - revert changes in staging area. **DEFAULT** 
    ```git reset --mixed commitid```


    **hard** - revert changes in the working directory along with the staging area and repository. e.g if commit is complete failure, and you want to undo the changes involved in the commit as well.

    ```git reset --hard commitid```


- what happens when you do "hard reset" in git
- whats the difference between fast-forward merge with commit and without commit
- Explain difference between git fetch and git pull
- what is rebase and explain
- Explain about the branchinig startergy
- How do you resolve conflicts in branches

## References
https://www.bogotobogo.com/cplusplus/Git/Git_GitHub_Express.php

https://www.codementor.io/@alexershov/11-painful-git-interview-questions-and-answers-you-will-cry-on-lybbrqhvs`
