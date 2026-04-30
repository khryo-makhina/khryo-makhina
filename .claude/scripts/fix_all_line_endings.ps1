# Fix line endings in all C# files in the OllamaTranslatorApi project and tests
$paths = @(
    "CsvTranslations/OllamaTranslatorApi",
    "CsvTranslations/OllamaTranslatorApi.Tests"
)

$totalFixed = 0

foreach ($root in $paths) {
    $files = Get-ChildItem -Path $root -Filter *.cs -Recurse -File
    
    Write-Host "Checking $($files.Count) .cs files in $root..." -ForegroundColor Cyan
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
            $totalFixed++
        }
    }
    
    Write-Host "Fixed $fixedCount files in $root." -ForegroundColor Green
}

Write-Host "`nTotal fixed: $totalFixed files." -ForegroundColor Green