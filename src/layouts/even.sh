#!/usr/bin/env bash
# shellcheck disable=SC1091

source "$ROOT/utils/layout.sh";

execute_layout() {
  auto_balance '@/';
}

cmd=$1; shift;
case "$cmd" in
  run) execute_layout "$@" ;;
  *) ;;
esac;
