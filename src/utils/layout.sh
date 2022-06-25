source "$ROOT/utils/common.sh";

# amend the split type so we are arranged correctly
rotate() {
  node=$1;
  want=$2;
  have=$(jget splitType "$(bspc query --tree --node "$node")");
  have=${have:1:${#have}-2};
  angle=$3;

  if [[ "$have" != "$want" ]]; then
    bspc node "$node" --rotate "$angle";
  fi
}

auto_balance() { bspc node "$1" --balance; }
