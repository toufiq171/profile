#!/usr/bin/env bash
set -euo pipefail

SCRIPT_NAME="site-agent"

print_help() {
  cat <<'EOF'
site-agent: simple manager for your GitHub Pages profile site

Usage:
  ./site-agent.sh status
  ./site-agent.sh preview [port]
  ./site-agent.sh sync
  ./site-agent.sh publish "commit message"
  ./site-agent.sh help

Commands:
  status              Show branch, changes, and Pages URL
  preview [port]      Run local preview server (default: 8080)
  sync                Pull latest changes from remote main branch
  publish "message"   Add, commit, and push all changes
  help                Show this help message
EOF
}

require_repo() {
  if [[ ! -d .git ]]; then
    echo "Error: run this command from your repo root." >&2
    exit 1
  fi
}

repo_slug() {
  local remote_url
  remote_url="$(git remote get-url origin 2>/dev/null || true)"
  if [[ -z "$remote_url" ]]; then
    echo ""
    return
  fi

  if [[ "$remote_url" =~ github.com[:/]([^/]+)/([^/.]+)(\.git)?$ ]]; then
    echo "${BASH_REMATCH[1]}/${BASH_REMATCH[2]}"
  else
    echo ""
  fi
}

pages_url() {
  local slug owner repo
  slug="$(repo_slug)"
  if [[ -z "$slug" ]]; then
    echo "Unknown (origin remote not set to GitHub)"
    return
  fi

  owner="${slug%%/*}"
  repo="${slug##*/}"

  if [[ "$repo" == "${owner}.github.io" ]]; then
    echo "https://${owner}.github.io/"
  else
    echo "https://${owner}.github.io/${repo}/"
  fi
}

cmd_status() {
  echo "== Branch and sync =="
  git status --short --branch
  echo
  echo "== Last commit =="
  git log -1 --oneline
  echo
  echo "== Expected Pages URL =="
  pages_url
}

cmd_preview() {
  local port="${1:-8080}"
  if ! command -v python3 >/dev/null 2>&1; then
    echo "Error: python3 is required for local preview." >&2
    exit 1
  fi

  echo "Preview running at http://localhost:${port}"
  python3 -m http.server "$port"
}

cmd_sync() {
  git pull --rebase origin main
  echo "Synced with origin/main."
}

cmd_publish() {
  local message="${1:-}"
  if [[ -z "$message" ]]; then
    echo "Error: provide a commit message." >&2
    echo "Example: ./site-agent.sh publish \"Update homepage content\"" >&2
    exit 1
  fi

  git add -A

  if git diff --cached --quiet; then
    echo "No changes to commit."
    exit 0
  fi

  git commit -m "$message"
  git push origin main
  echo
  echo "Published successfully."
  echo "Live site: $(pages_url)"
}

main() {
  local command="${1:-help}"
  shift || true

  require_repo

  case "$command" in
    status) cmd_status "$@" ;;
    preview) cmd_preview "$@" ;;
    sync) cmd_sync ;;
    publish) cmd_publish "$@" ;;
    help|-h|--help) print_help ;;
    *)
      echo "Unknown command: $command" >&2
      print_help
      exit 1
      ;;
  esac
}

main "$@"
