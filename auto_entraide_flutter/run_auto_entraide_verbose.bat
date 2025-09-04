@echo off
title Auto Entraide — Launcher (verbeux, fenetres persistantes)
setlocal EnableExtensions EnableDelayedExpansion

REM ---------- Resolve paths (repo root assumed) ----------
set "BASE_DIR=%~dp0"
set "BACKEND_DIR=%BASE_DIR%backend"
set "FRONT_DIR=%BASE_DIR%auto_entraide_flutter"

echo ===============================================
echo   Auto Entraide - Lancement complet (Windows)
echo   Backend : %BACKEND_DIR%
echo   Front   : %FRONT_DIR%
echo ===============================================
echo.

REM ---------- Quick checks ----------
where node >NUL 2>NUL || (echo [ERREUR] Node.js introuvable dans PATH. Installez Node.js puis relancez. & pause & exit /b 1)
where npm  >NUL 2>NUL || (echo [ERREUR] npm introuvable dans PATH. Installez Node.js puis relancez. & pause & exit /b 1)
where flutter >NUL 2>NUL || (echo [AVERTISSEMENT] Flutter introuvable dans PATH. Le front ne pourra pas demarrer.)
echo [OK] Node/ npm/ Flutter : ^(si "Flutter introuvable", ignorez si vous ne lancez que l'API^)
echo.

REM ---------- Try to start PostgreSQL service (if present) ----------
echo [PG] Recherche et demarrage du service PostgreSQL (si present)...
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$svc = Get-Service ^| Where-Object { $_.Name -like 'postgresql*' -or $_.DisplayName -like 'PostgreSQL*' } ^| Select-Object -First 1; ^
   if ($null -ne $svc) { ^
     if ($svc.Status -ne 'Running') { Start-Service $svc.Name; $svc.WaitForStatus('Running','00:00:20') } ; ^
     Write-Host ('[PG] Service: ' + $svc.Name + ' (' + $svc.Status + ')') ^
   } else { Write-Host '[PG] Aucun service PostgreSQL detecte. (Ignorer si vous utilisez Docker ou un serveur distant)'; }"

echo.

REM ---------- Apply schema once if possible ----------
if exist "%BACKEND_DIR%\database\schema.sql" (
  if not exist "%BACKEND_DIR%\database\.schema_applied" (
    echo [DB] Tentative d'application du schema (si psql est trouve)...
    powershell -NoProfile -ExecutionPolicy Bypass -Command ^
      "$envPath = Join-Path '%BACKEND_DIR%' '.env'; ^
       if (Test-Path $envPath) { ^
         foreach($line in Get-Content $envPath) { if ($line -match '^\s*([A-Za-z_]\w*)\s*=\s*(.*)$') { $n=$matches[1]; $v=$matches[2].Trim('""'''); Set-Item -Path Env:$n -Value $v } } ^
       } ^
       $psql = Get-ChildItem 'C:\Program Files\PostgreSQL' -Recurse -Filter psql.exe -ErrorAction SilentlyContinue ^| Sort-Object FullName -Descending ^| Select-Object -First 1 -ExpandProperty FullName; ^
       if (-not $psql) { Write-Host '[DB] psql.exe introuvable - on saute.'; exit 0 } ^
       if (-not $env:DB_HOST) { Write-Host '[DB] Variables DB_* introuvables dans .env - on saute.'; exit 0 } ^
       if ($env:DB_PASSWORD) { $env:PGPASSWORD = $env:DB_PASSWORD } ^
       & $psql -h $env:DB_HOST -p $env:DB_PORT -U $env:DB_USER -d $env:DB_NAME -f '%BACKEND_DIR%\database\schema.sql'"
    if "%ERRORLEVEL%"=="0" (
      echo applied> "%BACKEND_DIR%\database\.schema_applied"
      echo [DB] Schema applique (marker cree).
    ) else (
      echo [DB] Echec lors de l'application du schema (vous pourrez le faire manuellement).
    )
    echo.
  )
)

REM ---------- Start API in a persistent window ----------
echo [API] Lancement du backend (port 3001) dans une nouvelle fenetre...
if not exist "%BACKEND_DIR%" (echo [ERREUR] Dossier backend introuvable: %BACKEND_DIR% & goto AFTER_API)
start "Auto Entraide API" cmd /k ^
  "cd /d "%BACKEND_DIR%" ^&^& ^
   echo === API: npm install (node-bluetooth supprime) === ^&^& ^
   (npm uninstall node-bluetooth >NUL 2>NUL) ^&^& ^
   npm install ^&^& ^
   set NODE_ENV=development ^&^& ^
   echo === API: demarrage nodemon === ^&^& ^
   npx nodemon server.js"

:AFTER_API
echo.

REM ---------- Start Flutter Web in a persistent window ----------
echo [WEB] Lancement du frontend Flutter (Chrome, port 5000) dans une nouvelle fenetre...
if not exist "%FRONT_DIR%" (echo [AVERTISSEMENT] Dossier Flutter introuvable: %FRONT_DIR% ^& goto END)
start "Auto Entraide Flutter" cmd /k ^
  "cd /d "%FRONT_DIR%" ^&^& ^
   flutter pub get ^&^& ^
   flutter run -d chrome --web-port 5000 --no-dds"

:END
echo.
echo [OK] Fenetres ouvertes : API (Node) et Front (Flutter). Elles resteront ouvertes ^(cmd /k^).
echo     - API   : http://localhost:3001/api/health
echo     - Front : http://localhost:5000
echo.
echo Si une fenetre se ferme instantanement, relancez ce .bat depuis un invite de commandes ^(cmd^) pour voir l'erreur.
echo.
pause
exit /b 0
