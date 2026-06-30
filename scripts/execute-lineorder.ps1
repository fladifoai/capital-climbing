#!/usr/bin/env pwsh
# Executes line_order update for all routes via Management API, sector by sector

param(
    [string]$Token = $env:SUPABASE_ACCESS_TOKEN,
    [string]$ProjectRef = "apfyktdacsklnptcgjko"
)

$ApiUrl = "https://api.supabase.com/v1/projects/$ProjectRef/database/query"

function Exec-Sql([string]$sql) {
    $escaped = $sql -replace '\\', '\\' -replace '"', '\"' -replace "`r`n", '\n' -replace "`n", '\n' -replace "`t", '\t'
    $json = '{"query":"' + $escaped + '"}'
    $client = [System.Net.WebClient]::new()
    $client.Headers["Authorization"] = "Bearer $Token"
    $client.Headers["Content-Type"] = "application/json"
    try {
        $r = $client.UploadString($ApiUrl, "POST", $json)
        return @{ ok = $true; data = $r }
    } catch {
        return @{ ok = $false; error = $_.Exception.Message }
    }
}

function SqlEsc($s) {
    if ($null -eq $s) { return "NULL" }
    return "'" + ($s -replace "'", "''") + "'"
}

$CragsDir = Join-Path $PSScriptRoot "..\src\data\crags"
$files = Get-ChildItem -Path $CragsDir -Recurse -Filter "*.json" | Sort-Object FullName

$ok = 0; $warn = 0; $err = 0

foreach ($file in $files) {
    $data = Get-Content $file.FullName -Raw -Encoding UTF8 | ConvertFrom-Json

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add("DO `$`$")
    $lines.Add("DECLARE")
    $lines.Add("  v_sector_id uuid;")
    $lines.Add("BEGIN")
    $lines.Add("  SELECT s.id INTO v_sector_id")
    $lines.Add("    FROM sectors s JOIN crags c ON c.id = s.crag_id")
    $lines.Add("    WHERE lower(s.name) = lower($(SqlEsc $data.sector))")
    $lines.Add("      AND lower(c.name) = lower($(SqlEsc $data.crag))")
    $lines.Add("    LIMIT 1;")
    $lines.Add("  IF v_sector_id IS NOT NULL THEN")

    for ($i = 0; $i -lt $data.routes.Count; $i++) {
        $r = $data.routes[$i]
        $lines.Add("    UPDATE routes SET line_order = $($i+1)")
        $lines.Add("      WHERE lower(name) = lower($(SqlEsc $r.name)) AND sector_id = v_sector_id;")
    }

    $lines.Add("  ELSE")
    $lines.Add("    RAISE WARNING 'Sector not found: % in %', $(SqlEsc $data.sector), $(SqlEsc $data.crag);")
    $lines.Add("  END IF;")
    $lines.Add("END `$`$;")

    $sql = $lines -join "`n"
    $result = Exec-Sql $sql
    if ($result.ok) {
        $ok++
        Write-Host "  OK  $($data.crag) > $($data.sector) ($($data.routes.Count) routes)" -ForegroundColor Green
    } else {
        $err++
        Write-Host "  ERR $($data.crag) > $($data.sector): $($result.error)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Done: $ok sectors updated, $err errors"
