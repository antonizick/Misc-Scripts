# ============================================================================
# WSL Multi-Port Forwarding + Firewall Script
# Expose multiple WSL web services to LAN + Tailscale
# ============================================================================

Write-Host "=== WSL Multi-Port Exposure Setup ===" -ForegroundColor Cyan

# ================== EDIT THIS LIST ==================
$ports = @(
    @{ Number = 8001; Label = "Voice Box" },
    @{ Number = 8002; Label = "Auth Proxy" },
    @{ Number = 8080; Label = "MovieMaj" },
    @{ Number = 8090; Label = "ChessLoop" }
    # Add as many as you need here
)
# ====================================================

# STEP 1: Cleanup
Write-Host "`n[1] Removing old rules..." -ForegroundColor Yellow

foreach ($port in $ports) {
    $n = $port.Number
    $l = $port.Label

    # Remove firewall rules
    @("WSL Port $n ($l)", "WSL Port $n Outbound ($l)", "WSL Port $n") | ForEach-Object {
        if (Get-NetFirewallRule -DisplayName $_ -ErrorAction SilentlyContinue) {
            Remove-NetFirewallRule -DisplayName $_ -ErrorAction SilentlyContinue
            Write-Host "  ✓ Removed firewall: $_"
        }
    }

    # Remove portproxy rules
    netsh interface portproxy delete v4tov4 listenport=$n listenaddress=0.0.0.0 2>$null
    netsh interface portproxy delete v4tov4 listenport=$n listenaddress=100. 2>$null   # catches Tailscale IPs
}

# STEP 2: Detect IPs
Write-Host "`n[2] Detecting IPs..." -ForegroundColor Yellow

$wslIP = (wsl hostname -I 2>$null).Trim().Split()[0]
if (-not $wslIP) { Write-Host "ERROR: Could not get WSL IP" -ForegroundColor Red; exit 1 }
Write-Host "  ✓ WSL IP: $wslIP"

$tsIP = (Get-NetIPAddress -InterfaceAlias "*Tailscale*" -AddressFamily IPv4 -ErrorAction SilentlyContinue).IPAddress
if ($tsIP) { Write-Host "  ✓ Tailscale IP: $tsIP" } else { Write-Host "  ⚠ No Tailscale interface found" -ForegroundColor Yellow }

# STEP 3: Create portproxy rules
Write-Host "`n[3] Creating portproxy rules..." -ForegroundColor Yellow

foreach ($port in $ports) {
    $n = $port.Number

    # LAN (all interfaces)
    netsh interface portproxy add v4tov4 listenport=$n listenaddress=0.0.0.0 connectport=$n connectaddress=$wslIP | Out-Null
    Write-Host "  ✓ Portproxy 0.0.0.0:$n → $wslIP`:$n"

    # Tailscale (if present)
    if ($tsIP) {
        netsh interface portproxy add v4tov4 listenport=$n listenaddress=$tsIP connectport=$n connectaddress=$wslIP | Out-Null
        Write-Host "  ✓ Portproxy $tsIP`:$n → $wslIP`:$n"
    }
}

# STEP 4: Create firewall rules (allow from anywhere on private networks)
Write-Host "`n[4] Creating firewall rules..." -ForegroundColor Yellow

foreach ($port in $ports) {
    $n = $port.Number
    $l = $port.Label

    New-NetFirewallRule -DisplayName "WSL Port $n ($l)" `
        -Direction Inbound -Action Allow -Protocol TCP `
        -LocalPort $n -Profile Domain,Private,Public | Out-Null

    Write-Host "  ✓ Firewall inbound rule for port $n ($l)"
}

# STEP 5: Quick verification
Write-Host "`n[5] Verification:" -ForegroundColor Cyan
netsh interface portproxy show v4tov4 | Select-String "($($ports.Number -join '|'))"

Write-Host "`n=== Done! ===" -ForegroundColor Green
Write-Host "Your services should now be reachable at:"
Write-Host "   http://$(hostname):PORT" -ForegroundColor Cyan
if ($tsIP) { Write-Host "   http://$tsIP`:PORT  (Tailscale)" -ForegroundColor Cyan }
