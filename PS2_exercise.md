## The Simple System Auditor Script (audit.sh)

This handout explains **audit.sh**, a small automation script that collects basic system evidence into a log file.

You will learn:
- how commands produce output
- how we redirect output into files
- how we inspect CPU/memory/disk/processes
- how permissions protect evidence
- how symbolic links give us a stable “latest report”

---

## 1) What the script produces

When you run:

```bash
./audit.sh
````

It creates:

* a folder: `~/system_audit/`
* a timestamped report: `audit_YYYYMMDD_HHMMSS.log`
* a stable link: `~/system_audit/latest_report`

So you can always open the newest report easily.

---

## 2) Script (for reference)

```bash
#!/usr/bin/env bash
set -e

TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
AUDIT_DIR="$HOME/system_audit"
REPORT="$AUDIT_DIR/audit_$TIMESTAMP.log"

mkdir -p "$AUDIT_DIR"

echo "CMPE230 System Audit - $TIMESTAMP" > "$REPORT"
echo "" >> "$REPORT"

echo "== Identity ==" >> "$REPORT"
whoami >> "$REPORT"
id >> "$REPORT"
echo "" >> "$REPORT"

echo "== Uptime ==" >> "$REPORT"
uptime >> "$REPORT"
echo "" >> "$REPORT"

echo "== Memory ==" >> "$REPORT"
free -h >> "$REPORT"
echo "" >> "$REPORT"

echo "== Disk Usage ==" >> "$REPORT"
df -h >> "$REPORT"
echo "" >> "$REPORT"

echo "== Top CPU Processes ==" >> "$REPORT"
ps -eo pid,user,comm,%cpu,%mem --sort=-%cpu | head -n 10 >> "$REPORT"
echo "" >> "$REPORT"

echo "== Root Processes (first 10) ==" >> "$REPORT"
ps -eo user,pid,comm,args | grep '^root' | head -n 10 >> "$REPORT"
echo "" >> "$REPORT"

echo "== Mounted File Systems (preview) ==" >> "$REPORT"
mount | head -n 20 >> "$REPORT"
echo "" >> "$REPORT"

chmod 600 "$REPORT"
ln -sf "$REPORT" "$AUDIT_DIR/latest_report"

echo "Audit completed."
echo "Report: $REPORT"
echo "Latest: $AUDIT_DIR/latest_report"
```

---

## 3) Key ideas explained

### 3.1 Shebang

```bash
#!/usr/bin/env bash
```

Tells the OS: "run this file with `bash`".

### 3.2 Fail fast

```bash
set -e
```

If a command fails, the script stops immediately.
This prevents producing incomplete or misleading evidence.

### 3.3 Timestamped reports

```bash
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
```

This makes each report unique.

### 3.4 Where logs go

```bash
AUDIT_DIR="$HOME/system_audit"
REPORT="$AUDIT_DIR/audit_$TIMESTAMP.log"
```

* `$HOME` makes it portable for all students.
* Quoting `"$VAR"` prevents problems with spaces.

### 3.5 Create directory safely

```bash
mkdir -p "$AUDIT_DIR"
```

`-p` means: “do not error if directory already exists”.

---

## 4) Redirection and logging

### 4.1 Overwrite vs append

```bash
echo "header" >  file
echo "more"   >> file
```

* `>` overwrites file from scratch
* `>>` appends to the end

We overwrite once to start clean, then append everything.

---

## 5) What each section checks 

### Identity 

```bash
whoami
id
```

* checks current user
* shows UID/GID/groups

### Uptime 

```bash
uptime
```

A quick “health signal” for load averages.

### Memory 

```bash
free -h
```

Shows RAM usage and pressure.

### Disk 

```bash
df -h
```

Disk full is one of the most common real server failures.

### Processes 

```bash
ps ... --sort=-%cpu | head
```

Shows top CPU consumers.

### Root processes (idea: privilege)

```bash
... | grep '^root'
```

Root-owned processes are not automatically bad, but they deserve attention.

### Mounted systems (concept: mounting)

```bash
mount
```

Shows what is attached to `/`.
**Note:** in containers, mounts may look different than a real host OS.

---

## 6) Securing evidence

```bash
chmod 600 "$REPORT"
```

Permission `600` means:

* owner: read + write
* group: no access
* others: no access

Audit logs may contain sensitive data (usernames, running services, paths).

---

## 7) The “latest_report” symlink

```bash
ln -sf "$REPORT" "$AUDIT_DIR/latest_report"
```

* new report file name changes every run (timestamp)
* we want a stable reference

`latest_report` always points to the newest report.

---

## 8) How to run

```bash
chmod +x audit.sh
./audit.sh
```

View latest report:

```bash
cat ~/system_audit/latest_report
```

---

## 9) Mini exercises (recommended)

1. Run the script.
2. Find the **top CPU process** in the report.
3. What is your **UID and primary GID**?
4. What does `chmod 600` protect you from?
5. Why do we keep `latest_report` as a symlink?

---

## 10) Optional extensions (Challenge Mode)

Add these as extra sections:

**Disk > 90%**

```bash
df -h | awk '$5+0 > 90'
```

**Zombie processes**

```bash
ps -eo pid,stat,comm | awk '$2 ~ /^Z/ {print}'
```

**Compress old logs**

```bash
gzip ~/system_audit/audit_*.log
```

```

