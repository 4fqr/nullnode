# NullSector Lab - Enhanced Environment Test Script
# Tests new features: Metasploit, improved UI, beginner-friendly interface

Write-Host "`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║   NullSector Lab - Enhanced Environment Test Suite       ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

# Test 1: Check if image exists
Write-Host "[1/6] Checking Docker image..." -ForegroundColor Yellow
try {
    $imageInfo = docker images nullsector/lab:latest --format "{{.Size}}"
    if ($imageInfo) {
        Write-Host "  ✓ Image found: $imageInfo" -ForegroundColor Green
    } else {
        Write-Host "  ✗ Image not found! Run build first." -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "  ✗ Error checking image: $_" -ForegroundColor Red
    exit 1
}

# Test 2: Start container
Write-Host "`n[2/6] Starting test container..." -ForegroundColor Yellow
$containerId = docker run -d -p 7681:7681 --name nullsector-test nullsector/lab:latest
if ($LASTEXITCODE -eq 0) {
    Write-Host "  ✓ Container started: $containerId" -ForegroundColor Green
    Start-Sleep -Seconds 3
} else {
    Write-Host "  ✗ Failed to start container" -ForegroundColor Red
    exit 1
}

# Test 3: Check if ttyd is accessible
Write-Host "`n[3/6] Testing terminal access..." -ForegroundColor Yellow
try {
    $response = Invoke-WebRequest -Uri "http://localhost:7681" -TimeoutSec 5 -UseBasicParsing
    if ($response.StatusCode -eq 200) {
        Write-Host "  ✓ Terminal accessible at http://localhost:7681" -ForegroundColor Green
        Write-Host "  ✓ Browser should open automatically..." -ForegroundColor Green
        Start-Process "http://localhost:7681"
    }
} catch {
    Write-Host "  ✗ Terminal not accessible: $_" -ForegroundColor Red
}

# Test 4: Verify installed tools
Write-Host "`n[4/6] Verifying security tools..." -ForegroundColor Yellow
$tools = @(
    @{Name="nmap"; Command="nmap --version"},
    @{Name="msfconsole"; Command="ls /opt/metasploit-framework/msfconsole"},
    @{Name="sqlmap"; Command="sqlmap --version"},
    @{Name="nikto"; Command="ls /opt/nikto/program/nikto.pl"},
    @{Name="gobuster"; Command="gobuster version"},
    @{Name="hydra"; Command="hydra -h"},
    @{Name="john"; Command="john --version"}
)

foreach ($tool in $tools) {
    try {
        $result = docker exec nullsector-test sh -c "$($tool.Command)" 2>&1
        if ($LASTEXITCODE -eq 0) {
            Write-Host "  ✓ $($tool.Name) installed" -ForegroundColor Green
        } else {
            Write-Host "  ✗ $($tool.Name) not found" -ForegroundColor Yellow
        }
    } catch {
        Write-Host "  ✗ $($tool.Name) check failed" -ForegroundColor Yellow
    }
}

# Test 5: Check Juice Shop permissions
Write-Host "`n[5/6] Checking Juice Shop permissions..." -ForegroundColor Yellow
try {
    $permissions = docker exec nullsector-test sh -c "ls -ld /opt/juice-shop/data" 2>&1
    if ($permissions -match "drwxrwxrwx") {
        Write-Host "  ✓ Juice Shop data directory has correct permissions" -ForegroundColor Green
    } else {
        Write-Host "  ⚠ Permissions: $permissions" -ForegroundColor Yellow
    }
} catch {
    Write-Host "  ✗ Permission check failed: $_" -ForegroundColor Yellow
}

# Test 6: Display container logs
Write-Host "`n[6/6] Container logs:" -ForegroundColor Yellow
docker logs nullsector-test 2>&1 | Select-Object -First 10

# Summary
Write-Host "`n╔═══════════════════════════════════════════════════════════╗" -ForegroundColor Cyan
Write-Host "║                    TEST SUMMARY                           ║" -ForegroundColor Cyan
Write-Host "╚═══════════════════════════════════════════════════════════╝`n" -ForegroundColor Cyan

Write-Host "Container ID: $containerId" -ForegroundColor White
Write-Host "Terminal URL: http://localhost:7681" -ForegroundColor White
Write-Host "`nTest Commands in Browser Terminal:" -ForegroundColor Yellow
Write-Host "  • help              - Show welcome guide" -ForegroundColor White
Write-Host "  • msfconsole        - Start Metasploit" -ForegroundColor White
Write-Host "  • nmap -sV localhost - Test nmap" -ForegroundColor White
Write-Host "  • juice             - Start Juice Shop" -ForegroundColor White
Write-Host "  • ll                - List files" -ForegroundColor White

Write-Host "`nNext Steps:" -ForegroundColor Yellow
Write-Host "  1. Verify terminal UI in browser (colors, font size, spacing)" -ForegroundColor White
Write-Host "  2. Test welcome message (emojis, categories, examples)" -ForegroundColor White
Write-Host "  3. Run 'msfconsole' to verify Metasploit works" -ForegroundColor White
Write-Host "  4. Start Juice Shop with 'juice' command" -ForegroundColor White

Write-Host "`nCleanup:" -ForegroundColor Yellow
Write-Host "  docker stop nullsector-test && docker rm nullsector-test" -ForegroundColor Gray

Write-Host ""
