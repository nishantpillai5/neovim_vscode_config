#!/bin/bash
# Claude Code statusline: renders a status bar inside Claude Code and caches
# rate-limit usage to ~/.cache/claude/usage.json for the lualine component.
input=$(cat)

CACHE_DIR="$HOME/.cache/claude"
mkdir -p "$CACHE_DIR"

# Cache rate_limits whenever present (Pro/Max plans, after first API response)
rate_limits=$(echo "$input" | jq -c '.rate_limits // empty')
if [ -n "$rate_limits" ]; then
  echo "$rate_limits" | jq -c --argjson now "$(date +%s)" '. + {cached_at: $now}' \
    >"$CACHE_DIR/usage.json.tmp" && mv "$CACHE_DIR/usage.json.tmp" "$CACHE_DIR/usage.json"
fi

# Statusline shown inside Claude Code
MODEL=$(echo "$input" | jq -r '.model.display_name // "Claude"')
DIR=$(echo "$input" | jq -r '.workspace.current_dir // "?" | sub("^" + env.HOME; "~")')
CTX=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
FIVE_H=$(echo "$input" | jq -r '.rate_limits.five_hour.used_percentage // empty')
WEEK=$(echo "$input" | jq -r '.rate_limits.seven_day.used_percentage // empty')

line="[$MODEL] $DIR"
[ -n "$CTX" ] && line="$line | ctx $(printf '%.0f' "$CTX")%"
[ -n "$FIVE_H" ] && line="$line | 5h $(printf '%.0f' "$FIVE_H")%"
[ -n "$WEEK" ] && line="$line | 7d $(printf '%.0f' "$WEEK")%"
echo "$line"