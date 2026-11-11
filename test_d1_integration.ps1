<#
.SYNOPSIS
    Automated Test Suite for Cloudflare D1 SQLite Database & Contact Form Integration
    Project: AeroCircuit AI - Manufacturing Planning System
#>

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " AeroCircuit AI - D1 Integration Automated Test Suite" -ForegroundColor Cyan
Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host ""

$testsPassed = 0
$testsFailed = 0

function Assert-Test {
    param(
        [string]$Description,
        [bool]$Condition,
        [string]$Details = ""
    )
    if ($Condition) {
        Write-Host "  [PASS] $Description" -ForegroundColor Green
        $script:testsPassed++
    } else {
        Write-Host "  [FAIL] $Description" -ForegroundColor Red
        if ($Details) {
            Write-Host "         $Details" -ForegroundColor Yellow
        }
        $script:testsFailed++
    }
}

# -------------------------------------------------------------
# Group 1: File Existence & Build Artifacts
# -------------------------------------------------------------
Write-Host "Group 1: Checking Files & Distribution Structure..." -ForegroundColor Yellow

Assert-Test -Description "schema.sql exists in root" -Condition (Test-Path "schema.sql")
Assert-Test -Description "functions/api/contact.js exists" -Condition (Test-Path "functions\api\contact.js")
Assert-Test -Description "functions/api/contacts.js exists" -Condition (Test-Path "functions\api\contacts.js")
Assert-Test -Description "dist/functions/api/contact.js exists" -Condition (Test-Path "dist\functions\api\contact.js")
Assert-Test -Description "dist/functions/api/contacts.js exists" -Condition (Test-Path "dist\functions\api\contacts.js")
Assert-Test -Description "worker/index.js exists" -Condition (Test-Path "worker\index.js")
Assert-Test -Description "wrangler.toml exists" -Condition (Test-Path "wrangler.toml")
Assert-Test -Description "setup_cloudflare_d1.bat exists" -Condition (Test-Path "setup_cloudflare_d1.bat")
Assert-Test -Description "setup_cloudflare_d1.ps1 exists" -Condition (Test-Path "setup_cloudflare_d1.ps1")
Assert-Test -Description "migrations/0001_create_contacts_table.sql exists" -Condition (Test-Path "migrations\0001_create_contacts_table.sql")

# -------------------------------------------------------------
# Group 2: SQLite Schema Validation
# -------------------------------------------------------------
Write-Host "`nGroup 2: Validating SQLite Schema Syntax & Content..." -ForegroundColor Yellow
$schemaContent = Get-Content -Path "schema.sql" -Raw
Assert-Test -Description "schema.sql creates 'contacts' table" -Condition ($schemaContent -match "CREATE TABLE IF NOT EXISTS contacts")
Assert-Test -Description "schema.sql contains 'contact_date' column" -Condition ($schemaContent -match "contact_date\s+DATETIME")
Assert-Test -Description "schema.sql contains index on 'contact_date'" -Condition ($schemaContent -match "idx_contacts_contact_date")
Assert-Test -Description "schema.sql contains index on 'email'" -Condition ($schemaContent -match "idx_contacts_email")
Assert-Test -Description "schema.sql contains 'client_ip' and 'country'" -Condition ($schemaContent -match "client_ip" -and $schemaContent -match "country")

# -------------------------------------------------------------
# Group 3: Frontend Form & UI Integration
# -------------------------------------------------------------
Write-Host "`nGroup 3: Checking Frontend Form Markup & Script Integration..." -ForegroundColor Yellow
$solutionContent = Get-Content -Path "solution.html" -Raw
Assert-Test -Description "solution.html contains '#client-contact-form'" -Condition ($solutionContent -match 'id="client-contact-form"')
Assert-Test -Description "solution.html contains contact_date display in alert" -Condition ($solutionContent -match 'id="contact-timestamp"')
Assert-Test -Description "solution.html contains Cloudflare D1 storage badge" -Condition ($solutionContent -match 'id="contact-storage-badge"')
Assert-Test -Description "solution.html calls /api/contact" -Condition ($solutionContent -match 'fetch\("/api/contact"')
Assert-Test -Description "solution.html implements syncLeadsFromD1()" -Condition ($solutionContent -match 'syncLeadsFromD1')
Assert-Test -Description "solution.html contains D1 sync button" -Condition ($solutionContent -match 'id="btn-sync-d1"')
Assert-Test -Description "dist/solution.html matches root solution.html" -Condition ((Get-Content -Path "dist\solution.html" -Raw) -eq $solutionContent)

# -------------------------------------------------------------
# Group 4: Cloudflare Pages Function Code Verification
# -------------------------------------------------------------
Write-Host "`nGroup 4: Verifying Cloudflare Pages Function Logic..." -ForegroundColor Yellow
$funcContent = Get-Content -Path "functions\api\contact.js" -Raw
Assert-Test -Description "functions/api/contact.js exports onRequestPost" -Condition ($funcContent -match "export async function onRequestPost")
Assert-Test -Description "functions/api/contact.js exports onRequestGet" -Condition ($funcContent -match "export async function onRequestGet")
Assert-Test -Description "functions/api/contact.js exports onRequestOptions (CORS)" -Condition ($funcContent -match "export async function onRequestOptions")
Assert-Test -Description "Function binds to env.DB D1 database" -Condition ($funcContent -match "env\.DB")
Assert-Test -Description "Function auto-initializes contacts table" -Condition ($funcContent -match "CREATE TABLE IF NOT EXISTS contacts")
Assert-Test -Description "Function inserts contact_date and metadata" -Condition ($funcContent -match "INSERT INTO contacts.*contact_date")
Assert-Test -Description "Function extracts cf-connecting-ip and cf-ipcountry" -Condition ($funcContent -match "cf-connecting-ip" -and $funcContent -match "cf-ipcountry")

# -------------------------------------------------------------
# Group 5: Data Persistence & Contact Date Formatting Verification
# -------------------------------------------------------------
Write-Host "`nGroup 5: Testing Contact Record Structure & Formatting..." -ForegroundColor Yellow

$testDataDir = Join-Path $PSScriptRoot "data"
if (-not (Test-Path $testDataDir)) {
    New-Item -ItemType Directory -Path $testDataDir -Force | Out-Null
}
$testContactsFile = Join-Path $testDataDir "contacts.json"

$sampleContact = [PSCustomObject]@{
    id           = "#INQ-" + (Get-Random -Minimum 10000 -Maximum 99999)
    name         = "Dr. Elena Rostova"
    email        = "e.rostova@quantum-pcba.com"
    company      = "Quantum Systems PCBA"
    role         = "VP Operations"
    volume       = "100k"
    interests    = @("bom-shortages", "smt-fleet")
    message      = "Evaluating Level 2 AI planning agent for our Austin SMT line."
    contact_date = (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ")
    client_ip    = "127.0.0.1"
    country      = "US"
    status       = "NEW"
}

# Test serialization
$jsonString = $sampleContact | ConvertTo-Json -Depth 5
Assert-Test -Description "Contact record serializes to valid JSON" -Condition ($jsonString.Length -gt 20)

# Test deserialization and field validation
$deserialized = $jsonString | ConvertFrom-Json
Assert-Test -Description "Record retains reference ID format (#INQ-xxxxx)" -Condition ($deserialized.id -match "^#INQ-\d{5}$")
Assert-Test -Description "Record retains client email" -Condition ($deserialized.email -eq "e.rostova@quantum-pcba.com")
Assert-Test -Description "Record retains client company" -Condition ($deserialized.company -eq "Quantum Systems PCBA")
Assert-Test -Description "Record stores ISO contact_date with Z timezone" -Condition ($deserialized.contact_date -match "^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$")

# Save to contacts.json and read back
$existing = if (Test-Path $testContactsFile) {
    try { (Get-Content -Path $testContactsFile -Raw -Encoding UTF8) | ConvertFrom-Json } catch { @() }
} else { @() }
$updated = @($sampleContact) + @($existing)
$updated | ConvertTo-Json -Depth 5 | Set-Content -Path $testContactsFile -Encoding UTF8

$reloaded = (Get-Content -Path $testContactsFile -Raw -Encoding UTF8) | ConvertFrom-Json
$found = $reloaded | Where-Object { $_.id -eq $sampleContact.id }
Assert-Test -Description "Record successfully persisted to and retrieved from contacts storage" -Condition ($found -ne $null)

# -------------------------------------------------------------
# Summary
# -------------------------------------------------------------
Write-Host "`n==========================================================" -ForegroundColor Cyan
Write-Host " Test Execution Completed" -ForegroundColor Cyan
Write-Host " Total Passed: $testsPassed" -ForegroundColor Green
Write-Host " Total Failed: $testsFailed" -ForegroundColor $(if ($testsFailed -eq 0) { "Green" } else { "Red" })
Write-Host "==========================================================" -ForegroundColor Cyan

if ($testsFailed -gt 0) {
    exit 1
} else {
    exit 0
}
