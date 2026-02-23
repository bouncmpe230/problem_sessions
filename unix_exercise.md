#  CMPE 230 – Systems Programming

# Problem Session: The System Auditor Mission



#  1 — Mission Briefing

## Emergency on BOUN-Server-01

The university research server is experiencing:

* 🔥 CPU spikes
* 📉 Memory pressure
* 💾 Disk almost full
* ⚠ Suspicious root-owned processes

The system administrator is unavailable.

You are now assigned as:

> **CMPE 230 Systems Auditor**

Your objective:

1. Investigate
2. Collect evidence
3. Secure logs
4. Automate reporting

This is not just shell usage.

This is systems reasoning.





#  2 — What We Will Actually Practice

Over the next 2 hours, you will:

* Understand what happens when a command executes
* Use pipes as dataflow graphs
* Inspect running processes
* Analyze memory and disk usage
* Control permissions using octal logic
* Create symbolic links
* Write a robust automated audit script

You are not learning commands.

You are learning **control over a system.**





#  3 — Kernel & Shell Refresher

When you type:

```bash
cat file.txt
```

What happens internally?

1. Shell parses input
2. Shell calls `fork()`
3. Child process calls `execve()`
4. Kernel loads executable
5. Program invokes `open()`, `read()`, `write()`
6. Kernel schedules and handles I/O

The shell is not magic.

It is a **process launcher + interpreter.**





#  4 — Mission Objective

You must build:

## `audit.sh`

It should:

1. Create an audit directory
2. Collect system status
3. Capture suspicious processes
4. Log output correctly
5. Secure logs
6. Maintain a "latest report" link

Deliverable: A working script.





#  5 — Phase 1: Establish Audit Base

```bash
#!/bin/bash

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
AUDIT_DIR="$HOME/system_audit"
REPORT="$AUDIT_DIR/audit_$TIMESTAMP.log"

mkdir -p "$AUDIT_DIR"
```

### Why?

* `mkdir -p` prevents failure if directory exists
* `$HOME` makes it portable
* Timestamp prevents overwriting old logs

### Question:

Why quote variables?

Correct answer:

> To avoid breakage when paths contain spaces.





#  6 — Redirection Logic

```bash
echo "System Audit - $TIMESTAMP" > "$REPORT"
```

`>` overwrites
`>>` appends

Why overwrite first line but append later?

Because:

* First write defines the file
* Subsequent writes accumulate structured content





#  7 — Phase 2: Resource Snapshot

Add to script:

```bash
echo " Uptime " >> "$REPORT"
uptime >> "$REPORT"

echo " Memory " >> "$REPORT"
free -h >> "$REPORT"
```

What you just used:

* Command execution
* Standard output redirection
* Log formatting
* System health inspection





#  8 — Disk Investigation

Add:

```bash
echo " Disk Usage " >> "$REPORT"
df -h >> "$REPORT"
```

Optional:

```bash
du -sh * >> "$REPORT"
```

Which is:

| Command | Fast | Accurate | Deep |
| - | - | -- | - |
| df      | ✅    | ❌        | ❌    |
| du      | ❌    | ✅        | ✅    |

Real-world meaning:

> Servers fail more often due to disk than CPU.





#  9 — Phase 3: Process Investigation

```bash
echo " Top CPU Processes " >> "$REPORT"
ps -eo pid,comm,%cpu --sort=-%cpu | head -6 >> "$REPORT"
```

Breakdown:

* `ps -eo` → custom format
* `--sort=-%cpu` → descending
* `head -6` → limit exposure

This is composable systems design.





#  10 — Root Process Inspection

```bash
echo " Root Processes " >> "$REPORT"
ps -ef | grep "^root" | head -n 10 >> "$REPORT"
```

Pipeline stages:

1. `ps`
2. `grep`
3. `head`
4. `>>`

Important question:

Why filter before limiting?

Because otherwise, you may miss relevant processes.

Ordering matters.





#  11 — Pipes as Dataflow Graphs

Think of:

```bash
ps -ef | grep root | wc -l
```

As:

Process → Filter → Counter

Each command:

* Consumes stdin
* Produces stdout

Unix philosophy:

> Do one thing well.





#  12 — Phase 4: Secure the Evidence

```bash
chmod 600 "$REPORT"
```

Octal logic:

| Digit | Meaning |
| -- | - |
| 6     | rw-     |
| 0     |      |
| 0     |      |

Why block group & others?

Because audit logs may expose:

* Running services
* Usernames
* System configuration

777 is not permission.
777 is negligence.





#  13 — Phase 5: Maintain Latest Link

```bash
ln -sf "$REPORT" "$AUDIT_DIR/latest_report"
```

Why symbolic link?

Because:

* New reports get new timestamps
* You need a stable reference

Hard link or soft link?

Soft link:

* Safer
* Easier to update
* Points by name, not inode





#  14 — Complete Script

```bash
#!/bin/bash

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
AUDIT_DIR="$HOME/system_audit"
REPORT="$AUDIT_DIR/audit_$TIMESTAMP.log"

mkdir -p "$AUDIT_DIR"

echo "System Audit - $TIMESTAMP" > "$REPORT"

echo " Uptime " >> "$REPORT"
uptime >> "$REPORT"

echo " Memory " >> "$REPORT"
free -h >> "$REPORT"

echo " Disk Usage " >> "$REPORT"
df -h >> "$REPORT"

echo " Top CPU Processes " >> "$REPORT"
ps -eo pid,comm,%cpu --sort=-%cpu | head -6 >> "$REPORT"

echo " Root Processes " >> "$REPORT"
ps -ef | grep "^root" | head -n 10 >> "$REPORT"

chmod 600 "$REPORT"

ln -sf "$REPORT" "$AUDIT_DIR/latest_report"

echo "Audit completed."
```





#  15 — What You Actually Learned

Without explicitly discussing C yet, you applied:

* Process creation logic
* Scheduling awareness
* File descriptors
* Permission modeling
* Resource inspection
* Symbolic linking
* Safe logging patterns

You are already thinking like system programmers.





#  16 — Challenge Mode (Advanced)

Enhance the script:

### 1️⃣ Detect Disk > 90%

Hint:

```bash
df -h | awk '$5+0 > 90'
```



### 2️⃣ Detect Zombie Processes

Hint:

```bash
ps aux | awk '$8=="Z"'
```



### 3️⃣ Delete Logs Older Than 7 Days

```bash
find "$AUDIT_DIR" -type f -mtime +7 -delete
```



### 4️⃣ Compress Old Logs

```bash
gzip "$REPORT"
```



#  17 — Real Production Scenario

The server crashes overnight.

Investigation reveals:

* World-writable directories
* 15GB debug logs
* Unrestricted service access
* No monitoring scripts

What failed?

Not technology.

Engineering discipline.

Automation prevents human forgetfulness.





#  18 — Reflection

Shell is not typing.

Shell is:

* Process orchestration
* Permission governance
* Resource diagnostics
* Stream-based programming
* Minimalist automation

CMPE 230 is not about syntax.

It is about control.



#  Final Mission Summary

You started with:

> A misbehaving server.

You ended with:

* Automated diagnostics
* Controlled access
* Structured logging
* Future-proof reporting

This is Systems Thinking.

Welcome to CMPE 230.


