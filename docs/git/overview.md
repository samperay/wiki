## Overview

## Git Arch

![git architecture](../images/git_three_tier_arch.png)

**Working directory** - current files that are stored, it's also called as **untracked files**
**Staging area - files that you wish to commit(to create snapshot of the files).
**Git directory** - after commit is fired, files which are in staging area will move to git repository.
    
## Checkout
you would use the commit id and move your **HEAD** to that particular commit and then you would **branch** from there. 

```
git commit <commit_id>
git checkout -b <new_branch>
```

Incase you don't need to branch out, this method is not suitable

second way,

```
git log --oneline
git checkout <commit-id> -- filename.txt
git status
git log --oneline
git commit -m 'new commit id'
```

## branching 

**fast-forward:** 

Developers create a feature branch, work on it, and when it's ready to be integrated into the main development branch, they perform a fast-forward merge if the conditions are met. This keeps the commit history clean and straightforward.

Default merging startergy would be `ff`

```
git branch -b feature/feature1
git checkout main
git merge feature/feature1
```

## diff

git diff command is used to display the differences between two sets of changes, such as comparing files between branches.

```
# differences between the master branch and a feature
git diff master..feat1 

#differences for file1.txt and file2.js between the master and feat1 branch
git diff master..feat1 file1.txt file2.js 

#Difference for a Single File
git diff master:app.js feat1:app.js

#Differences for Staged Changes
git diff --staged
```

## stash & unstash

Let's assume you created file and commited in the main branch. Now, lets say you would checout a new branch and modify the files without committing. Once you switch back to main branch **you would get the changes made in another branch to main** which is not recommended. The solution would be to **stash** changes to the branch before switching.

```
git stash list

git stash 
or 
git stash save

```

Once you are back to your branch(or any branch you would want to apply changes on), you can **unstash** and start working from where you left off. 

`pop` it would apply changes to the current branch you are in, and removes from the stash. `apply` applies the changes to the current directory and would not remove from the stash.



```
# removes from the stash
git stash pop

or 

# would not remove, but can be applied later to any branch.

git stash apply
```

you can clear or drop stashes

```
git stash drop stash@{1}
git stash clear
```

## git time travel

### detached HEAD

When we commit any file in the branch, the HEAD always points to the branch. when we checkout and workon, we still have our HEAD being pointed at the branch we work upon.

When we checkout a particular commit, HEAD points at that commit rather than the branch, then we call it as a `detached HEAD`

```
git log --oneline
git commit <commit-id>
git status 
```

It would be very essential sometimes that you need to take up a particular commit and then work upon. In that case, you can checkout particular commit, where youe HEAD would point to the branch you took from.

```
git checkout <commit-id>
<modify your files>
git add .
git commit -m 'your new commits'
git status
```

You can select the previous commit using HEAD

```
git checkout HEAD~1
git checkout HEAD~2
git switch - # it would take you back where you were there
```

### discard changes

you have made changes to the file, but don't want to keep those. You can revert back the file to whatever it looked like when you last committed, `reverting back to HEAD`

```
1. git checkout HEAD file1.txt
2. git checkout -- file1.txt file2.txt
3. git restore file1.txt file2.txt
```

Let's say you have commited the secrets file(i.e staged area), and now you want to restore it.

```
git status
git restore --staged secrets.txt
git status
```

## git reset

**soft**

let's say you have made a **couple of bad commits** on the master branch, but you actually made them on a seperate branch instead, then you use `git reset <commitid>`. here, in this case you would actually lose the commit id's but your changes in the file remains the same. Hence you would need to take a new branch and commit those files. Once commited then come back to `master/main` branch. you won't see those commits as well as the changes made to that file.

simple words, won't effect working directory or staging area, only commitid would be changed.

```
git log --oneline
git reset commitid
git log --oneline - bad commits to the file not seen, head is relaed to your commitid
git status - it says modified, but your changes still exists
git checkout -b do_your_commits
git add . 
git commit 'removed changed made to files from the branch'
git checkout master
git status
```

**hard**

If you want your changes and your commitid to be reverted from `working directory and stage` then you would be performing the `hard` reset. 

```
git log --oneline
git status 
git reset --hard commitid - all your changes are lost along with commitid
git status
```

***Note:*** Make sure always that you need to be careful in hard reset as you would lose changes made in working directory.

## git revert

Creates a new commit which reverses/undo the changes from a commit. 

```
git add .
git commit -m 'bad commits'
git log --oneline
git revert commitid - this will prompt an editor for changes and on saving you would "revert bad commit", changes to the file are lost
git status
git log --oneline - your revert entry will be added so that collaborators would know that you have reverted changes on the code.
```


- whats the difference between fast-forward merge with commit and without commit
- Explain difference between git fetch and git pull
- what is rebase and explain
- Explain about the branchinig startergy
- How do you resolve conflicts in branches



## Git Oneliners

```
git reset HEAD -- path/to/file -> rm file from staged repo

git commit --amend -m 'created new files' --no-edit -> modify recent commit

git reset --hard HEAD~1  -> revert previous commit
```

## References
https://www.bogotobogo.com/cplusplus/Git/Git_GitHub_Express.php

https://www.codementor.io/@alexershov/11-painful-git-interview-questions-and-answers-you-will-cry-on-lybbrqhvs`
