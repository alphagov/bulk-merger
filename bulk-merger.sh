#!/usr/bin/env bash
set -eu

cmd=$(basename "$0")
[[ -z "$*" ]] && echo 'usage: ./[list|merge|merge_only|review] query_string' && exit 64
[[ -r ".env" ]] && source .env

export QUERY_STRING="$*"
bundle exec rake "$cmd"
