# ===============================
# Flutter Web GitHub Pages Deploy
# ===============================

Write-Host "🚀 Starting Flutter Web Deployment..." -ForegroundColor Cyan

# 1️⃣ Build Flutter web
Write-Host "`n📦 Building Flutter web..."
flutter build web --release --web-renderer html --base-href /qr_menu_demo/

# 2️⃣ Patch bootstrap.js (remove service worker settings)
$bootstrapFile = "build/web/bootstrap.js"
if (Test-Path $bootstrapFile) {
    Write-Host "🛠 Patching bootstrap.js..."

    # Read full file
    $content = Get-Content $bootstrapFile -Raw

    # Replace ANY _flutter.loader.load(...) with _flutter.loader.load();
    $patched = $content -replace '_flutter\.loader\.load\([^\)]*\);', '_flutter.loader.load();'

    # Save file
    Set-Content $bootstrapFile $patched
} else {
    Write-Host "⚠ bootstrap.js not found!"
}

# 3️⃣ Delete flutter_service_worker.js
$swFile = "build/web/flutter_service_worker.js"
if (Test-Path $swFile) {
    Write-Host "🗑 Deleting flutter_service_worker.js..."
    Remove-Item -Force $swFile
}

# 4️⃣ Delete old docs folder
if (Test-Path "docs") {
    Write-Host "🗑 Removing old docs folder..."
    Remove-Item -Recurse -Force docs
    Start-Sleep -Milliseconds 300
}

# 5️⃣ Copy new build to docs
Write-Host "📁 Copying new build to docs..."
Copy-Item -Recurse -Force build/web docs

# Debug check
Write-Host "🔍 Checking copied output..."
if (Test-Path "docs/index.html") {
    Write-Host "✅ docs/index.html OK!"
} else {
    Write-Host "❌ ERROR: docs/index.html not found!"
}

# 6️⃣ Git commit and push
Write-Host "`n📤 Committing and pushing to GitHub..."
git add .
git commit -m "Deploy new Flutter web build"
git push origin main

Write-Host "`n🎉 Deployment complete! Visit: https://tarekmarawi.github.io/qr_menu_demo/?v=$((Get-Random))" -ForegroundColor Green
