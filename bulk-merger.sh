#!/usr/bin/env bash
set -eu

cmd=$(basename "$0")
[[ -z "$*" ]] && echo 'usage: ./[list|merge|merge_only|review] repo_name_string query_string' && exit 64
[[ -r ".env" ]] && source .env

export REPO_STRING="$1"
shift
export QUERY_STRING="$*"
bundle exec rake "$cmd"
