@echo off
title Deploy AeroCircuit AI to Cloudflare Pages
echo ==========================================================
echo  AeroCircuit AI - Cloudflare Pages and D1 Deploy
echo ==========================================================
echo.
set "DENO_EXE=C:\Users\Ower\AppData\Local\Programs\Bionic\resources\app\.webpack-bionic\bin\deno.exe"

if not exist "%DENO_EXE%" (
    echo Error: Deno engine not found at %DENO_EXE%
    pause
    exit /b 1
)

echo Step 1: Synchronizing distribution files and functions...
xcopy /Y /Q "solution.html" "dist\"
xcopy /Y /Q "index.html" "dist\"
xcopy /Y /Q "code.html" "dist\"
xcopy /Y /Q "_headers" "dist\"
xcopy /Y /Q "_redirects" "dist\"
if not exist "dist\functions\api" mkdir "dist\functions\api"
xcopy /Y /Q "functions\api\*" "dist\functions\api\"

echo.
echo Step 2: Deploying dist/ to Cloudflare Pages (Project: aerocircuit-ai)...
"%DENO_EXE%" run -A --node-modules-dir=auto npm:wrangler pages deploy dist --project-name aerocircuit-ai

echo.
echo ==========================================================
echo Deployment finished!
echo Live Site: https://aerocircuit-ai.pages.dev
echo ==========================================================
pause
