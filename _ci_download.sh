#!/bin/bash
# Scarica i PDF /vie/print di tutte le falesie in crags.json (rate-limit, resume).
W="$1"
UA="CapitalClimbingPersonalImporter/0.1"
LOG="$W/out/download.log"
total=$(wc -l < "$W/out/_urls.tsv")
i=0; ok=0; skip=0; fail=0
echo "START $(date) total=$total" > "$LOG"
while IFS=$'\t' read -r id url; do
  i=$((i+1))
  out="$W/pdfs/$id.pdf"
  if [ -s "$out" ] && head -c4 "$out" | grep -q '%PDF'; then skip=$((skip+1)); continue; fi
  code=$(curl -skL -A "$UA" "$url" -o "$out" -w '%{http_code}')
  if head -c4 "$out" 2>/dev/null | grep -q '%PDF'; then
    ok=$((ok+1)); echo "[$i/$total] OK $id ($code)" >> "$LOG"
  else
    fail=$((fail+1)); echo "[$i/$total] FAIL $id http=$code" >> "$LOG"; rm -f "$out"
  fi
  sleep 3
done < "$W/out/_urls.tsv"
echo "DONE $(date) ok=$ok skip=$skip fail=$fail" >> "$LOG"
