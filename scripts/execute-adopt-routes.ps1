#!/usr/bin/env pwsh
# Adopts old NULL-source routes as pdf_import where they match JSON data
# Updates source='pdf_import' and official_grade for routes that blocked import

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
        return @{ ok = $true; data = ($r | ConvertFrom-Json) }
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

$totalUpdated = 0
$errors = 0

foreach ($file in $files) {
    $data = Get-Content $file.FullName -Raw -Encoding UTF8 | ConvertFrom-Json

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add("DO `$`$")
    $lines.Add("DECLARE")
    $lines.Add("  v_sector_id uuid;")
    $lines.Add("  v_updated   int := 0;")
    $lines.Add("BEGIN")
    $lines.Add("  SELECT s.id INTO v_sector_id")
    $lines.Add("    FROM sectors s JOIN crags c ON c.id = s.crag_id")
    $lines.Add("    WHERE lower(s.name) = lower($(SqlEsc $data.sector))")
    $lines.Add("      AND lower(c.name) = lower($(SqlEsc $data.crag))")
    $lines.Add("    LIMIT 1;")
    $lines.Add("  IF v_sector_id IS NOT NULL THEN")

    foreach ($route in $data.routes) {
        $grade = if ($null -eq $route.grade) { "NULL" } else { SqlEsc $route.grade }
        $lines.Add("    UPDATE routes")
        $lines.Add("      SET source = 'pdf_import', official_grade = $grade")
        $lines.Add("      WHERE lower(name) = lower($(SqlEsc $route.name))")
        $lines.Add("        AND sector_id = v_sector_id")
        $lines.Add("        AND source IS DISTINCT FROM 'pdf_import';")
    }

    $lines.Add("  END IF;")
    $lines.Add("END `$`$;")

    $sql = $lines -join "`n"
    $result = Exec-Sql $sql
    if ($result.ok) {
        $totalUpdated++
        Write-Host "  OK  $($data.crag) > $($data.sector)" -ForegroundColor Green
    } else {
        $errors++
        Write-Host "  ERR $($data.crag) > $($data.sector): $($result.error)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Done: $totalUpdated sectors processed, $errors errors"
