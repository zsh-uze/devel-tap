uze TAP :all

tree_tests_in_a_row () {
    plan   3
    repeat 3 { true ; ok "i get the plan" }
}

TAP/prove tree_tests_in_a_row
