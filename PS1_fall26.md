## Problem Session 1

---

# 1. What Is an Operating System?

<img width="177" height="258" alt="Operating system overview" src="https://github.com/user-attachments/assets/20947392-f440-46d6-8d7c-1fff8012eb50" />

An **Operating System (OS)** sits between applications and the computer's hardware.

Its main responsibilities include:

- Managing hardware resources
- Managing memory
- Scheduling processes
- Managing files and devices
- Providing services to programs
- Enforcing protection and access control

Examples:

- Windows
- macOS
- Ubuntu / Linux
- Android

### Important perspective

The operating system is **not the graphical interface** you interact with.

A useful mental model is:

> **OS = resource manager + execution environment**

It decides which programs run, what resources they can access, and how they interact with hardware.

---

# 2. The Kernel

<img width="244" height="235" alt="Kernel overview" src="https://github.com/user-attachments/assets/8b50b992-477a-4fe6-b074-c778c1d8c275" />

The **kernel** is the core privileged component of the operating system.

It is responsible for tasks such as:

- Process scheduling
- Memory management
- System call handling
- File-system operations
- Device management
- Inter-process communication

Suppose you type:

```bash
ls
```

A simplified execution sequence is:

1. The shell parses the command.
2. The shell creates a new process, typically using `fork()`.
3. The child process calls an `exec` function such as `execve()`.
4. The kernel loads the `ls` executable into memory.
5. The kernel schedules the process on the CPU.
6. `ls` writes its output to standard output.
7. When `ls` terminates, the shell displays another prompt.

The important idea is:

> User programs request services from the kernel through **system calls**.

---

# 3. The Shell

The **shell** is a command-line interpreter.

Common shells include:

```text
bash
zsh
fish
```

The shell:

- Reads and parses commands
- Expands variables and wildcards
- Resolves executable paths
- Handles redirections
- Creates pipelines
- Starts and manages processes

For example:

```bash
ls *.txt
```

The shell normally expands `*.txt` **before** starting `ls`.

Not every shell command is a separate executable.

For example:

```bash
cd
```

is usually a **shell builtin**.

It has to be: changing directory must modify the working directory of the shell itself.

---

# 4. The File System: A Hierarchical Namespace

Unix-like file systems are organized as a tree starting at:

```text
/
```

<img width="368" height="185" alt="Linux filesystem hierarchy" src="https://github.com/user-attachments/assets/3e7b6164-bf70-45a0-a367-5f96b6eeae16" />

Some important directories are:

| Directory | Typical purpose |
|---|---|
| `/bin` | Essential commands |
| `/usr` | User-space programs and libraries |
| `/etc` | System configuration |
| `/home` | User home directories |
| `/proc` | Kernel/process information |
| `/dev` | Device files |
| `/tmp` | Temporary files |

A **path** identifies a location in this hierarchy.

Examples:

```text
/home/student/file.txt
/etc/passwd
../data/input.txt
```

The kernel resolves path components through the file-system namespace until it reaches the corresponding file object.

---

# 5. Navigating the File System

Special path components:

| Symbol | Meaning |
|---|---|
| `.` | Current directory |
| `..` | Parent directory |
| `~` | User's home directory, expanded by the shell |

Examples:

```bash
pwd
cd ..
cd ~
```

`pwd` prints the current working directory.

### Why is `cd` special?

```bash
cd ..
```

does **not** normally create a new process.

Instead, the shell changes its own current working directory.

If `cd` were executed in a child process, the parent shell would remain in the old directory.

---

# 6. Creating Directories

Create one directory:

```bash
mkdir directory
```

Create an entire directory hierarchy:

```bash
mkdir -p ~/cmpe230/ps1
```

The `-p` option:

- Creates missing parent directories
- Does not report an error if the directory already exists

---

# 7. Creating, Copying, and Moving Files

Create an empty file:

```bash
touch file.txt
```

Copy a file:

```bash
cp file.txt copy.txt
```

Move a file:

```bash
mv file.txt directory/
```

Rename a file:

```bash
mv file.txt renamed.txt
```

In Unix, **moving and renaming are closely related operations**.

---

# 8. Viewing File Contents

Display an entire file:

```bash
cat file.txt
```

Display the first 5 lines:

```bash
head -n 5 file.txt
```

Display the last 10 lines:

```bash
tail -n 10 file.txt
```

Follow a growing file:

```bash
tail -f log.txt
```

`tail -f` is particularly useful for:

- Monitoring logs
- Debugging running services
- Watching continuously generated output

---

# 9. Deleting Files and Directories

Delete a file:

```bash
rm file.txt
```

Delete a directory recursively:

```bash
rm -r directory/
```

Force recursive deletion:

```bash
rm -rf directory/
```

Be careful with:

```bash
rm -rf
```

because:

- `-r` means **recursive**
- `-f` means **force**
- Files are normally deleted immediately from the command line
- There is generally no shell-level recycle bin

Conceptually, removing a file removes a directory entry referencing that file's inode. The underlying storage is reclaimed when no references to the file remain.

### Removing an empty directory

```bash
rmdir directory/
```

`rmdir` succeeds only when the directory is empty.

---

# 10. Wildcards and Shell Expansion

Examples:

```bash
ls *.txt
ls ?ouse
```

Common wildcard patterns:

| Pattern | Meaning |
|---|---|
| `*` | Zero or more characters |
| `?` | Exactly one character |

Suppose the directory contains:

```text
file1.txt
file2.txt
notes.pdf
```

When you type:

```bash
ls *.txt
```

the shell may expand it to:

```bash
ls file1.txt file2.txt
```

before `ls` starts.

Therefore:

> Wildcard expansion is normally performed by the **shell**, not by `ls`.

---

# 11. Long Listings and Permissions

Use:

```bash
ls -l
```

You may see something like:

```text
-rwxrwxr-x
```

Break it into:

```text
- rwx rwx r-x
│ │   │   │
│ │   │   └── others
│ │   └────── group
│ └────────── owner
└──────────── file type
```

Permission symbols:

| Permission | Meaning | Numeric value |
|---|---|---:|
| `r` | read | 4 |
| `w` | write | 2 |
| `x` | execute | 1 |

---

# 12. Octal Permission Encoding

Consider:

```text
rw- r-- r-x
```

Convert each group independently:

```text
rw- = 4 + 2     = 6
r-- = 4         = 4
r-x = 4 + 1     = 5
```

Therefore:

```text
645
```

Set the permissions with:

```bash
chmod 645 file
```

Another example:

```text
rwx r-x ---
 7   5   0
```

gives:

```bash
chmod 750 file
```

---

# 13. Directory Permissions Are Different

Permissions have slightly different meanings for directories.

For a directory:

| Permission | Meaning |
|---|---|
| `r` | List directory entries |
| `w` | Create/delete/rename entries |
| `x` | Traverse/access entries inside the directory |

The execute bit is especially important.

For example, having read permission without execute permission may allow you to see directory entry names but prevent normal access to the files inside.

A useful rule is:

> For directories, `x` means **traversal permission**.

---

# 14. Changing Permissions

Symbolic mode:

```bash
chmod u+rw file
chmod g-rwx file
chmod go=r file
```

Symbols:

| Symbol | Meaning |
|---|---|
| `u` | user / owner |
| `g` | group |
| `o` | others |
| `a` | all |

Recursive permission change:

```bash
chmod -R 700 PS2/
```

Normally, the file owner or a sufficiently privileged user can change its permissions.

Use recursive permission changes carefully.

---

# 15. Hard Links and Symbolic Links

## Hard link

```bash
ln original.txt hardlink.txt
```

A hard link creates another directory entry referring to the **same inode**.

Therefore:

```text
original.txt ─┐
              ├──> same inode → same file data
hardlink.txt ─┘
```

Removing one name does not remove the file as long as another hard link still exists.

## Symbolic link

```bash
ln -s original.txt link.txt
```

A symbolic link stores a path to another file.

```text
link.txt → original.txt
```

If the target is removed:

```text
link.txt → missing target
```

the symbolic link becomes **dangling**.

---

# 16. Standard Streams

A Unix process normally starts with three standard file descriptors:

| FD | Stream | Meaning |
|---:|---|---|
| `0` | stdin | Standard input |
| `1` | stdout | Standard output |
| `2` | stderr | Standard error |

Example:

```bash
command > output.txt
```

redirects stdout.

Append instead of overwrite:

```bash
command >> output.txt
```

Redirect stderr:

```bash
command 2> error.log
```

Redirect both stdout and stderr in Bash:

```bash
command &> combined.log
```

Redirection is fundamentally:

> **Changing where a process's file descriptors point.**

---

# 17. Pipes: Combining Programs

Example:

```bash
ls | wc -l
```

Conceptually:

```text
ls stdout
    |
    v
 kernel pipe
    |
    v
wc stdin
```

The standard output of `ls` becomes the standard input of `wc`.

The processes:

- Are separate processes
- Can run concurrently
- Communicate through a kernel-managed pipe

This leads to a central Unix philosophy:

> Build small programs that can be composed together.

---

# 18. A More Useful Pipeline

Suppose `access.log` contains:

```text
192.168.1.5 GET /index.html
10.0.0.2 GET /login
192.168.1.5 GET /about
```

To count requests by IP address:

```bash
awk '{print $1}' access.log | sort | uniq -c | sort -nr
```

Step by step:

```text
access.log
    ↓
awk
Extract first column
    ↓
sort
Place identical values together
    ↓
uniq -c
Count consecutive duplicates
    ↓
sort -nr
Sort counts numerically, largest first
```

Order matters.

In particular:

> `uniq` counts **adjacent** repeated lines, so its input is often sorted first.

---

# 19. Process Management

Show processes associated with the current terminal:

```bash
ps
```

Show a broader process listing:

```bash
ps -ef
```

or:

```bash
ps aux
```

Important information includes:

- PID
- User
- CPU usage
- Memory usage
- Command

A **PID** is a process identifier.

Send a termination signal:

```bash
kill <pid>
```

For example:

```bash
kill 12345
```

By default, `kill` normally sends `SIGTERM`, giving the process an opportunity to terminate cleanly.

---

# 20. Foreground and Background Processes

Normally:

```bash
sleep 300
```

runs in the **foreground**, so the shell waits until it terminates.

Start directly in the background with:

```bash
sleep 300 &
```

The shell prompt returns immediately.

## Move a foreground job to the background

While a foreground command is running:

```text
Ctrl+Z
```

suspends it.

Then run:

```bash
bg
```

to continue it in the background.

```text
foreground
   ↓ Ctrl+Z
suspended
   ↓ bg
background
```

## Move a background job to the foreground

List jobs:

```bash
jobs
```

Then bring one to the foreground:

```bash
fg %1
```

where `%1` is the job number shown by `jobs`.

For longer-running commands:

```bash
nohup command &
```

helps a command survive terminal hangup.

```bash
screen -S session
```

creates a detachable terminal session that can later be reattached.

---

# 21. Disk Usage

Show filesystem-level disk usage:

```bash
df -h
```

Show space used by files under directories:

```bash
du -sh *
```

The distinction is important:

### `df`

Reports filesystem allocation:

```text
How much space does the filesystem think is used/free?
```

### `du`

Walks through the directory tree and totals file usage:

```text
How much space is used by these reachable files/directories?
```

Therefore, `df` and `du` can sometimes report different numbers.

---

# 22. Searching for Files

Search recursively by name:

```bash
find . -name "*.out"
```

Find files with exact mode `777`:

```bash
find . -perm 777
```

Find files modified more than 7 days ago:

```bash
find . -mtime +7
```

Run a command on matching files:

```bash
find . -exec chmod a+x {} \;
```

Here:

```text
{}
```

is replaced with the current matching path.

`find` is powerful because it combines:

> **filesystem traversal + filtering + actions**

---

# 23. Connecting the File and Process Models

A major Unix idea is that many OS-managed resources, such as files, devices, pipes, sockets, and terminals, can be accessed through file-like interfaces.

Examples:

```text
/dev   → devices
/proc  → process and kernel information
files  → persistent data
pipes  → communication between processes
```

This is why file descriptors are so central to systems programming.
Many Unix I/O resources are represented to a process by file descriptors.

Programs can often use the same operations:

```text
open
read
write
close
```

on very different kinds of resources.

A useful perspective is:

> **Systems programming is largely about controlling processes, memory, files, and communication between them.**

---

# 24. A Real Debugging Scenario

Suppose a server suddenly becomes very slow.

Start by checking processes:

```bash
ps aux --sort=-%cpu
```

Then memory:

```bash
free -h
```

Then filesystem capacity:

```bash
df -h
```

Then large directories:

```bash
du -sh *
```

Possible questions:

1. Is one process consuming the CPU?
2. Is the machine running out of memory?
3. Is the filesystem full?
4. Did a log or output directory grow unexpectedly?

The important skill is not memorizing commands.

It is learning how to use simple tools to **form and test hypotheses about the system**.

---

# Summary

- Understand the basics of OS, kernel, and shell
- Navigate and manage files
- Work with permissions and links
- Use streams, redirection, and pipes
- Manage processes and background jobs
- Monitor system resources

The central ideas are:

> **Files provide a common interface to resources.**

> **Processes are running programs managed by the kernel.**

> **The shell connects small programs into larger workflows.**
