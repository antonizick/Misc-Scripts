# Misc Scripts

A collection of system administration and automation scripts for Windows (PowerShell), Linux/WSL (Bash), and Google Workspace.

## Purpose

This repository contains utility scripts for system maintenance, disk management, network configuration, and document automation. Scripts are organized by platform and use case, solving common administrative tasks and workflow improvements.

## Scripts

### System & Disk Management

#### Disk Analysis (`diskanalysis.sh`)

**Platform:** Linux/WSL (Bash)  
**Purpose:** Generate comprehensive disk space usage reports for WSL systems.

**Features:**
- Overall filesystem usage summary
- Top space-consuming directories at root level
- Detailed breakdown of key directories (`/home`, `/var`, `/usr`, `/opt`, `/tmp`, `/root`)
- Largest individual files (top 30)
- systemd journal disk usage
- APT package cache analysis
- Docker/container usage (if installed)

**Usage:**
```bash
./diskanalysis.sh
```

#### OS & HD Maintenance (`OS & HD maint`)

**Platform:** Windows (Command Prompt)  
**Purpose:** Quick reference for regular Windows system and hard drive maintenance commands.

**Includes:**
- System File Checker (`sfc /scannow`) — runs weekly
- DISM image repair (`DISM /Online /Cleanup-Image /RestoreHealth`)
- Check Disk (`chkdsk C: /f /r`) — with reboot scheduling

**Usage:**
Run commands in Command Prompt or PowerShell as Administrator. Recommended: schedule weekly.

#### WSL HD Compression (`WSL_HD_Compress`)

**Platform:** Windows (Command Prompt + diskpart)  
**Purpose:** Clean and compress WSL VHDX virtual disk files to reclaim disk space.

**Steps:**
1. Clean up Linux package cache with apt
2. Fill free space to aid compression
3. Shut down WSL
4. Attach VHDX as read-only
5. Compact the virtual disk
6. Detach and verify

**Usage:**
Run from Command Prompt or PowerShell as Administrator.

### Network & Firewall

#### Firewall Management (`Firewall Management.ps1`)

**Platform:** Windows (PowerShell)  
**Purpose:** Configure WSL multi-port forwarding and firewall rules for exposing WSL services to LAN and Tailscale.

**Features:**
- Multi-port portproxy configuration (0.0.0.0 + Tailscale support)
- Automatic WSL and Tailscale IP detection
- Cleanup of old rules before applying new configuration
- Firewall inbound rules for private/domain/public profiles
- Configurable port list with labels

**Usage:**
1. Edit the `$ports` array at the top to add/remove ports
2. Run in PowerShell as Administrator: `.\Firewall\ Management.ps1`
3. Services will be accessible at `http://hostname:PORT` and via Tailscale

**Example Ports:**
- 8001 — Voice Box
- 8002 — Auth Proxy
- 8080 — MovieMaj
- 8090 — ChessLoop

### Google Workspace

#### Table of Contents Generator (`tableofcontents`)

**Platform:** Google Apps Script  
**Purpose:** Automatically generate and refresh a table of contents in Google Docs with support for hierarchical tab navigation.

**Features:**
- Creates a clickable table of contents with direct links to each document tab
- Supports nested tab hierarchies with visual indentation
- Automatically finds and populates a designated TOC tab
- Refreshes on demand via custom menu command
- Handles both "Table of Contents" and "TOC" tab name variants (case-insensitive)

**Usage:**
1. In your Google Doc, create a new tab and name it either "Table of Contents" or "TOC"
2. Open the Apps Script editor (Extensions → Apps Script)
3. Paste the `tableofcontents` script code
4. Save and run the `onOpen()` function
5. Reload your document
6. Use the **Nx TOC** menu → **Refresh Table of Contents** to generate or update the TOC

## Platform Requirements

| Script | Platform | Requirements |
|--------|----------|---|
| `diskanalysis.sh` | Linux/WSL | Bash, standard utilities (df, du, find) |
| `OS & HD maint` | Windows | Command Prompt/PowerShell, Admin privileges |
| `WSL_HD_Compress` | Windows | diskpart, Admin privileges |
| `Firewall Management.ps1` | Windows | PowerShell 5.0+, Admin privileges, WSL installed |
| `tableofcontents` | Google Docs | Google account, Apps Script access |

## Quick Start

**For Linux/WSL:**
```bash
./diskanalysis.sh > disk_report.txt
```

**For Windows (as Administrator):**
```powershell
.\Firewall\ Management.ps1
```

**For Google Docs:**
1. Copy `tableofcontents` to Google Apps Script editor
2. Run `onOpen()` and reload the document
