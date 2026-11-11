@echo off
title AeroCircuit AI - Cloudflare D1 Setup and Deploy
echo ==========================================================
echo  AeroCircuit AI - Cloudflare D1 Setup and Deploy
echo ==========================================================
echo.

set "DENO_EXE=C:\Users\Ower\AppData\Local\Programs\Bionic\resources\app\.webpack-bionic\bin\deno.exe"

if exist "%DENO_EXE%" (
    set "WRANGLER_CMD="%DENO_EXE%" run -A npm:wrangler"
) else (
    where npx >nul 2>nul
    if %ERRORLEVEL% EQU 0 (
        set "WRANGLER_CMD=npx wrangler"
    ) else (
        echo Error: Neither Deno nor Node/npx was found.
        echo Please ensure Deno or Node.js is installed.
        pause
        exit /b 1
    )
)

echo Step 1: Checking Cloudflare authentication...
if not exist "%USERPROFILE%\.wrangler\config\default.toml" (
    if "%CLOUDFLARE_API_TOKEN%"=="" (
        echo Launching browser authorization...
        echo Please click Allow in the browser window to connect Wrangler.
        echo.
        %WRANGLER_CMD% login
    )
)

echo.
echo Step 2: Creating Cloudflare D1 Database aerocircuit-contacts...
%WRANGLER_CMD% d1 create aerocircuit-contacts

echo.
echo Step 3: Executing schema.sql on Cloudflare D1 Remote Database...
%WRANGLER_CMD% d1 execute aerocircuit-contacts --remote --file=./schema.sql

echo.
echo Step 4: Executing schema.sql on Cloudflare D1 Local Database...
%WRANGLER_CMD% d1 execute aerocircuit-contacts --local --file=./schema.sql

echo.
echo Step 5: Verifying contacts table in Cloudflare D1...
%WRANGLER_CMD% d1 execute aerocircuit-contacts --remote --command="SELECT name, type FROM sqlite_master WHERE type='table';"

echo.
echo Step 6: Synchronizing distribution files and functions...
xcopy /Y /Q "solution.html" "dist\"
xcopy /Y /Q "index.html" "dist\"
xcopy /Y /Q "code.html" "dist\"
xcopy /Y /Q "_headers" "dist\"
if not exist "dist\functions\api" mkdir "dist\functions\api"
xcopy /Y /Q "functions\api\*" "dist\functions\api\"

echo.
echo Step 7: Deploying Pages and Functions to Cloudflare...
%WRANGLER_CMD% pages deploy dist --project-name aerocircuit-ai

echo.
echo ==========================================================
echo  Cloudflare D1 Setup and Deployment Finished Successfully!
echo ==========================================================
pause
