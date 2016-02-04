uze devel/TAP :all

does_return_works () {
    local cmd ret
    for cmd ret (
        true  0
        false 1
    ) { $cmd
        does_return $ret "$cmd is $cmd" }
}

prove does_return_works
