<#
.SYNOPSIS
    Automated Cloudflare D1 SQLite Database Setup & Deployment Script
    Project: AeroCircuit AI - Manufacturing Planning System
#>

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " AeroCircuit AI - Cloudflare D1 SQLite Database Setup" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

$denoPath = "C:\Users\Ower\AppData\Local\Programs\Bionic\resources\app\.webpack-bionic\bin\deno.exe"

function Run-Wrangler {
    param([string[]]$Arguments)
    if (Test-Path $denoPath) {
        & $denoPath run -A npm:wrangler @Arguments
    } elseif (Get-Command npx -ErrorAction SilentlyContinue) {
        & npx wrangler @Arguments
    } else {
        throw "Neither Deno nor Node/npx was found on the system."
    }
}

Write-Host "Step 1: Checking Cloudflare credentials..." -ForegroundColor Yellow
try {
    Run-Wrangler @("whoami")
} catch {
    Write-Host "Please authenticate with Cloudflare..." -ForegroundColor Cyan
    Run-Wrangler @("login")
}

Write-Host "`nStep 2: Creating D1 Database 'aerocircuit-contacts'..." -ForegroundColor Yellow
Run-Wrangler @("d1", "create", "aerocircuit-contacts")

Write-Host "`nStep 3: Initializing schema on Remote Cloudflare D1..." -ForegroundColor Yellow
Run-Wrangler @("d1", "execute", "aerocircuit-contacts", "--remote", "--file=./schema.sql")

Write-Host "`nStep 4: Initializing schema on Local Cloudflare D1..." -ForegroundColor Yellow
Run-Wrangler @("d1", "execute", "aerocircuit-contacts", "--local", "--file=./schema.sql")

Write-Host "`nStep 5: Verifying SQLite schema..." -ForegroundColor Yellow
Run-Wrangler @("d1", "execute", "aerocircuit-contacts", "--remote", "--command=SELECT name FROM sqlite_master WHERE type='table';")

Write-Host "`nStep 6: Deploying Pages and Functions to Cloudflare..." -ForegroundColor Yellow
Run-Wrangler @("pages", "deploy", "dist", "--project-name", "aerocircuit-ai")

Write-Host "`n==========================================================" -ForegroundColor Green
Write-Host " Setup Complete! Cloudflare D1 is actively persisting contact data." -ForegroundColor Green
Write-Host "==========================================================" -ForegroundColor Green

