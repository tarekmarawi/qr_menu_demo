Write-Host "Building Flutter web..."
flutter build web --release --web-renderer html --base-href /qr_menu_demo/

Write-Host "Fixing bootstrap.js..."
$path1 = "build/web/bootstrap.js"
if (Test-Path $path1) {
    $t = Get-Content $path1 -Raw
    $t = $t -replace "_flutter.loader.load(.*);", "_flutter.loader.load();"
    Set-Content $path1 $t
}

Write-Host "Deleting flutter_service_worker..."
$path2 = "build/web/flutter_service_worker.js"
if (Test-Path $path2) { Remove-Item -Force $path2 }

Write-Host "Removing old docs..."
if (Test-Path "docs") { Remove-Item -Recurse -Force docs }

Write-Host "Copying new build..."
Copy-Item -Recurse -Force build/web docs

Write-Host "Git push..."
git add .
git commit -m Deploy
git push

$cache = Get-Random
Write-Host "DONE. OPEN:"
Write-Host ("https://tarekmarawi.github.io/qr_menu_demo/?v=" + $cache)
