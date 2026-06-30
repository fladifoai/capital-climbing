#!/usr/bin/env pwsh
# Executes crag/sector/route import directly via Supabase Management API
# Reads JSON files, builds per-crag DO blocks, sends one at a time

param(
    [string]$Token = $env:SUPABASE_ACCESS_TOKEN,
    [string]$ProjectRef = "apfyktdacsklnptcgjko"
)

$ApiUrl = "https://api.supabase.com/v1/projects/$ProjectRef/database/query"
$Headers = @{ "Authorization" = "Bearer $Token"; "Content-Type" = "application/json" }

$COUNTRY_IDS = @{
    "italy" = "00000000-0000-0000-0001-000000000001"
    "spain" = "00000000-0000-0000-0001-000000000002"
}
$REGION_IDS = @{
    "lazio"         = "00000000-0000-0000-0002-000000000007"
    "abruzzo"       = "00000000-0000-0000-0002-000000000001"
    "umbria"        = "00000000-0000-0000-0002-000000000018"
    "molise"        = "00000000-0000-0000-0002-000000000011"
    "valle d'aosta" = "00000000-0000-0000-0002-000000000019"
    "sardegna"      = "00000000-0000-0000-0002-000000000014"
    "isole baleari" = "00000000-0000-0000-0002-000000000021"
}

function SqlEsc($s) {
    if ($null -eq $s) { return "NULL" }
    return "'" + ($s -replace "'", "''") + "'"
}

function Norm($s) {
    return $s.ToLower().Trim()
}

function Slug($s) {
    $s = $s.ToLower().Trim()
    # Replace Italian accented chars
    $s = $s -replace '[àáâã]','a' -replace '[èéêë]','e' -replace '[ìíîï]','i' -replace '[òóôõ]','o' -replace '[ùúûü]','u'
    $s = [System.Text.RegularExpressions.Regex]::Replace($s, '[^a-z0-9]+', '-')
    return $s.Trim('-')
}

function Exec-Query($sql) {
    $bodyObj = [PSCustomObject]@{ query = $sql }
    $body = $bodyObj | ConvertTo-Json -Depth 1 -Compress
    try {
        $r = Invoke-RestMethod -Uri $ApiUrl -Method POST -Headers $Headers -Body $body -TimeoutSec 60
        return @{ ok = $true; data = $r }
    } catch {
        $msg = $_.Exception.Message
        try {
            $stream = $_.Exception.Response.GetResponseStream()
            $reader = New-Object System.IO.StreamReader($stream)
            $msg = $reader.ReadToEnd()
        } catch {}
        return @{ ok = $false; error = $msg }
    }
}

$DataRoot = Join-Path $PSScriptRoot "..\src\data\crags"
$files = Get-ChildItem -Path $DataRoot -Recurse -Filter "*.json" | Sort-Object FullName

# Group by crag
$cragMap = @{}
foreach ($file in $files) {
    $data = Get-Content $file.FullName -Raw -Encoding UTF8 | ConvertFrom-Json
    $key = (Norm $data.crag) + "|" + (Norm $data.region)
    if (-not $cragMap.ContainsKey($key)) {
        $cragMap[$key] = @{
            name = $data.crag
            country = $data.country
            region = $data.region
            province = $data.province
            municipality = $data.municipality
            sectors = [System.Collections.Generic.List[object]]::new()
        }
    }
    $cragMap[$key].sectors.Add(@{ name = $data.sector; routes = $data.routes })
}

$totalCrags = 0; $totalSectors = 0; $totalRoutes = 0; $errors = 0

foreach ($key in ($cragMap.Keys | Sort-Object)) {
    $crag = $cragMap[$key]
    $regionKey = (Norm $crag.region) -replace "[']", "'"
    # Fix apostrophe for Valle d'Aosta
    $regionId = $REGION_IDS[$regionKey]
    if (-not $regionId) {
        # Try with actual apostrophe
        foreach ($k in $REGION_IDS.Keys) {
            if ((Norm $k) -eq (Norm $crag.region)) {
                $regionId = $REGION_IDS[$k]
                break
            }
        }
    }
    if (-not $regionId) {
        Write-Host "  SKIP (no region): $($crag.name) / $($crag.region)" -ForegroundColor Yellow
        continue
    }

    $lines = [System.Collections.Generic.List[string]]::new()
    $lines.Add("DO `$`$")
    $lines.Add("DECLARE")
    $lines.Add("  v_crag_id   uuid;")
    $lines.Add("  v_sector_id uuid;")
    $lines.Add("BEGIN")

    $lines.Add("  SELECT id INTO v_crag_id FROM crags")
    $lines.Add("    WHERE lower(name) = lower($(SqlEsc $crag.name))")
    $lines.Add("      AND region_id = '$regionId' LIMIT 1;")
    $lines.Add("  IF v_crag_id IS NULL THEN")
    $lines.Add("    SELECT id INTO v_crag_id FROM crags")
    $lines.Add("      WHERE lower(name) = lower($(SqlEsc $crag.name)) AND region_id IS NULL LIMIT 1;")
    $lines.Add("    IF v_crag_id IS NOT NULL THEN")
    $countryId = $COUNTRY_IDS[($crag.country).ToLower()]
    if (-not $countryId) { $countryId = $COUNTRY_IDS["italy"] }
    $lines.Add("      UPDATE crags SET region_id = '$regionId', country_id = '$countryId',")
    $lines.Add("        region = $(SqlEsc $crag.region), province = $(SqlEsc $crag.province),")
    $lines.Add("        municipality = $(SqlEsc $crag.municipality)")
    $lines.Add("      WHERE id = v_crag_id;")
    $lines.Add("    ELSE")
    $lines.Add("      INSERT INTO crags (name, normalized_name, slug, country, country_id, region, region_id, province, municipality, access_status, rainproof, services, aliases)")
    $lines.Add("      VALUES ($(SqlEsc $crag.name), $(SqlEsc (Norm $crag.name)), $(SqlEsc (Slug $crag.name)),")
    $lines.Add("              $(SqlEsc $crag.country), '$countryId', $(SqlEsc $crag.region), '$regionId',")
    $lines.Add("              $(SqlEsc $crag.province), $(SqlEsc $crag.municipality), 'open', false, '{}', '{}')")
    $lines.Add("      RETURNING id INTO v_crag_id;")
    $lines.Add("    END IF;")
    $lines.Add("  END IF;")

    $sectorCount = 0
    $routeCount = 0
    foreach ($sector in $crag.sectors) {
        $sectorCount++
        $lines.Add("  SELECT id INTO v_sector_id FROM sectors")
        $lines.Add("    WHERE lower(name) = lower($(SqlEsc $sector.name)) AND crag_id = v_crag_id LIMIT 1;")
        $lines.Add("  IF v_sector_id IS NULL THEN")
        $lines.Add("    INSERT INTO sectors (name, normalized_name, slug, crag_id, aliases, sort_order)")
        $lines.Add("    VALUES ($(SqlEsc $sector.name), $(SqlEsc (Norm $sector.name)), $(SqlEsc (Slug $sector.name)), v_crag_id, '{}', 0)")
        $lines.Add("    RETURNING id INTO v_sector_id;")
        $lines.Add("  END IF;")
        foreach ($route in $sector.routes) {
            $routeCount++
            $grade = if ($null -eq $route.grade) { "NULL" } else { SqlEsc $route.grade }
            $lines.Add("  INSERT INTO routes (name, normalized_name, slug, official_grade, sector_id, crag_id, source, pitches, repetitions_count, route_type)")
            $lines.Add("  SELECT $(SqlEsc $route.name), $(SqlEsc (Norm $route.name)), $(SqlEsc (Slug $route.name)), $grade, v_sector_id, v_crag_id, 'pdf_import', 1, 0, 'sport'")
            $lines.Add("  WHERE NOT EXISTS (SELECT 1 FROM routes WHERE lower(name) = lower($(SqlEsc $route.name)) AND sector_id = v_sector_id);")
        }
    }

    $lines.Add("END `$`$;")
    $sql = $lines -join "`n"

    $result = Exec-Query $sql
    if ($result.ok) {
        $totalCrags++
        $totalSectors += $sectorCount
        $totalRoutes += $routeCount
        Write-Host "  OK  $($crag.name) ($sectorCount sectors, $routeCount routes)" -ForegroundColor Green
    } else {
        $errors++
        Write-Host "  ERR $($crag.name): $($result.error)" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Done: $totalCrags crags, $totalSectors sectors, $totalRoutes routes, $errors errors"
