TAP/plan/announce () { print ${TAPCTX[start]}..${TAPCTX[plan]} }

TAP/plan () {
    TAPCTX[plan]=${1?number of tests in the new plan}
    TAP/plan/announce
}

TAP/set () { TAPCTX+=( "$@" ) }
TAP/start () {
    TAP/set plan 0 index 0 "$@"
    (( TAPCTX[plan] )) &&
        TAP/plan/announce
}

TAP/done () {
    case $TAPCTX[plan] {
        (0) print ${TAPCTX[start]}..${TAPCTX[index]} ;;
        (*) (( TAPCTX[index] == TAPCTX[plan] )) || {
                false;
                ok "planned to run ${TAPCTX[plan]} and run ${TAPCTX[index]} of them"
            }
    }
}

# not ok 5 - planned to run 3 but done_testing() expects 4
# #   Failed test 'planned to run 3 but done_testing() expects 4'
# #   #   at /tmp/a.pl line 6.
# #   # Looks like you planned 3 tests but ran 5.
# #   # Looks like you failed 1 test of 5 run
# #   '


alias TAP/do='my% TAPCTX=( index 0 start 1 plan 0 ); TAP/start'

TAP/prove () {
    TAP/do
    "$@"
    TAP/done }

% ( ok     '.not ok.ok'
    not_ok '.ok.not ok' )
        eval 'TAP/'$k' () {
        local r=$?
        (( r )) ; print -lP "%(?'$v') $(( ++TAPCTX[index] )) - $*"
        return $r }'

TAP/is   () {   [[ "$1" == "$2" ]]; TAP/ok "${3:-\"$1\" == \"$2\" }" }
TAP/isnt () { ! [[ "$1" == "$2" ]]; TAP/ok "${3:-\"$1\" == \"$2\" }" }
TAP/expected   () { TAP/is   "$got" "$expected" "${1:- got $got when $expected expected}" }
TAP/unexpected () { TAP/isnt "$got" "$expected" "${1:- got $got when $expected expected}" }
TAP/note () { local r=$?  ; say '# '$^@   ; return $r }
TAP/note- () { local r=$? ; sed 's/^/# /' ; return $r }

uze/export/TAP () {
    delegate=true
    EXPORT_TAGS=( :all 'prove ok not_ok plan is isnt note note- expected unexpected' )
}
