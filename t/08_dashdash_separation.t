uze TAP :all

dashdash_test () {
    local bound
    note 'two lists, one w -- ($w), the other w/o ones ($wo)'
    my@ w=( first part -- second one )
    my@ wo=( a complete sentence wo dash )

    note "you can test if there are bounds"

    (( bound = wo[(I)--]  )); not_ok "no bound found"
    (( bound =  w[(I)--]  )); ok     "bound found"

    (( bound =  w[(I)--] ))
    ok non empty first part
    is $bound 3
    w=( -- no more first part )
    (( bound=w[(I)--] ))
    (( bound > 1 ))


    # is $bound 3 "you found it, arthur ..."
    # is "${w[1,bound-1]}" "first part"
    # is "${w[1,bound-1]}" "first part"

    # got="${w[0,(( -1 + (I)--))]}"
    # is $got "first part"
    # (( got = wo[(I)--] )); is $got 0 "there is no dashdash"

}
TAP/prove dashdash_test
