# Fix corrupted test files that have literal \n escape sequences instead of actual newlines
$paths = @(
    "CsvTranslations/OllamaTranslatorApi.Tests"
)

foreach ($root in $paths) {
    $files = Get-ChildItem -Path $root -Filter *.cs -Recurse -File | Where-Object { $_.FullName -notlike "*\obj\*" -and $_.FullName -notlike "*\bin\*" }
    
    Write-Host "Checking $($files.Count) .cs files in $root for corruption..." -ForegroundColor Cyan
    
    foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw
        
        # Check if the file contains literal \n escape sequences (not actual newlines)
        $hasLiteralNewline = $content -match '\\n'
        $lineCount = ($content -split "`r`n" -split "`n" -split "`r").Count
        
        Write-Host "File: $($file.Name) - Lines: $lineCount, Has literal \n: $hasLiteralNewline" -ForegroundColor Gray
        
        if ($hasLiteralNewline -and $lineCount -lt 30) {
            Write-Host "  Fixing corrupted file: $($file.FullName)" -ForegroundColor Yellow
            
            # Step 1: First fix the literal \n escape sequences
            # Replace literal "\n" with actual newline character
            $content = $content -replace '\\n', "`n"
            
            # Step 2: Normalize line endings to CRLF
            # Replace any CRLF or CR with LF first, then convert all LF to CRLF
            $content = $content -replace "`r`n", "`n"
            $content = $content -replace "`r", "`n"
            $content = $content -replace "`n", "`r`n"
            
            # Save with UTF-8 encoding (no BOM)
            [System.IO.File]::WriteAllText($file.FullName, $content, [System.Text.UTF8Encoding]::new($false))
            
            Write-Host "  Fixed file saved." -ForegroundColor Green
        }
    }
}

Write-Host "`nDone fixing corrupted files." -ForegroundColor Green