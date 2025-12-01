# ===============================
# Flutter Web GitHub Pages Deploy
# ===============================

# 1️⃣ Build Flutter web
Write-Host "Building Flutter web..."
flutter build web --release --web-renderer html --base-href /qr_menu_demo/

# 2️⃣ Patch bootstrap.js to remove service worker
$bootstrapFile = "build/web/bootstrap.js"
if (Test-Path $bootstrapFile) {
    Write-Host "Patching bootstrap.js..."
    (Get-Content $bootstrapFile) |
        ForEach-Object { $_ -replace '_flutter.loader.load\(\{[^}]*\}\);', '_flutter.loader.load();' } |
        Set-Content $bootstrapFile
} else {
    Write-Host "Warning: bootstrap.js not found!"
}

# 3️⃣ Delete flutter_service_worker.js
$swFile = "build/web/flutter_service_worker.js"
if (Test-Path $swFile) {
    Write-Host "Deleting flutter_service_worker.js..."
    Remove-Item -Force $swFile
}

# 4️⃣ Delete old docs folder
if (Test-Path "docs") {
    Write-Host "Deleting old docs folder..."
    Remove-Item -Recurse -Force docs
}

# 5️⃣ Copy new build to docs
Write-Host "Copying new build to docs..."
Copy-Item -Recurse -Force build/web docs

# 6️⃣ Git commit and push
Write-Host "Committing and pushing to GitHub..."
git add .
git commit -m "Deploy new Flutter web build"
git push origin main

Write-Host "✅ Deployment complete!"







