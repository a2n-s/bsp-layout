#!/usr/bin/env bash


demo() {
  name=$1
  args=$2
  echo "bsp-layout would call: $name"
  echo "with following arguments:"

  for line in $(echo "$args" | awk -F: '{print $1, $2, $3}');
  do
      arg=$(echo "$line" | cut -d= -f1)
      value=$(echo "$line" | cut -d= -f2)
      echo -e "\t$arg: $value"
  done
}


main () {
  # define the possible flags of the application
  OPTIONS=$(getopt -o hvL:D:m: --long help,version,layouts:,desktop:,master-size: -n 'bsp-layout' -- "$@")
  if [ $? != 0 ] ; then echo "Terminating..." >&2 ; exit 1 ; fi
  eval set -- "$OPTIONS"

  # parse the flags.
  while [[ $# -gt 0 ]]; do
    case "$1" in
      -h | --help | help )       action="help"; shift 1 ;;
      -v | --version | version ) action="version"; shift 1 ;;
      -L | --layouts )           layouts="$2"; shift 2 ;;
      -D | --desktop )           desktop="$2"; shift 2 ;;
      -m | --master-size )       master_size="$2"; shift 2 ;;
      -- ) shift; break ;;
      * ) break ;;
    esac
  done

  # directly print help or version if the flags are raised
  [ "$action" = "help" ] && { demo "man bsp-layout"; exit 0; }
  [ "$action" = "version" ] && { demo "echo \"\$VERSION\""; exit 0; }

  # # bsp-layout does not accept multiple subcommands.
  # [ "$#" -gt 1 ] && { echo "bsp-layout only accepts one subcommand, got $# ($*)."; exit 1; }
  action=$1; shift;
  [ -z "$action" ] && { echo "No subcommand given to bsp-layout. Run bsp-layout help"; exit 2; }

  case "$action" in
    reload)            demo "reload_layouts" ;;
    once)              demo "once_layout" "layout=$1:desktop=$2:args=$master_size" ;;
    set)               demo "start_listener" "layout=$1:desktop=$2:args=$master_size" ;;
    previous)          demo "previous_layout" "layouts=$layouts:desktop=$desktop:args=$master_size" ;;
    next)              demo "next_layout" "layouts=$layouts:desktop=$desktop:args=$master_size" ;;
    get)               demo "get_layout" "desktop=$1" ;;
    remove)            demo "remove_listener" "desktop=$1" ;;
    layouts)           demo "list_layouts" ;;
    -h|--help|help)    demo "man bsp-layout" ;;
    -v|version)        demo "echo \"\$VERSION\"" ;;
    *)                 echo -e "Unknown subcommand '$action'. Run bsp-layout help" && exit 3 ;;
  esac
  exit 0
}


main "$@"
