# Usage

* write your test suite in a function (using |&: to not ruin the report)
* TAP/prove this test suite

## Example

the example from `t/00_tests.zsh` is

    uze TAP :all

    demoish_test_suite () {
        plan 2
        note 'this is much more a demo than a test suite' \
             'you can add multiline notes' \
             'also you can get notes from stdin using note-' \
             'like:'
        { echo this test is run on; hostname } | note-
        true  ; ok "truth is known"
        false ; not_ok "lies are revealed"
    }

    TAP/prove demoish_test_suite

you can run it using zsh to get the raw TAP but it is recommended
to use the `prove` command from the perl toolchain to get reporting
with various options and rendering formats (like HTML).

another test suite can be

    uze TAP :all

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

    TAP/prove test_multios

so `zsh yourtestfile.zsh` will give you

    # create temporary files
    ok 1 - mktemp a worked fine
    ok 2 - mktemp b worked fine
    # the actual use of multios redirection
    ok 3 - files are the same
    # removing temp files
    1..3

## Functions

# `TAP/do`, `TAP/done`, `TAP/prove`

`TAP/do` starts a test suite and setup a default context
with default arguments and those passed as parameters

when the test is done, be sure everything was reported by calling
`TAP/done`

example

    uze TAP :all
    TAP/do plan 2 # see TAP/plan for more explain
    repeat 2 { true ; ok "i get the plan" }
    TAP/done
    1..2
    ok 1 - i get the plan
    ok 2 - i get the plan
    ok 3 - i get the plan

you also can embed the test suite in a function then call it with `TAP/prove`

    uze TAP :all

    tree_tests_in_a_row () {
        plan 3
        repeat 3 { true ; ok "i get the plan" }
    }

    TAP/prove tree_tests_in_a_row

# `TAP/plan`

set and annonce the number of tests to be run

    uze TAP :all
    TAP/do plan 2 # see TAP/plan for more explain
    repeat 3 { true ; ok "i get the plan" }
    TAP/done

    1..2
    ok 1 - i get the plan
    ok 2 - i get the plan
    ok 3 - i get the plan
    not ok 4 - planned to run 2 and run 3 of them

# `TAP/ok` and `TAP/not_ok`

test if the last return value is `true` or `false`

    uze TAP :all
    everything_s_ok () {
        plan 4
        true           ; ok        "true is ok"
        false          ; not_ok    "false is not ok"
        () {return 0}  ; ok        "0  is ok"
        () {return 12} ; not_ok    "12 is not ok"
    }
    TAP/prove everything_s_ok

    1..4
    ok 1 - true is ok
    ok 2 - false is not ok
    ok 3 - 0  is ok
    ok 4 - 12 is not ok

# `TAP/is` and `TAP/isnt`

test if `$1` and `$2` are identical (`is`) or not (`isnt`),
`$3` is the description of the test

    uze TAP :all
    does_math () {
        plan 3
        local desc expected got
        for   desc expected got (
            'math 1 + 1 = 2' $(( 1 + 1 )) 2
            'math 1 * 1 = 1' $(( 1 * 1 )) 1
        ) is $got $expected $desc
        isnt $((4 + 3 )) 5 "bad math deteced"
    }
    TAP/prove does_math

    1..3
    ok 1 - math 1 + 1 = 2
    ok 2 - math 1 * 1 = 1
    ok 3 - bad math deteced

# `TAP/expected` and `TAP/unexpected`

    uze TAP :all
    does_math () {
        plan 4
        local got expected
        for expected got (
            $(( 1 + 1 )) 2
            $(( 1 * 1 )) 1
        ) expected
        for expected got (
            $(( 1 + 1 )) 123
            $(( 1 * 1 )) 135
        ) unexpected
    }
    TAP/prove does_math

    1..4
    ok 1 -  got 2 when 2 expected
    ok 2 -  got 1 when 1 expected
    ok 3 -  got 123 when 2 expected
    ok 4 -  got 135 when 1 expected

# `TAP/note` and `TAP/note-`

add comments in your report.

each argument of `note` is a line of comment.
`note-` includes the `stdin` as comment

    uze TAP :all
    TAP/do plan 1
    note 'this is a line of comment' \
        'another one'
    yes "and another" | sed 3q | note-
    true ; ok true
    TAP/done

    1..1
    # this is a line of comment
    # another one
    # and another
    # and another
    # and another
    ok 1 - true

# `TAP/set`

add pairs to the `$TAPCTX`

    uze TAP :all
    TAP/do plan 3
    set -- foo wow bar haha
    TAP/set "$@"
    % { is $TAPCTX[$k] $v "$k is set" }
    is $TAPCTX[plan] 3 "plan is set"
    TAP/done

    1..3
    ok 1 - foo is set
    ok 2 - bar is set
    ok 3 - plan is set

