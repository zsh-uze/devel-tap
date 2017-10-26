# Usage

* write your test suite in a function (using |&: to not ruin the report)
* devel/TAP/prove this test suite

# Example

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
