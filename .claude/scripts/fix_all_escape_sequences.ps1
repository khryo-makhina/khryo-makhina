# Fix all escape sequences in test files
$paths = @(
    "CsvTranslations/OllamaTranslatorApi.Tests"
)

foreach ($root in $paths) {
    $files = Get-ChildItem -Path $root -Filter *.cs -Recurse -File | Where-Object { $_.FullName -notlike "*\obj\*" -and $_.FullName -notlike "*\bin\*" }
    
    Write-Host "Checking $($files.Count) .cs files in $root for escape sequences..." -ForegroundColor Cyan
    
    foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw
        
        # Check for any remaining escape sequences
        $hasEscapeSequences = $content -match '\\[rn]'
        
        if ($hasEscapeSequences) {
            Write-Host "Fixing escape sequences in: $($file.Name)" -ForegroundColor Yellow
            
            # Show sample of what we're fixing
            $sample = $content.Substring(0, [Math]::Min(200, $content.Length))
            Write-Host "  Sample before:" -ForegroundColor Gray
            Write-Host "  '$($sample.Replace("`r", "[CR]").Replace("`n", "[LF]"))'" -ForegroundColor Gray
            
            # Step 1: Replace all escape sequences
            # Replace literal "\r\n" with actual CRLF
            $content = $content -replace '\\r\\n', "`r`n"
            # Replace literal "\n" with actual newline
            $content = $content -replace '\\n', "`n"
            # Replace literal "\r" with actual carriage return
            $content = $content -replace '\\r', "`r"
            
            # Step 2: Normalize line endings to CRLF (Windows style)
            $content = $content -replace "`r`n", "`n"  # Convert CRLF to LF
            $content = $content -replace "`r", "`n"     # Convert CR to LF
            $content = $content -replace "`n", "`r`n"   # Convert LF to CRLF
            
            # Save with UTF-8 encoding (no BOM)
            [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.UTF8Encoding]::new($false))
            
            # Verify fix
            $newContent = Get-Content $file.FullName -Raw
            $newSample = $newContent.Substring(0, [Math]::Min(200, $newContent.Length))
            Write-Host "  Sample after:" -ForegroundColor Gray
            Write-Host "  '$($newSample.Replace("`r", "[CR]").Replace("`n", "[LF]"))'" -ForegroundColor Gray
            
            $remaining = ($newContent | Select-String -Pattern '\\[rn]' -AllMatches).Matches.Count
            Write-Host "  Remaining escape sequences: $remaining" -ForegroundColor $(if ($remaining -eq 0) { "Green" } else { "Red" })
        }
    }
}

Write-Host "`nDone fixing escape sequences." -ForegroundColor Green