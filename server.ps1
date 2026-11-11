param(
    [int]$Port = 8080
)

$baseDir = $PSScriptRoot
$dataDir = Join-Path $baseDir "data"
if (-not (Test-Path $dataDir)) {
    New-Item -ItemType Directory -Path $dataDir -Force | Out-Null
}
$contactsFile = Join-Path $dataDir "contacts.json"
if (-not (Test-Path $contactsFile)) {
    Set-Content -Path $contactsFile -Value "[]" -Encoding UTF8
}

$listener = New-Object System.Net.HttpListener
$prefix = "http://localhost:$Port/"
$listener.Prefixes.Add($prefix)

try {
    $listener.Start()
} catch {
    $Port = 8088
    $prefix = "http://localhost:$Port/"
    $listener = New-Object System.Net.HttpListener
    $listener.Prefixes.Add($prefix)
    $listener.Start()
}

Write-Host "==========================================================" -ForegroundColor Cyan
Write-Host " AeroCircuit AI Local Planning & D1 Emulation Server" -ForegroundColor Cyan
Write-Host " Running at: $prefix" -ForegroundColor Green
Write-Host " Endpoints:  $prefix/api/contact (POST, GET, OPTIONS)" -ForegroundColor Yellow
Write-Host "==========================================================" -ForegroundColor Cyan

$mimeTypes = @{
    ".html" = "text/html; charset=utf-8"
    ".htm"  = "text/html; charset=utf-8"
    ".css"  = "text/css"
    ".js"   = "application/javascript"
    ".json" = "application/json"
    ".png"  = "image/png"
    ".jpg"  = "image/jpeg"
    ".svg"  = "image/svg+xml"
    ".ico"  = "image/x-icon"
}

while ($listener.IsListening) {
    try {
        $context = $listener.GetContext()
        $request = $context.Request
        $response = $context.Response

        $urlPath = $request.Url.LocalPath.TrimStart('/')

        # -------------------------------------------------------------
        # API ROUTE: /api/contact and /api/contacts (D1 SQLite Emulation)
        # -------------------------------------------------------------
        if ($urlPath -eq "api/contact" -or $urlPath -eq "api/contacts") {
            $response.AddHeader("Access-Control-Allow-Origin", "*")
            $response.AddHeader("Access-Control-Allow-Methods", "GET, POST, OPTIONS")
            $response.AddHeader("Access-Control-Allow-Headers", "Content-Type, Authorization, X-Requested-With")

            if ($request.HttpMethod -eq "OPTIONS") {
                $response.StatusCode = 204
                $response.Close()
                continue
            }

            if ($request.HttpMethod -eq "POST") {
                $reader = New-Object System.IO.StreamReader($request.InputStream, [System.Text.Encoding]::UTF8)
                $bodyText = $reader.ReadToEnd()
                
                try {
                    $body = $bodyText | ConvertFrom-Json
                } catch {
                    $body = $null
                }

                if (-not $body -or -not $body.name -or -not $body.email -or -not $body.company) {
                    $response.StatusCode = 400
                    $response.ContentType = "application/json"
                    $errJson = '{"success":false,"error":"Validation failed: name, email, and company are required."}'
                    $bytes = [System.Text.Encoding]::UTF8.GetBytes($errJson)
                    $response.OutputStream.Write($bytes, 0, $bytes.Length)
                    $response.Close()
                    continue
                }

                $genId = if ($body.id) { $body.id } else { "#INQ-" + (Get-Random -Minimum 10000 -Maximum 99999) }
                $contactDate = if ($body.timestamp) { $body.timestamp } elseif ($body.contact_date) { $body.contact_date } else { (Get-Date).ToUniversalTime().ToString("yyyy-MM-ddTHH:mm:ssZ") }
                
                $newRecord = [PSCustomObject]@{
                    id           = $genId
                    name         = $body.name
                    email        = $body.email
                    company      = $body.company
                    role         = if ($body.role) { $body.role } else { "" }
                    volume       = if ($body.volume) { $body.volume } else { "25k" }
                    interests    = if ($body.interests) { $body.interests } else { @() }
                    message      = if ($body.message) { $body.message } else { "" }
                    contact_date = $contactDate
                    client_ip    = "127.0.0.1"
                    country      = "US"
                    status       = "NEW"
                }

                # Save record to local JSON storage
                $currentJson = Get-Content -Path $contactsFile -Raw -Encoding UTF8
                $list = try { $currentJson | ConvertFrom-Json } catch { @() }
                if (-not $list) { $list = @() }
                $updatedList = @($newRecord) + @($list)
                $updatedList | ConvertTo-Json -Depth 5 | Set-Content -Path $contactsFile -Encoding UTF8

                $respObj = [PSCustomObject]@{
                    success      = $true
                    message      = "Contact inquiry successfully stored in local database (Cloudflare D1 Emulation)."
                    id           = $genId
                    contact_date = $contactDate
                    storage      = "local_d1_emulation"
                    record       = $newRecord
                }

                $response.StatusCode = 201
                $response.ContentType = "application/json"
                $bytes = [System.Text.Encoding]::UTF8.GetBytes(($respObj | ConvertTo-Json -Depth 5))
                $response.OutputStream.Write($bytes, 0, $bytes.Length)
                $response.Close()
                continue
            }

            if ($request.HttpMethod -eq "GET") {
                $currentJson = Get-Content -Path $contactsFile -Raw -Encoding UTF8
                $list = try { $currentJson | ConvertFrom-Json } catch { @() }
                if (-not $list) { $list = @() }

                $respObj = [PSCustomObject]@{
                    success   = $true
                    total     = $list.Count
                    contacts  = $list
                    storage   = "local_d1_emulation"
                }

                $response.StatusCode = 200
                $response.ContentType = "application/json"
                $bytes = [System.Text.Encoding]::UTF8.GetBytes(($respObj | ConvertTo-Json -Depth 5))
                $response.OutputStream.Write($bytes, 0, $bytes.Length)
                $response.Close()
                continue
            }
        }

        # -------------------------------------------------------------
        # STATIC ASSET ROUTING
        # -------------------------------------------------------------
        if ([string]::IsNullOrWhiteSpace($urlPath) -or $urlPath -eq "/") {
            $urlPath = "index.html"
        }

        $filePath = Join-Path $baseDir $urlPath

        if (-not (Test-Path $filePath -PathType Leaf) -and (Test-Path "$filePath.html" -PathType Leaf)) {
            $filePath = "$filePath.html"
        }

        # Check in dist folder as fallback
        if (-not (Test-Path $filePath -PathType Leaf)) {
            $distPath = Join-Path (Join-Path $baseDir "dist") $urlPath
            if (Test-Path $distPath -PathType Leaf) {
                $filePath = $distPath
            }
        }

        if (Test-Path $filePath -PathType Leaf) {
            $ext = [System.IO.Path]::GetExtension($filePath).ToLower()
            $mime = if ($mimeTypes.ContainsKey($ext)) { $mimeTypes[$ext] } else { "application/octet-stream" }
            $bytes = [System.IO.File]::ReadAllBytes($filePath)

            $response.ContentType = $mime
            $response.ContentLength64 = $bytes.Length
            $response.AddHeader("Access-Control-Allow-Origin", "*")
            $response.StatusCode = 200
            $response.OutputStream.Write($bytes, 0, $bytes.Length)
        } else {
            $response.StatusCode = 404
            $errBytes = [System.Text.Encoding]::UTF8.GetBytes("404 Not Found")
            $response.OutputStream.Write($errBytes, 0, $errBytes.Length)
        }
        $response.Close()
    } catch {
        # Continue loop on aborted client requests
    }
}
