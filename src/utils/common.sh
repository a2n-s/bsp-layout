# shellcheck disable=SC2148

jget() {
    key=$1
    shift
    var=${*#*\""$key"\":}
    var=${var%%[,\}]*}
    echo "$var"
}
