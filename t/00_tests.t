uze TAP :all

# you can start this script with
# prove -ezsh t/00_tests.zsh
# once you load the test suite
# note  that prove is a function from TAP.zsh

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
