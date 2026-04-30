# Check line endings in C# files
$root = "CsvTranslations/OllamaTranslatorApi"
$files = Get-ChildItem -Path $root -Filter *.cs -Recurse -File

Write-Host "Checking line endings in $($files.Count) .cs files..." -ForegroundColor Cyan

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $hasLf = $content -match '[^\r]\n'
    $hasCrLf = $content -match '\r\n'
    
    if ($hasLf) {
        Write-Host "File with LF line endings: $($file.FullName)" -ForegroundColor Red
        
        # Count LF vs CRLF
        $lfCount = ($content | Select-String -Pattern '[^\r]\n' -AllMatches).Matches.Count
        $crlfCount = ($content | Select-String -Pattern '\r\n' -AllMatches).Matches.Count
        Write-Host "  LF count: $lfCount, CRLF count: $crlfCount" -ForegroundColor Yellow
        
        # Show first few lines with LF
        $lines = $content -split '\r?\n'
        $lfLines = @()
        for ($i = 0; $i -lt [Math]::Min(3, $lines.Count); $i++) {
            if ($lines[$i] -match '[^\r]\n?$') {
                $lfLines += "Line $($i+1): $($lines[$i])"
            }
        }
        if ($lfLines.Count -gt 0) {
            Write-Host "  Sample lines with LF:" -ForegroundColor Yellow
            $lfLines | ForEach-Object { Write-Host "    $_" }
        }
    }
}

Write-Host "`nDone checking line endings." -ForegroundColor Green