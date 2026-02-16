
# Problem Session 2 

# From Personal Machine to Multi-User System

Until now:

You were acting as a regular user.

Today:

> We analyze Linux as a multi-user, privilege-separated system.



# The Superuser (root)

Linux is privilege-separated.

There exists a special user:

```
root
```

UID of root:

```
0
```

UID=0 bypasses permission checks.



## Why root exists

Some operations require system-level authority:

* Install software
* Mount disks
* Create users
* Modify `/etc`
* Bind privileged ports (<1024)

Without separation:

System becomes insecure.



## Switching Users

### Temporary privilege elevation

```bash
sudo command
```

* Runs a single command as root
* Requires password
* Logged in `/var/log/auth.log`



### Switching to full root shell

```bash
sudo -i
```

or

```bash
su -
```

Difference:

* `sudo` uses your password
* `su` requires root password



## Check your identity

```bash
whoami
id
```

`id` shows:

* UID
* GID
* Supplementary groups



### Exercise

1. Run `id`
2. Identify your primary group
3. What changes after `sudo -i`?



# Users & Groups

Linux is multi-user by design.

User information stored in:

```
/etc/passwd
/etc/shadow
/etc/group
```



## Viewing users

```bash
cat /etc/passwd
```

Structure:

```
username:x:UID:GID:comment:home:shell
```

Example:

```
gokce:x:1001:1001::/home/gokce:/bin/bash
```



## Creating a User

```bash
sudo adduser alice
```

This:

* Creates home directory
* Sets password
* Adds group with same name



## Creating a Group

```bash
sudo groupadd developers
```

Add user to group:

```bash
sudo usermod -aG developers alice
```

Important:

`-a` must be present or groups are overwritten.



## Changing Ownership

```bash
chown alice file.txt
chown alice:developers file.txt
```

Recursive:

```bash
chown -R alice project/
```



### Exercise

1. Create a user `ps2test`
2. Create group `cmpe230`
3. Add user to group
4. Verify with `id ps2test`



# Package Management

Linux distributions manage software via package managers.

Ubuntu/Debian:

```
apt
apt-get
```

RedHat/CentOS:

```
yum
rpm
```



## Installing packages

```bash
sudo apt update
sudo apt install htop
```



## Removing packages

```bash
sudo apt remove htop
```



## Searching packages

```bash
apt search ssh
```



## RPM-based systems

Install:

```bash
sudo yum install package
```

Manual rpm:

```bash
sudo rpm -i file.rpm
```



### Exercise

1. Install `tree`
2. Find where it is installed (`which tree`)
3. Remove it



# Mounting File Systems

Linux does NOT automatically access all storage devices.

It attaches devices into directory tree.

Concept:

> Mounting = Attaching a filesystem to a directory.



## Viewing mounted systems

```bash
mount
```

More readable:

```bash
lsblk
```



## Mount manually

```bash
sudo mount /dev/sdb1 /mnt
```

Unmount:

```bash
sudo umount /mnt
```



Important:

Mount point must exist.

Create if needed:

```bash
sudo mkdir /mnt/usb
```



## `/etc/fstab`

Defines permanent mounts.

Example:

```
UUID=xxxx /data ext4 defaults 0 2
```



### Exercise

1. Run `lsblk`
2. Identify root partition
3. Explain why `/` is already mounted



# SSH – Secure Shell

SSH allows remote login.

```bash
ssh user@server_ip
```

Default port:

```
22
```



## Copy files

Using secure file transfer:

```bash
scp file.txt user@server:/home/user/
```

Or interactive:

```bash
sftp user@server
```



## SSH Keys

Generate key:

```bash
ssh-keygen
```

Copy public key:

```bash
ssh-copy-id user@server
```

Enables passwordless login.



### Exercise

1. Generate SSH key
2. Inspect `~/.ssh`
3. Explain difference between id_rsa and id_rsa.pub



# Disk Compression & Archiving



## gzip / gunzip

```bash
gzip file.txt
gunzip file.txt.gz
```

Note:

Replaces original file.



## tar – Archiving

Create archive:

```bash
tar -cvf archive.tar folder/
```

Extract:

```bash
tar -xvf archive.tar
```

Compressed archive:

```bash
tar -czvf archive.tar.gz folder/
```



### Exercise

1. Create folder with files
2. Archive it
3. Compress it
4. Extract to new location



# Process Signals & Control



## `kill`

```bash
kill -9 <pid>
```

Signal 9 = SIGKILL (force)

Graceful termination:

```bash
kill -15 <pid>
```



## View process history

```bash
history
```

Clear:

```bash
clear
```



## Who is logged in?

```bash
w
who
last
finger username
```



### Exercise

1. Open two terminals
2. Run `w`
3. Identify both sessions



# Environment Variables

```bash
export PATH=/custom/bin:$PATH
```

View variables:

```bash
env
```

Permanent config:

```
~/.bashrc
```

`source ~/.bashrc`

Reloads current shell.



### Exercise

1. Create variable `CMPE=230`
2. Echo it
3. Open new shell
4. Why is it gone?



# CPU & System Info

```bash
lscpu
free -h
uptime
```



## Network Diagnostics

```bash
ping google.com
nslookup google.com
wget https://example.com
```



###  Exercise

1. Use `ping`
2. Stop with Ctrl+C
3. Measure packets sent/received



# Make & Compilation

Used to automate builds.

```bash
make
```

Needs:

```
Makefile
```

Compile manually:

```bash
gcc file.c -o program
g++ main.cpp -o app
```

`ar` builds static libraries.



# Directory Stack

```bash
pushd dir1
pushd dir2
popd
dirs
```

Acts like navigation stack.

Unlike `cd`, it stores history.



# System-Level View Integration

By now you can:

* Create users
* Control privileges
* Install software
* Mount devices
* Remote into systems
* Manage packages
* Compress archives
* Inspect sessions
* Analyze CPU/network

You are operating as:

> A junior system administrator.



