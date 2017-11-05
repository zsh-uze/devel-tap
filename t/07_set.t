uze TAP :all
TAP/do plan 3
set -- foo wow bar haha
TAP/set "$@"
% { is $TAPCTX[$k] $v "$k is set" }
is $TAPCTX[plan] 3 "plan is set"
TAP/done
