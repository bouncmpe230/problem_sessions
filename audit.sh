#!/usr/bin/env bash
# CMPE230 - Simple System Auditor (PS1 + PS2 essentials)

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