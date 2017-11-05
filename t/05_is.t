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
