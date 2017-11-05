    uze TAP :all
    everything_s_ok () {
        plan 4
        true           ; ok        "true is ok"
        false          ; not_ok    "false is not ok"
        () {return 0}  ; ok        "0  is ok"
        () {return 12} ; not_ok    "12 is not ok"
    }
    TAP/prove everything_s_ok
