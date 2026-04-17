#!/usr/bin/env sh

set -eu

show_dependency_results() {
  manifest_path=$1
  missing=0
  found_any=0

  if grep -q '"openspec-cli"' "$manifest_path"; then
    found_any=1
    if command -v openspec >/dev/null 2>&1; then
      echo "Runtime dependencies:"
      echo "- openspec-cli [ok]"
    else
      echo "Runtime dependencies:"
      echo "- openspec-cli [missing]"
      missing=1
    fi
  fi

  if [ "$found_any" -eq 1 ]; then
    echo ""
  fi

  return "$missing"
}
