#!/bin/bash
# Heartbeat 数据自动同步到 GitHub

REPO_DIR="/opt/Dylan-heartbeat"
LOG_FILE="/opt/Dylan-heartbeat/sync_heartbeat.log"

# 需要同步的文件列表
FILES=(
  "wake_prompt.txt"
  "server.js"
  "wake_up.js"
)

cd "$REPO_DIR" || exit 1

# 拉取最新代码
git pull origin main --quiet 2>>"$LOG_FILE"

CHANGED=false

for file in "${FILES[@]}"; do
  if [ -f "$REPO_DIR/$file" ]; then
    if ! git diff --quiet "$file" 2>/dev/null; then
      CHANGED=true
    fi
  fi
done

if [ "$CHANGED" = true ]; then
  git add -f "${FILES[@]}"
  git commit -m "auto sync heartbeat data: $(date '+%Y-%m-%d %H:%M:%S')" >>"$LOG_FILE" 2>&1
  git push origin main >>"$LOG_FILE" 2>&1
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] 同步完成" >>"$LOG_FILE"
else
  echo "[$(date '+%Y-%m-%d %H:%M:%S')] 无变化，跳过" >>"$LOG_FILE"
fi
