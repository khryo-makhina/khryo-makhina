# Verify all C# files have CRLF line endings
$paths = @(
    "CsvTranslations/OllamaTranslatorApi",
    "CsvTranslations/OllamaTranslatorApi.Tests"
)

$totalFiles = 0
$filesWithLf = @()

foreach ($root in $paths) {
    $files = Get-ChildItem -Path $root -Filter *.cs -Recurse -File
    
    Write-Host "Checking $($files.Count) .cs files in $root..." -ForegroundColor Cyan
    $totalFiles += $files.Count
    
    foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw
        $hasLf = $content -match '[^\r]\n'
        
        if ($hasLf) {
            $lfCount = ($content | Select-String -Pattern '[^\r]\n' -AllMatches).Matches.Count
            $crlfCount = ($content | Select-String -Pattern '\r\n' -AllMatches).Matches.Count
            $filesWithLf += [PSCustomObject]@{
                File = $file.FullName
                LfCount = $lfCount
                CrlfCount = $crlfCount
            }
        }
    }
}

Write-Host "`nVerification complete:" -ForegroundColor Cyan
Write-Host "Total files checked: $totalFiles" -ForegroundColor White
Write-Host "Files with LF line endings: $($filesWithLf.Count)" -ForegroundColor $(if ($filesWithLf.Count -eq 0) { "Green" } else { "Red" })

if ($filesWithLf.Count -gt 0) {
    Write-Host "`nFiles that still have LF line endings:" -ForegroundColor Red
    foreach ($fileInfo in $filesWithLf) {
        Write-Host "  $($fileInfo.File)" -ForegroundColor Yellow
        Write-Host "    LF count: $($fileInfo.LfCount), CRLF count: $($fileInfo.CrlfCount)" -ForegroundColor Gray
    }
} else {
    Write-Host "`n✓ All files have CRLF line endings!" -ForegroundColor Green
}