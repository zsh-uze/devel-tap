TAP/prove () {
    typeset -A with
    while [[ $argv[1] = :* ]] { with+=( $argv[1,2] ); shift 2 }

    (( ${+with[:plan]} )) && print 1..$with[:plan]

    local got expected
    local _test_tap_index=0
    "$@"

    (( ${+with[:plan]} )) || print 1..$_test_tap_index

}

TAP/ok () {
    local _tap_test_r=$?
    if (( !_tap_test_r )) {
        print "ok $[++_test_tap_index] $1"
    } else {
        print "not ok $[++_test_tap_index] $1"
    }
    return $_tap_test_r
}

TAP/not_ok () {
    local r=$?
    ! (( $? )); ok "$@"
    return $r
}

TAP/note () {
    local r=$?
    print "# $*"
    return $r
}

TAP/note- () {
    local r=$?
    sed 's/^/# /'
    print "# $*"
    return $r
}

TAP/is   () {   [[ "$1" == "$2" ]]; TAP/ok "$3" }
TAP/isnt () { ! [[ "$1" == "$2" ]]; TAP/ok "$3" }
TAP/expected   () { TAP/is   "$got" "$expected" "$1" }
TAP/unexpected () { TAP/isnt "$got" "$expected" "$1" }

uze/export/TAP () {
    delegate=true
    EXPORT_TAGS=( :all 'ok not_ok prove is note expected diag' )
}
