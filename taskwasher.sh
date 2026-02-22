#!/bin/bash
# taskwasher - 指定リポジトリから自分にアサインされたIssueを一覧表示するツール

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
REPO_FILE="${SCRIPT_DIR}/repositories.txt"

# オプション解析
OPEN_BROWSER=false
for arg in "$@"; do
  case "$arg" in
    --open) OPEN_BROWSER=true ;;
    --help|-h)
      echo "Usage: taskwasher.sh [--open]"
      echo "  --open  全IssueのURLをブラウザで開く"
      exit 0
      ;;
  esac
done

if [[ ! -f "$REPO_FILE" ]]; then
  echo "Error: ${REPO_FILE} が見つかりません" >&2
  exit 1
fi

# URL収集用配列
ISSUE_URLS=()

while IFS= read -r url || [[ -n "$url" ]]; do
  # 空行・コメント行をスキップ
  [[ -z "$url" || "$url" == \#* ]] && continue

  # URLからオーナー/リポジトリ名を抽出
  repo=$(echo "$url" | sed 's|https://github.com/||')

  echo "===== ${repo} ====="

  # Issue一覧を取得して表示 & URL収集
  issues=$(gh issue list --repo "$repo" --assignee @me --state open \
    --json number,title,url \
    --template '{{range .}}#{{.number}}	{{.title}}	{{.url}}{{"\n"}}{{end}}')

  echo "$issues"

  if [[ "$OPEN_BROWSER" == true ]]; then
    while IFS= read -r line; do
      [[ -z "$line" ]] && continue
      issue_url=$(echo "$line" | awk -F'\t' '{print $NF}')
      [[ -n "$issue_url" ]] && ISSUE_URLS+=("$issue_url")
    done <<< "$issues"
  fi

  echo ""
done < "$REPO_FILE"

# --open: 全URLをブラウザで開く
if [[ "$OPEN_BROWSER" == true && ${#ISSUE_URLS[@]} -gt 0 ]]; then
  echo "🌐 ${#ISSUE_URLS[@]}件のIssueをブラウザで開きます..."
  for issue_url in "${ISSUE_URLS[@]}"; do
    open "$issue_url"
  done
fi
