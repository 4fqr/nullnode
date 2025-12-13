# NullSector Lab - Test & Run Script
# Run this to build, test, and verify the lab environment

Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "  NULLSECTOR LAB - BUILD & TEST SUITE" -ForegroundColor Green
Write-Host "  Powered by NullNode - https://nullnode.vercel.app" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""

# Step 1: Check Docker
Write-Host "[1/6] Checking Docker..." -ForegroundColor Yellow
try {
    $dockerVersion = docker version 2>&1
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✓ Docker is running" -ForegroundColor Green
    } else {
        Write-Host "✗ Docker is not running. Please start Docker Desktop." -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "✗ Docker not found. Please install Docker Desktop." -ForegroundColor Red
    exit 1
}

# Step 2: Clean old images (optional)
Write-Host ""
Write-Host "[2/6] Cleaning old images..." -ForegroundColor Yellow
docker rmi nullsector/lab:latest -f 2>$null
docker builder prune -f 2>$null
Write-Host "✓ Cleanup complete" -ForegroundColor Green

# Step 3: Build the lab image
Write-Host ""
Write-Host "[3/6] Building NullSector Lab image..." -ForegroundColor Yellow
Write-Host "This will take 10-15 minutes. Progress will be shown below." -ForegroundColor Gray
Write-Host ""

$buildStart = Get-Date
docker build -t nullsector/lab:latest -f Dockerfile.lab.alpine . --progress=plain

if ($LASTEXITCODE -eq 0) {
    $buildEnd = Get-Date
    $buildTime = ($buildEnd - $buildStart).TotalMinutes
    Write-Host ""
    Write-Host ("✓ Build completed in {0:N1} minutes" -f $buildTime) -ForegroundColor Green
} else {
    Write-Host ""
    Write-Host "✗ Build failed. Check the error messages above." -ForegroundColor Red
    exit 1
}

# Step 4: Check image size
Write-Host ""
Write-Host "[4/6] Checking image size..." -ForegroundColor Yellow
$imageInfo = docker images nullsector/lab:latest --format "{{.Size}}"
Write-Host "✓ Image size: $imageInfo" -ForegroundColor Green

# Step 5: Test run the container
Write-Host ""
Write-Host "[5/6] Testing container..." -ForegroundColor Yellow
Write-Host "Starting test container on port 7681..." -ForegroundColor Gray

# Start container in background
$containerId = docker run -d -p 7681:7681 --rm --name nullsector-lab-test nullsector/lab:latest

if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Container started: $containerId" -ForegroundColor Green
    
    # Wait for container to be ready
    Start-Sleep -Seconds 3
    
    # Check if container is running
    $containerStatus = docker ps --filter "name=nullsector-lab-test" --format "{{.Status}}"
    
    if ($containerStatus) {
        Write-Host "✓ Container is running: $containerStatus" -ForegroundColor Green
        Write-Host ""
        Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
        Write-Host "  🎉 TEST SUCCESSFUL!" -ForegroundColor Green
        Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
        Write-Host ""
        Write-Host "Access your lab at: http://localhost:7681" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Press Enter to open in browser, or Ctrl+C to skip..." -ForegroundColor Gray
        Read-Host
        Start-Process "http://localhost:7681"
        Write-Host ""
        Write-Host "Press Enter to stop the test container..." -ForegroundColor Gray
        Read-Host
        
        # Stop container
        Write-Host "Stopping test container..." -ForegroundColor Yellow
        docker stop nullsector-lab-test 2>$null
        Write-Host "✓ Container stopped" -ForegroundColor Green
    } else {
        Write-Host "✗ Container failed to start properly" -ForegroundColor Red
        docker logs nullsector-lab-test
        docker stop nullsector-lab-test 2>$null
        exit 1
    }
} else {
    Write-Host "✗ Failed to start container" -ForegroundColor Red
    exit 1
}

# Step 6: Summary
Write-Host ""
Write-Host "[6/6] Setup Summary" -ForegroundColor Yellow
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host "✓ Docker Image: nullsector/lab:latest" -ForegroundColor Green
Write-Host "✓ Image Size: $imageInfo" -ForegroundColor Green
Write-Host "✓ Test: Passed" -ForegroundColor Green
Write-Host ""
Write-Host "Next Steps:" -ForegroundColor Yellow
Write-Host "1. Install npm packages: npm install" -ForegroundColor White
Write-Host "2. Configure environment: Set LAB_BOT_SECRET in .env" -ForegroundColor White
Write-Host "3. Start lab server: npm start" -ForegroundColor White
Write-Host "4. Test with Discord bot or manual API calls" -ForegroundColor White
Write-Host ""
Write-Host "Documentation: LAB_SETUP.md" -ForegroundColor Gray
Write-Host "Learn more: https://nullnode.vercel.app" -ForegroundColor Cyan
Write-Host "════════════════════════════════════════════════════════════════" -ForegroundColor Cyan
Write-Host ""
Write-Host "Happy Hacking! 🚀" -ForegroundColor Green
Write-Host ""
