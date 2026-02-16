# Problem Session 

# Git & GitHub – Version Control & Internal Model



# Why Git?

Without Git:

* You copy folders: `project_final_v2_real`
* You overwrite teammates
* You fear breaking working code
* You cannot revert safely

Git provides:

> Snapshot history + branching + safe collaboration.

Git is **distributed**:

* Works locally
* Does not require internet
* GitHub is just a remote repository



#  Git Architecture Overview

Git has **three core areas**:

```
Working Directory
        ↓
Staging Area (Index)
        ↓
Repository (Commit Graph)
```

This is the most important conceptual model.



## Working Directory

Your actual project files.

* You edit files here.
* Changes are not automatically committed.



## Staging Area (Index)

Intermediate layer.

* `git add` moves changes here.
* Prepares snapshot.



## Repository (Commit Graph)

* Permanent history.
* Stored inside `.git/`.
* Every commit is a node in a graph.



# Initialize Repository

```bash
mkdir ps4
cd ps4
git init
```

This creates:

```
.git/
```

This directory stores:

* Commit objects
* Branch references
* HEAD pointer
* Index (staging area metadata)



# Basic Workflow

Create file:

```bash
touch main.c
```

Check status:

```bash
git status
```

Stage file:

```bash
git add main.c
```

Commit:

```bash
git commit -m "Initial commit"
```



##  Exercise 1 – Observe the Three Areas

1. Create file
2. Modify it
3. Run `git status`
4. Run `git add`
5. Run `git status`
6. Commit
7. Run `git log`

Explain how file moves through:

Working → Staging → Repository.



# Internal Structure of `.git/`

Look inside:

```bash
ls .git
```

Important files:

```
.git/
  HEAD
  index
  objects/
  refs/
```

More specifically:

```
.git/
  HEAD
  refs/
    heads/
      main
      feature
```



# What Is a Commit?

Each commit:

* Snapshot of project
* Parent commit reference
* Author info
* Message
* SHA hash

Visual example:

```
A → B → C
```

Each letter is a commit node.

Check:

```bash
git log --oneline --graph
```

Git stores commits inside:

```
.git/objects/
```



# What Is HEAD?

Open:

```bash
cat .git/HEAD
```

Usually:

```
ref: refs/heads/main
```

Meaning:

HEAD → main → latest commit.

HEAD is simply:

> A pointer to current branch.



#  What Is a Branch?

A branch is:

> A named pointer to a commit.

Check:

```bash
cat .git/refs/heads/main
```

You’ll see a commit hash.

Example:

```
main → 8a7c91...
```

If you create:

```bash
git branch feature
```

Internally:

```
feature → same_commit_hash
```

So branching does NOT copy code.

It just creates another pointer.

This is why:

> Branches are lightweight.



## Visual Example

After 3 commits:

```
A → B → C
           ↑
         main
           ↑
          HEAD
```

Create branch:

```
feature → C
main → C
HEAD → main
```

Commit on feature:

```
A → B → C → D
               ↑
            feature
main → C
HEAD → feature
```

Branches diverge.



##  Exercise 2 – Observe Pointer Movement

1. Make 2 commits on main
2. Create branch `experiment`
3. Commit on experiment
4. Switch back to main
5. Run:

```bash
git log --oneline --graph --all
```

Explain structure.



# Merging

Switch to main:

```bash
git switch main
```

Merge:

```bash
git merge experiment
```

If histories diverged, Git creates a merge commit.

Graph:

```
      D
     /
A → B → C → E
```

Commit E has two parents.



#  Merge Conflicts

Occurs when:

* Same lines modified differently.

Git inserts:

```
<<<<<<< HEAD
...
=======
...
>>>>>>> branch
```

Resolve manually.

Then:

```bash
git add .
git commit
```



##  Exercise 3 – Force Conflict

1. Change same line in two branches
2. Merge
3. Resolve
4. Inspect commit graph



# Connecting to GitHub

Create repo on GitHub.

Then link:

```bash
git remote add origin <url>
git branch -M main
git push -u origin main
```

Push changes:

```bash
git push
```

Pull changes:

```bash
git pull
```

Remote = another Git repository.



# .gitignore

Prevent tracking unwanted files.

Example:

```
*.o
build/
*.log
```

Commit early.



# Undoing Work

Safe undo:

```bash
git revert HEAD
```

Dangerous rewrite:

```bash
git reset --hard HEAD~1
```

Remember:

Reset moves branch pointer.

Revert creates new commit.



# GitHub Workflow

Standard team workflow:

1. Create feature branch
2. Commit locally
3. Push branch
4. Open Pull Request
5. Review
6. Merge

Do not push unfinished work to main.








