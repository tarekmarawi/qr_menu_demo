Write-Host "🚀 Deploying Flutter Web..."

# 1. Build
flutter build web --release --web-renderer html --base-href "/qr_menu_demo/"

# 2. Patch bootstrap
$bootstrap = "build/web/flutter_bootstrap.js"
(Get-Content $bootstrap) `
    -replace 'serviceWorker[\s\S]*?},', "" `
    -replace '_flutter.loader.load\(\s*\);', '_flutter.loader.load();' |
    Set-Content $bootstrap

# 3. Delete service worker files
$files = @(
    "build/web/flutter_service_worker.js",
    "build/web/version.json",
    "build/web/.last_build_id"
)
foreach ($f in $files) {
    if (Test-Path $f) { Remove-Item $f -Force }
}

# 4. Replace docs
if (Test-Path "docs") { Remove-Item docs -Recurse -Force }
Copy-Item build/web docs -Recurse -Force

# 5. Git commit
git add .
git commit -m "Deploy"
git push

Write-Host "✅ Done!"
