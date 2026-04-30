# Fix line endings in C# files from LF to CRLF
$root = "CsvTranslations/OllamaTranslatorApi"
$files = Get-ChildItem -Path $root -Filter *.cs -Recurse -File

Write-Host "Fixing line endings in $($files.Count) .cs files..." -ForegroundColor Cyan
$fixedCount = 0

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $hasLf = $content -match '[^\r]\n'
    
    if ($hasLf) {
        # Count LF vs CRLF before fixing
        $lfCount = ($content | Select-String -Pattern '[^\r]\n' -AllMatches).Matches.Count
        $crlfCount = ($content | Select-String -Pattern '\r\n' -AllMatches).Matches.Count
        
        Write-Host "Fixing: $($file.FullName)" -ForegroundColor Yellow
        Write-Host "  Before - LF count: $lfCount, CRLF count: $crlfCount" -ForegroundColor Gray
        
        # Replace LF with CRLF
        # First normalize to LF only, then replace LF with CRLF
        $content = $content -replace '\r\n', '\n'  # Convert any existing CRLF to LF
        $content = $content -replace '\n', "`r`n"   # Convert LF to CRLF
        
        # Save with UTF-8 encoding (no BOM)
        [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.UTF8Encoding]::new($false))
        
        # Verify after fixing
        $newContent = Get-Content $file.FullName -Raw
        $newLfCount = ($newContent | Select-String -Pattern '[^\r]\n' -AllMatches).Matches.Count
        $newCrlfCount = ($newContent | Select-String -Pattern '\r\n' -AllMatches).Matches.Count
        
        Write-Host "  After  - LF count: $newLfCount, CRLF count: $newCrlfCount" -ForegroundColor Gray
        $fixedCount++
    }
}

Write-Host "`nFixed $fixedCount files." -ForegroundColor Green