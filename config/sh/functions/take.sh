#!/bin/sh

_take_archive_url() {
  case "$1" in
    http://*|https://*|ftp://*)
      case "${1%%\?*}" in
        *.tar.bz2|*.tar.gz|*.tar.xz|*.zip|*.rar|*.bz2|*.gz|*.tar|*.tbz2|*.tgz|*.Z|*.7z|*.xz|*.exe)
          return 0
          ;;
      esac
      ;;
  esac

  return 1
}

_take_git_url() {
  case "$1" in
    *.git|*.git/)
      case "$1" in
        http://*|https://*|git://*|ssh://*|ftp://*|ftps://*|rsync://*|*@*:*|*+@*)
          return 0
          ;;
      esac
      ;;
  esac

  return 1
}

mkcd() {
  if [ -z "$1" ]; then
    echo "Usage: mkcd <dir>" >&2
    return 1
  fi

  mkdir -p -- "$1" || return 1
  cd -- "$1" || return 1
  pwd -P
}

takegit() {
  if [ -z "$1" ]; then
    echo "Usage: takegit <repo-url>" >&2
    return 1
  fi

  git clone "$1" || return 1

  repo_path=${1%/}
  repo_name=${repo_path##*/}
  repo_name=${repo_name%.git}

  cd -- "$repo_name" || return 1
}

takeurl() {
  if [ -z "$1" ]; then
    echo "Usage: takeurl <url>" >&2
    return 1
  fi

  if ! command -v extract >/dev/null 2>&1; then
    echo "takeurl: extract command not found in PATH" >&2
    return 1
  fi

  url_no_query=${1%%\?*}
  url_no_query=${url_no_query%%\#*}
  filename=${url_no_query##*/}

  if [ -z "$filename" ] || [ "$filename" = "/" ] || [ "${filename#*.}" = "$filename" ]; then
    echo "takeurl: URL must include an archive filename with extension" >&2
    return 1
  fi

  tmpdir=$(mktemp -d "${TMPDIR:-/tmp}/takeurl.XXXXXXXX") || return 1
  data="$tmpdir/$filename"

  if ! curl -fL "$1" -o "$data"; then
    rm -rf -- "$tmpdir"
    return 1
  fi

  result_path=$(extract "$data")
  extract_status=$?
  rm -rf -- "$tmpdir"

  if [ "$extract_status" -ne 0 ]; then
    return "$extract_status"
  fi

  if [ -n "$result_path" ]; then
    printf '%s\n' "$result_path"
  fi

  if [ -d "$result_path" ]; then
    cd -- "$result_path" || return 1
  fi
}

take() {
  if [ -z "$1" ]; then
    echo "Usage: take <dir|repo-url|archive-url>" >&2
    return 1
  fi

  if _take_archive_url "$1"; then
    takeurl "$1"
  elif _take_git_url "$1"; then
    takegit "$1"
  else
    mkcd "$@"
  fi
}