-module(rabbit_publisher).
-author('Andy Gross <andy@basho.com>').
-export([start/0, stop/0]).
-export([install_hook/0, postcommit/1]).

-define(RABBIT_HOOK, {struct, 
                      [{<<"mod">>, <<"rabbit_publisher">>},
                       {<<"fun">>, <<"postcommit">>}]}).

start() ->
    riak_core_util:start_app_deps(rabbit_publisher),
    application:start(rabbit_publisher).

%% @spec stop() -> ok
stop() -> 
    application:stop(rabbit_publisher).

postcommit(Object) ->
    Msg = list_to_binary(mochijson2:encode(riak_object:get_value(Object))),
    rabbit_publisher_server:send(Msg).

install_hook() ->
    {ok, DefaultBucketProps} = application:get_env(riak_core, 
                                                   default_bucket_props),
    application:set_env(riak_core, default_bucket_props, 
                        proplists:delete(postcommit, DefaultBucketProps)),
    riak_core_bucket:append_bucket_defaults([{postcommit, [?RABBIT_HOOK]}]),
    ok.
    
