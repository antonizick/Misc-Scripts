#!/bin/bash

echo "=============================================="
echo "   WSL Disk Space Analysis Report"
echo "=============================================="
echo "Generated on: $(date)"
echo "Hostname:     $(hostname)"
echo "User:         $(whoami)"
echo ""

echo "=== 1. OVERALL FILESYSTEM USAGE ==="
df -hT
echo ""

echo "=== 2. TOP SPACE-USING DIRECTORIES (Root Level) ==="
echo "(Sorted by size - largest first)"
du -h --max-depth=1 / 2>/dev/null | sort -hr | head -n 30
echo ""

echo "=== 3. DETAILED BREAKDOWN OF KEY DIRECTORIES ==="
for dir in /home /var /usr /opt /tmp /root; do
    if [ -d "$dir" ]; then
        echo "--- $dir ---"
        du -h --max-depth=1 "$dir" 2>/dev/null | sort -hr | head -n 20
        echo ""
    fi
done

echo "=== 4. LARGEST INDIVIDUAL FILES (Top 30) ==="
echo "(Sizes in bytes - largest first. This may take 30–90 seconds)"
sudo find / -xdev -type f -printf '%s %p\n' 2>/dev/null | sort -rn | head -n 30
echo ""

echo "=== 5. SYSTEMD JOURNAL DISK USAGE ==="
journalctl --disk-usage 2>/dev/null || echo "journalctl not available"
echo ""

echo "=== 6. APT PACKAGE CACHE ==="
du -sh /var/cache/apt/archives 2>/dev/null || echo "No apt cache found"
echo ""

echo "=== 7. DOCKER / CONTAINER USAGE (if installed) ==="
if command -v docker &> /dev/null; then
    sudo docker system df 2>/dev/null || echo "Docker found but could not get usage"
else
    echo "Docker not installed or not in PATH"
fi
echo ""

echo "=============================================="
echo "Report complete."
echo "Please upload the full output (disk_report.txt) here for analysis."
echo "=============================================="
