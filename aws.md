# Problem Session 

# AWS EC2 – Cloud Infrastructure & Remote Computing



# 1️⃣ Why Cloud?

From your original slides (page 2): Cloud is **cost-effective and scalable** 

Instead of buying:

* GPU → $6000
* Dedicated server
* Maintenance

You rent:

* Virtual machine by the hour
* CPU / RAM / disk dynamically

Cloud = On-demand infrastructure.



# 2️⃣ What Is AWS?

AWS (Amazon Web Services):

* Launched 2006
* Millions of customers
* Global infrastructure
* Market leader (as shown in your slide image on page 3) 

We will focus on:

> EC2 (Elastic Compute Cloud)



# 3️⃣ What Is EC2?

From your slide (page 7) 

EC2 = Virtual server in the cloud.

When you launch EC2, you choose:

* OS (Amazon Linux / Ubuntu)
* CPU / RAM
* Disk size
* Network configuration
* Security rules

Think of EC2 as:

> A remote Linux machine accessible over SSH.



# 4️⃣ EC2 Is Just a Virtual Machine

Internally:

```
Physical AWS server
    ↓
Hypervisor
    ↓
Your EC2 Instance
```

You share hardware safely via virtualization.

Similar to:

* VirtualBox
* VMware

But at massive scale.



# 5️⃣ Free Tier & Cost Awareness

From slide (page 6) 

Free Tier:

* 750 hours / month (t2.micro / t3.micro)
* 5GB S3
* Limited storage

Important:

If you forget to terminate instance → you may pay.

Always:

Stop or terminate after PS.



# 6️⃣ Launching EC2 (Guided)

Based on your screenshots (pages 10–15) 

### Step 1 — Launch Instance

Console → EC2 → Launch Virtual Machine

(page 10 screenshot)



### Step 2 — Choose AMI (Operating System)

From page 11: choose **Amazon Linux (Free tier eligible)** 

An AMI (Amazon Machine Image):

= Prebuilt OS template.



### Step 3 — Choose Instance Type

From page 12: t3.micro (Free tier eligible) 

Defines:

* vCPU
* RAM
* Network performance



### Step 4 — Create Key Pair

From pages 13–14 

Create:

* RSA
* .pem file

Download and store safely.

This key allows SSH login.

There are no passwords.



### Step 5 — Launch

From page 15 

Launch instance.

Wait until:

State → Running.



# 7️⃣ Security Groups (Critical Concept)

Security Group = Cloud Firewall.

Controls:

* Which ports are accessible
* From which IP addresses

Common ports:

* 22 → SSH
* 80 → HTTP
* 443 → HTTPS

Never open all ports to 0.0.0.0/0 unnecessarily.

Security groups enforce network-level protection.



# 8️⃣ Connecting via SSH

From slide page 18 

Get Public IPv4 address (page 17 screenshot) 

Then:

```bash
chmod 400 cmpe230.pem
ssh -i "cmpe230.pem" ec2-user@<public-ip>
```

You are now inside your remote Linux machine.

This connects to everything from PS1–PS3.



## 🔎 Exercise 1 – Remote System Inspection

Inside EC2:

```bash
whoami
lscpu
df -h
free -h
```

Answer:

* How much RAM?
* How many CPUs?
* What kernel version?



# 9️⃣ EC2 Instance Lifecycle

From slide page 9 

States:

```
Pending → Running → Stopped → Terminated
```

Important:

* Stop → keeps disk
* Terminate → deletes permanently



# 🔟 Storage in EC2

From slide page 19 

### EBS (Elastic Block Store)

Persistent storage.

Survives reboot.

### Instance Store

Temporary storage.

Lost if instance stops.

### Snapshot

Backup of volume.



## 🔎 Exercise 2 – Test Persistence

1. Create file in home directory.
2. Stop instance.
3. Start again.
4. Check if file exists.

Explain why.



# 1️⃣1️⃣ Deploy a Simple Web Server

Inside EC2:

```bash
sudo yum update -y
sudo yum install httpd -y
sudo systemctl start httpd
```

Allow port 80 in Security Group.

Visit:

```
http://<public-ip>
```

You just deployed a cloud web server.



# 1️⃣2️⃣ Monitoring with CloudWatch

From page 21 

CloudWatch monitors:

* CPU usage
* Disk
* Network

Set alarm:

If CPU > 80%.

This is DevOps-level monitoring.



# 1️⃣3️⃣ Elastic IP & Scaling

From page 22 

Elastic IP:

* Static public IP
* Survives instance restart

Auto Scaling:

* Automatically create/destroy EC2s
* Based on load

Load balancer distributes traffic across instances.

Large systems use this.



# 1️⃣4️⃣ Security Best Practices

From slide page 20 

✔ Use Key Pairs
✔ Restrict security groups
✔ Do not expose ports unnecessarily
✔ Do not share .pem files
✔ Enable billing alerts

From page 16 screenshot: create billing alerts 



# 1️⃣5️⃣ Systems-Level View

Cloud is just:

> Remote infrastructure using virtualization + networking + storage abstraction.




You are now capable of:

> Launching and managing a real cloud server.

