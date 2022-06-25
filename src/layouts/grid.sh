#!/usr/bin/env bash

source "$ROOT/utils/layout.sh";

setup_layout() {
  rotate '@/' horizontal 90;
  rotate '@/2' vertical 90;
}

execute_layout() {
  local target='first';

  for node in $(bspc query --nodes --node .local.window | sort); do
    bspc node $node --to-node "$(bspc query --nodes --node @/${target})";
    [[ "$target" == 'first' ]] && target='second' || target='first';
  done;

  auto_balance '@/';
}

cmd=$1; shift;
case "$cmd" in
  run) execute_layout "$@" ;;
  setup) setup_layout "$@" ;;
  *) ;;
esac;
