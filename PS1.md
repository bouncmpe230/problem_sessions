
# CMPE 230 – Systems Programming

# Problem Session 1




# What Is an Operating System?


<img width="177" height="258" alt="Screenshot 2026-02-16 at 14 55 18" src="https://github.com/user-attachments/assets/20947392-f440-46d6-8d7c-1fff8012eb50" />


An Operating System:

* Manages hardware
* Allocates memory
* Schedules processes
* Provides services to programs

Examples:

* Windows
* macOS (Unix-based)
* Ubuntu (Unix-based)
* Android (Unix-based)

Important perspective:

The OS is not the UI.

It is:

> A resource manager + execution controller.





# The Kernel
<img width="244" height="235" alt="Screenshot 2026-02-16 at 14 56 10" src="https://github.com/user-attachments/assets/8b50b992-477a-4fe6-b074-c778c1d8c275" />



Kernel responsibilities:

* Process scheduling
* Memory management
* System call handling
* File system management

When you type:

```bash
ls
```

Internally:

1. Shell calls `fork()`
2. Child calls `execve()`
3. Kernel loads `/bin/ls`
4. Kernel schedules process
5. Output returned via stdout

The shell does not execute programs.

It asks the kernel to.





# The Shell: Process Manager

Shell = Command Line Interpreter

It:

* Parses commands
* Expands wildcards
* Resolves paths
* Handles redirections
* Starts processes


> Every command is a program.

After termination, the shell regains control.





# File System as a Hierarchical Namespace


Linux directory structure begins at:

```
/
```

<img width="368" height="185" alt="Screenshot 2026-02-16 at 14 56 41" src="https://github.com/user-attachments/assets/3e7b6164-bf70-45a0-a367-5f96b6eeae16" />




Key directories:

* `/bin`
* `/usr`
* `/etc`
* `/home`
* `/proc`
* `/dev`

Important concept:

Paths are just strings.

The kernel resolves them to **inodes**.





# Navigation = Pointer Movement

Special symbols:

| Symbol | Meaning           |
|  | -- |
| `.`    | current directory |
| `..`   | parent directory  |
| `~`    | home directory    |

Examples:

```bash
cd ..
cd ~
pwd
```

Critical detail:

`cd` does NOT start a new process.

It modifies the shell's internal working directory.





# Creating Directories Efficiently


Single command solution:

```bash
mkdir -p ~/cmpe230/ps1
```

`-p` prevents errors if parents already exist.






# File Creation & Movement

```bash
touch file.txt
cp file.txt copy.txt
mv file.txt directory/
mv file.txt renamed.txt
```





# Viewing File Content

```bash
cat file.txt
head -n 5 file.txt
tail -n 10 file.txt
tail -f log.txt
```

`tail -f` attaches to a growing file.

Used for:

* Monitoring
* Debugging
* Server logs





# File Deletion & Risk

```bash
rm file.txt
rm -r directory/
rm -rf directory/
```

Key danger:

* `-rf` ignores prompts
* Recursive deletion

There is no recycle bin.

Deletion removes directory references to inode.

# Directory Deletion 

```bash
rmdir directory/
```
The directory needs to be empty. 

# Wildcards & Expansion


```bash
ls *.txt
ls ?ouse
```

Important:

Wildcard expansion is done by:

> The shell, not the program.

`ls *.txt`

Shell expands to:

```
ls file1.txt file2.txt
```





# Long Listing & Permissions

```bash
ls -l
```

Example:

```
-rwxrwxr-x
```

Structure:

```
[type][owner][group][others]
```

Where:

* r = 4
* w = 2
* x = 1





# Octal Logic


Example:

```
rw- r-- r-x
```

Binary:

```
110 100 101
```

Octal:

```
645
```

Command:

```bash
chmod 645 file
```

This is numerical permission encoding.





# Directory Permissions Are Different

Critical concept:

Execute bit on directory means:

> Traversal permission

Example:

```
drw-
```

Owner can read/write.

But cannot `cd` into it.

Because no execute bit.





# Changing Permissions

Symbolic mode:

```bash
chmod u+rw file
chmod g-rwx file
chmod go=r file
```

Recursive:

```bash
chmod -R 700 PS2/
```

Only owner can use chmod.





# Hard vs Soft Links


Hard link:

* Points to same inode
* Same file content

Soft link:

```bash
ln -s original.txt link.txt
```

* Points to filename
* Breaks if target removed

`.` and `..` are hard links.





# Standard Streams

| FD | Meaning |
| -- | - |
| 0  | stdin   |
| 1  | stdout  |
| 2  | stderr  |

Examples:

```bash
command > file
command >> file
command 2> error.log
command &> combined.log
```

Redirection is descriptor manipulation.





# Pipes as Composition

Example:

```bash
ls | wc -l
```

Meaning:

* stdout of ls
* becomes stdin of wc

Each process:

* Is independent
* Runs concurrently
* Communicates via kernel pipe buffer





# Grep + Sort + Count Pipeline

Example:

```bash
awk '{print $1}' access.log | sort | uniq -c | sort -nr
```

Stages:

1. Extract column
2. Sort for grouping
3. Count unique
4. Sort numerically descending

Order matters.

`uniq` requires sorted input.





# Process Management


```bash
ps
ps -ef
ps -u
```

Important fields:

* PID
* CPU %
* MEM %
* Command

Terminate:

```bash
kill <pid>
```





# Background Processes


```bash
sleep 300 &
```

`&`:

* Non-blocking execution
* Shell prompt returns immediately

Problem:

Process dies when terminal closes.

Solution:

```bash
nohup command &
screen -S session
```





# Disk Usage

```bash
df -h
du -sh *
```

Difference:

* `df` checks filesystem blocks
* `du` traverses directories

One is metadata-based.
One reads actual file sizes.





# File Searching


```bash
find . -name "*.out"
find . -perm 777
find . -mtime +7
find . -exec chmod a+x {} \;
```

`find` is recursive and powerful.

It traverses filesystem tree programmatically.





# Process & File Model Connection

Key realization:

Everything is a file:

* Devices → `/dev`
* Process info → `/proc`
* Logs → Files
* Directories → Special files

System programming = manipulating files + processes safely.





# Real Systems Debugging Scenario

Server slow.

You must check:

```bash
ps aux --sort=-%cpu
free -h
df -h
du -sh *
```

Reason in correct order:

1. CPU bottleneck?
2. Memory swapping?
3. Disk full?
4. Log explosion?





# Summary


* Navigated filesystem
* Managed directory structure
* Understood permission encoding
* Manipulated links
* Controlled processes
* Used background execution
* Inspected system resources
* Composed pipes



