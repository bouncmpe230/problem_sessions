# Problem Session 2 - Dockers

# Full System Stack (From Hardware to Containers)

```
+-------------------------------------------------------+
|                     USER SPACE                        |
|-------------------------------------------------------|
|   Applications   |   Docker CLI   |   Shell (bash)   |
+-------------------------------------------------------+
|                     DOCKER ENGINE                    |
|-------------------------------------------------------|
|   Container Runtime (runc / containerd)              |
+-------------------------------------------------------+
|                       KERNEL                          |
|-------------------------------------------------------|
| Process Mgmt | Memory Mgmt | VFS | Network | IPC     |
| Namespaces   | cgroups     | Syscalls                 |
+-------------------------------------------------------+
|                     HARDWARE                          |
|-------------------------------------------------------|
| CPU | RAM | Disk | Network Card | Devices             |
+-------------------------------------------------------+
```


# Operating System View

```
+------------------------------------------+
|               Applications               |
+------------------------------------------+
|              System Call API             |
|------------------------------------------|
| fork | exec | read | write | open | mmap|
+------------------------------------------+
|                 KERNEL                   |
|------------------------------------------|
|  Scheduler  |  Memory  |  VFS  |  Net   |
+------------------------------------------+
|                Hardware                  |
+------------------------------------------+
```

Important:

Applications NEVER access hardware directly.

They use:

```
Application → syscall → kernel → hardware
```


# 3️⃣ File System Structure

```
                    /
                    |
     ---------------------------------
     |       |        |       |      |
    /bin    /home    /etc    /usr   /dev
     |
   [ls]
```

Internally:

```
Path → Inode → Data Blocks
```

Kernel handles VFS (Virtual File System):

```
open("/home/x/file.txt")
           ↓
        inode lookup
           ↓
        disk blocks
```





# Everything Is a File (Kernel View)

Inside Linux:

```
/dev/sda     → Disk
/dev/tty     → Terminal
/proc/1234   → Process info
/sys         → Kernel settings
```

Even containers are just:

```
Isolated processes + file descriptors
```


# Concept Summary Diagram

```
        +------------------------------+
        |        APPLICATIONS          |
        +------------------------------+
        |         DOCKER ENGINE        |
        +------------------------------+
        |            KERNEL            |
        +------------------------------+
        |           HARDWARE           |
        +------------------------------+
```

Containers = kernel feature usage.
They are NOT mini operating systems.



# Containers, Isolation & Dev Environments



# Why Containers?

Problem:

* “It works on my machine”
* Different compilers
* Different library versions
* Broken dependencies
* Root access conflicts

Solution:

> Encapsulate environment + filesystem + dependencies.



# What Is a Container?

A container is:

> A process running with isolated namespaces + limited resources.

It is NOT:

* A virtual machine
* A separate kernel

Containers share:

* Host kernel

They isolate:

* Filesystem
* PID namespace
* Network stack
* User space



# VM vs Container

| Virtual Machine | Container      |
|  | -- |
| Full OS         | Shared kernel  |
| Heavy           | Lightweight    |
| Minutes to boot | Milliseconds   |
| More isolation  | Less isolation |



# Docker Architecture

Components:

* Docker client
* Docker daemon
* Docker image
* Docker container
* Registry (DockerHub)

Flow:

```
docker run → daemon → create container → start process
```



# Installing Docker (Conceptual)

On Ubuntu:

```bash
sudo apt update
sudo apt install docker.io
```

Start service:

```bash
sudo systemctl start docker
```

Check:

```bash
docker --version
```



# Your First Container

```bash
docker run hello-world
```

What happened?

1. Image searched locally
2. Not found
3. Pulled from DockerHub
4. Container created
5. Process executed
6. Container exited

Container = process lifecycle.



# Interactive Container

```bash
docker run -it ubuntu bash
```

* `-i` interactive
* `-t` pseudo-TTY

Now you are inside isolated filesystem.

Check:

```bash
ls /
```

Different from host.



# Container Internals

Check running containers:

```bash
docker ps
```

All containers:

```bash
docker ps -a
```

Stop container:

```bash
docker stop <id>
```

Remove:

```bash
docker rm <id>
```



# Images vs Containers

Image:

* Immutable
* Read-only layers

Container:

* Writable layer on top

Diagram:

```
Image Layer 1
Image Layer 2
Image Layer 3

Container writable layer
```

Delete container → writable layer gone.

#  Docker Architecture in Context

```
Host Machine
---------------------------------------------------------
|                                                       |
|  Kernel (shared)                                      |
|  ---------------------------------------------------  |
|  Namespace + cgroups isolate processes               |
|                                                       |
|     +--------------------+                           |
|     |  Container A       |                           |
|     |--------------------|                           |
|     |  App               |                           |
|     |  FS Layer          |                           |
|     +--------------------+                           |
|                                                       |
|     +--------------------+                           |
|     |  Container B       |                           |
|     |--------------------|                           |
|     |  App               |                           |
|     |  FS Layer          |                           |
|     +--------------------+                           |
|                                                       |
---------------------------------------------------------
```

Containers share:

* Same kernel

They isolate:

* Processes (PID namespace)
* Filesystem (mount namespace)
* Network (net namespace)
* CPU/memory (cgroups)



# Persistent Data – Volumes

Without volume:

Everything disappears.

Example:

```bash
docker run -it ubuntu bash
touch test.txt
exit
docker run -it ubuntu bash
```

File is gone.



Mount host directory:

```bash
docker run -it -v $(pwd):/work ubuntu bash
```

Now:

Host folder ↔ Container folder



# Port Mapping

Run web server:

```bash
docker run -p 8080:80 nginx
```

Meaning:

```
host:8080 → container:80
```

Because container network is isolated.



# Container as Process

Run:

```bash
docker run -d nginx
```

Check processes:

```bash
ps aux | grep nginx
```

You will see docker-managed process.

Containers are processes with cgroups + namespaces.



# Dockerfile – Infrastructure as Code

Instead of manual setup:

```dockerfile
FROM ubuntu:22.04
RUN apt update
RUN apt install -y gcc make
WORKDIR /app
COPY . /app
CMD ["bash"]
```

Build:

```bash
docker build -t cmpe230_env .
```

Run:

```bash
docker run -it cmpe230_env
```

Now environment is reproducible.



# Dev Containers (VS Code)

Dev containers allow:

> Opening a project inside a container automatically.

Structure:

```
.devcontainer/
  devcontainer.json
  Dockerfile
```



# Example devcontainer.json

```json
{
  "name": "cmpe230_env",
  "build": {
    "dockerfile": "Dockerfile"
  },
  "remoteUser": "vscode"
}
```

VS Code:

* Builds container
* Mounts project inside
* Opens shell
* Uses container tools



# Why Dev Containers?

For teaching:

* All students identical environment
* No dependency chaos
* Safe execution
* Isolated experiments

For industry:

* Reproducible CI/CD
* Clean builds
* Environment versioning



# Isolation Deep Dive (Systems View)

Containers use:

* Namespaces:

  * PID namespace
  * Mount namespace
  * Network namespace
  * UTS namespace
  * IPC namespace

* cgroups:

  * CPU limiting
  * Memory limiting

Example limit memory:

```bash
docker run -m 256m ubuntu
```



# Security Perspective

Container escape is dangerous.

Therefore:

* Never run containers as root in production.
* Use minimal base images.
* Scan images.



# Quick Hands-On PS Tasks

### Task 1 – Process Isolation

1. Run:

```bash
docker run -it ubuntu bash
```

2. Inside container:

```bash
ps aux
```

Observe:

Only few processes exist.

Why?

Because PID namespace is isolated.



### Task 2 – Filesystem Isolation

1. Inside container:

```bash
touch inside.txt
```

2. Exit.
3. Check host.

File does not exist.



### Task 3 – Volume Mapping

```bash
docker run -it -v $(pwd):/shared ubuntu bash
```

Create file in `/shared`.

Verify it appears on host.



### Task 4 – Networking

Run:

```bash
docker run -p 9090:80 nginx
```

Visit:

```
http://localhost:9090
```

Explain mapping.



### Task 5 – Build Custom Image

Create minimal Dockerfile installing `tree`.

Build it.

Run container and verify.



# Debugging Containers

Inspect:

```bash
docker logs <id>
docker inspect <id>
docker exec -it <id> bash
```

These commands attach to running container.



# Cleaning Up

Remove stopped containers:

```bash
docker container prune
```

Remove unused images:

```bash
docker image prune
```



# System Programming Connection

* Container = Process
* Image = Read-only filesystem layers
* Volume = Bind mount
* Port mapping = Network namespace bridging
* Dev container = Automated container orchestration


**Containers are kernel features packaged with tooling.**



# Summary

* Containers are isolated processes
* Docker architecture
* Images vs containers
* Persistent storage
* Port mapping
* Dockerfile basics
* Dev containers workflow
* Namespaces & cgroups

