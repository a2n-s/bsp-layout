#!/usr/bin/env bash

source "$ROOT/utils/common.sh";
source "$ROOT/utils/layout.sh";
source "$ROOT/utils/config.sh";

master_size=$TALL_RATIO;

node_filter="!hidden";

execute_layout() {
  while [[ ! "$#" == 0 ]]; do
    case "$1" in
      --master-size) master_size="$2"; shift; ;;
      *) echo "$x" ;;
    esac;
    shift;
  done;

  # ensure the count of the master child is 1, or make it so
  local nodes=$(bspc query --nodes '@/2' --node .descendant_of.window.$node_filter);
  local win_count=$(echo "$nodes" | wc -l);

  if [ $win_count -ne 1 ]; then
    local new_node=$(bspc query --nodes '@/2' --node last.descendant_of.window.$node_filter | head -n 1);

    if [ -z "$new_node" ]; then
      new_node=$(bspc query --nodes '@/1' --node last.descendant_of.window.$node_filter | head -n 1);
    fi

    local root=$(echo "$nodes" | head -n 1);

    # move everything into 2 that is not our new_node
    for wid in $(bspc query --nodes '@/2' --node .descendant_of.window.$node_filter | grep -v $root); do
      bspc node "$wid" --to-node '@/1';
    done

    bspc node "$root" --to-node '@/2';
  fi

  rotate '@/' vertical 90;
  rotate '@/2' horizontal 90;

  local stack_node=$(bspc query --nodes '@/1' --node);
  for parent in $(bspc query --nodes '@/1' --node .descendant_of.!window.$node_filter | grep -v $stack_node); do
    rotate $parent horizontal 90;
  done

  auto_balance '@/1';

  local mon_width=$(jget width "$(bspc query --tree --monitor)");

  local want=$(echo "$master_size * $mon_width" | bc | sed 's/\..*//');
  local have=$(jget width "$(bspc query --tree --node '@/2')");

  bspc node '@/2' --resize left $((have - want)) 0;
}

cmd=$1; shift;
case "$cmd" in
  run) execute_layout "$@" ;;
  *) ;;
esac;
