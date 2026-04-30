# Fix string literals that have actual newlines instead of escape sequences
$paths = @(
    "CsvTranslations/OllamaTranslatorApi.Tests"
)

foreach ($root in $paths) {
    $files = Get-ChildItem -Path $root -Filter *.cs -Recurse -File | Where-Object { $_.FullName -notlike "*\obj\*" -and $_.FullName -notlike "*\bin\*" }
    
    Write-Host "Checking $($files.Count) .cs files in $root for string literals with newlines..." -ForegroundColor Cyan
    
    foreach ($file in $files) {
        $content = Get-Content $file.FullName -Raw
        
        # Check for string literals with actual newlines
        # Pattern: opening quote, any content, newline, any content, closing quote
        $hasNewlineInString = $content -match '"[^"]*[\r\n]+[^"]*"'
        
        if ($hasNewlineInString) {
            Write-Host "Fixing string literals in: $($file.Name)" -ForegroundColor Yellow
            
            # We need to process line by line to handle string literals properly
            $lines = $content -split "\r\n"
            $inMultiLineString = $false
            $stringBuilder = [System.Text.StringBuilder]::new()
            $resultLines = @()
            
            foreach ($line in $lines) {
                $currentLine = $line
                
                # Check if we're inside a multi-line string
                if ($inMultiLineString) {
                    # Check if this line contains the closing quote
                    if ($currentLine -match '"') {
                        # Found closing quote - end of string literal
                        # We need to escape any newlines that were in the string
                        $stringBuilder.Append("`r`n") | Out-Null
                        $stringBuilder.Append($currentLine) | Out-Null
                        $resultLines += $stringBuilder.ToString()
                        $stringBuilder.Clear()
                        $inMultiLineString = $false
                    } else {
                        # Still inside string - accumulate
                        $stringBuilder.Append("`r`n") | Out-Null
                        $stringBuilder.Append($currentLine) | Out-Null
                    }
                    continue
                }
                
                # Check for string literals with newlines on this line
                # Simple approach: replace actual newlines in string literals with \r\n
                # This regex finds string literals and replaces newlines within them
                $pattern = '"([^"]*?(?:\r?\n[^"]*?)*)"'
                
                if ($currentLine -match $pattern) {
                    # Replace newlines within string literals with \r\n
                    $currentLine = [regex]::Replace($currentLine, $pattern, {
                        param($match)
                        $innerContent = $match.Groups[1].Value
                        # Escape newlines within the string
                        $escaped = $innerContent -replace "`r`n", '\r\n' -replace "`n", '\n' -replace "`r", '\r'
                        return '"' + $escaped + '"'
                    })
                }
                
                $resultLines += $currentLine
            }
            
            # Join lines back with CRLF
            $newContent = $resultLines -join "`r`n"
            
            # Save with UTF-8 encoding (no BOM)
            [System.IO.File]::WriteAllText($file.FullName, $newContent, [System.Text.UTF8Encoding]::new($false))
            
            Write-Host "  Fixed string literals." -ForegroundColor Green
        }
    }
}

Write-Host "`nDone fixing string literals." -ForegroundColor Green