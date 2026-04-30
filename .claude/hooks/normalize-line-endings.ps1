<#
.SYNOPSIS
PostToolUse hook — normalizes line endings after Write/Edit.
On Windows (OS=Windows_NT): converts LF→CRLF, skipping .sh and binary files.
On macOS/Linux: no-op (files stay LF naturally).
#>

# Read JSON data from stdin (passed by Cline)
$inputData = $null
try {
    $inputData = $input | Out-String
    if ([string]::IsNullOrEmpty($inputData)) {
        # Try reading from stdin
        $inputData = [Console]::In.ReadToEnd()
    }
} catch {
    $inputData = ""
}

# No-op on non-Windows platforms
if ($env:OS -ne "Windows_NT") {
    exit 0
}

try {
    # Parse JSON data to get file path
    if (-not [string]::IsNullOrEmpty($inputData)) {
        $jsonData = $inputData | ConvertFrom-Json
        $filePath = $jsonData.tool_input.file_path
        
        if ([string]::IsNullOrEmpty($filePath)) {
            exit 0
        }
        
        if (-not (Test-Path -Path $filePath -PathType Leaf)) {
            exit 0
        }
        
        # Shell scripts must stay LF (Docker / Unix compatibility)
        if ($filePath -match '\.sh$') {
            exit 0
        }
        
        # Skip binary files (NUL-byte heuristic)
        $contentBytes = [System.IO.File]::ReadAllBytes($filePath)
        if ($contentBytes -contains 0) {
            exit 0
        }
        
        # Read file content
        $content = [System.IO.File]::ReadAllText($filePath, [System.Text.Encoding]::UTF8)
        
        # Check if file has LF line endings (no CRLF)
        if ($content -match '(?<!\r)\n') {
            # Convert LF to CRLF
            $content = $content -replace '(?<!\r)\n', "`r`n"
            [System.IO.File]::WriteAllText($filePath, $content, [System.Text.Encoding]::UTF8)
        }
    }
} catch {
    # Silently fail - don't interrupt the tool use
    exit 0
}

exit 0
