
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

