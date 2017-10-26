devel/TAP/prove () {
    typeset -A with
    while [[ $argv[1] = :* ]] { with+=( $argv[1,2] ); shift 2 }

    (( ${+with[:plan]} )) && print 1..$with[:plan]

    local got expected
    local _test_tap_index=0
    "$@"

    (( ${+with[:plan]} )) || print 1..$_test_tap_index

}

devel/TAP/ok () {
    local _tap_test_r=$?
    if (( !_tap_test_r )) {
        print "ok $[++_test_tap_index] $1"
    } else {
        print "not ok $[++_test_tap_index] $1"
    }
    return $_tap_test_r
}

devel/TAP/not_ok () { ! (( $? )); ok "$@" }

devel/TAP/note () {
    local r=$?
    print "# $*"
    return $r
}

devel/TAP/note- () {
    local r=$?
    sed 's/^/# /'
    print "# $*"
    return $r
}

devel/TAP/is   () {   [[ "$1" == "$2" ]]; devel/TAP/ok "$3" }
devel/TAP/isnt () { ! [[ "$1" == "$2" ]]; devel/TAP/ok "$3" }
devel/TAP/expected   () { devel/TAP/is   "$got" "$expected" "$1" }
devel/TAP/unexpected () { devel/TAP/isnt "$got" "$expected" "$1" }

devel/TAP/_export_ () {
    typeset -A all; all=( ok prove is note )
    fns $all
    tag :all $fns
}

uze/import/devel/TAP () {
    EXPORT_TAGS=( :all 'ok prove is note expected diag' )
}
