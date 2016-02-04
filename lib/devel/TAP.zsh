: <<'=cut'

=head1 Usage

* write your test suite in a function (using |&: to not ruin the report)
* devel/TAP/prove this test suite

=head1 Example

see the output at the end of the section

    . uze/devel/TAP

    # alias
    for REPLY (note ok prove)
        alias $REPLY=devel/TAP/$REPLY

    test_multios () { 

        note "create temporary files" 

        local a b
        a=`mktemp` b=`mktemp` 

        [[ -f $a ]]; ok "mktemp a worked fine"
        [[ -f $b ]]; ok "mktemp b worked fine"

        note "the actual use of multios redirection"
        echo foo > $a > $b  

        cmp $a $b; ok "files are the same"  
        
        note "removing temp files"
        rm $a $b |&:
    }

    prove test_multios

if setopt is activated, you'll see

    # create temporary files
    ok 1 - mktemp a worked fine
    ok 2 - mktemp b worked fine
    # the actual use of multios redirection
    ok 3 - files are the same
    # removing temp files
    1..3

=cut

uze/pkg

$0/prove () {
    typeset -A with
    while [[ $argv[1] = :* ]] { with+=( $argv[1,2] ); shift 2 }

    (( ${+with[:plan]} )) && print 1..$with[:plan]

    local got expected
    local _test_tap_index=0
    "$@"

    (( ${+with[:plan]} )) || print 1..$_test_tap_index

}

$0/ok () {
    local _tap_test_r=$?
    if (( !_tap_test_r )) {
        print "ok $[++_test_tap_index] $1"
    } else {
        print "not ok $[++_test_tap_index] $1"
    }
    return $_tap_test_r
}

$0/not_ok () { ! (( $? )); ok "$@" }

$0/note () {
    local r=$?
    print "# $*"
    return $r
}

$0/note- () {
    local r=$?
    sed 's/^/# /'
    print "# $*"
    return $r
}

$0/is   () {   [[ "$1" == "$2" ]]; devel/TAP/ok "$3" }
$0/isnt () { ! [[ "$1" == "$2" ]]; devel/TAP/ok "$3" }
$0/expected   () { devel/TAP/is   "$got" "$expected" "$1" }
$0/unexpected () { devel/TAP/isnt "$got" "$expected" "$1" }

# _export_ seems to be a good idea
# :_oo_methods for objects ?

$0/_export_ () {
    typeset -A all; all=( ok prove is note )
    fns $all
    tag :all $fns
}

#uze/import/$0/:all  () { UZE+=(  ok prove is note note- expected ) }
uze/import/$0 () {
    EXPORT_TAGS=( :all 'ok prove is note expected diag' )
}
