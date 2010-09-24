-module(rabbit_publisher_app).
-author('Andy Gross <andy@basho.com>').
-behaviour(application).
-export([start/2,stop/1]).

%% @spec start(Type :: term(), StartArgs :: term()) ->
%%          {ok,Pid} | ignore | {error,Error}
%% @doc The application:start callback for rabbit_publisher.
%%      Arguments are ignored as all configuration is done via the erlenv file.
start(_Type, _StartArgs) ->
    riak_core_util:start_app_deps(rabbit_publisher),
    rabbit_publisher:install_hook(),
    rabbit_publisher_sup:start_link().

%% @spec stop(State :: term()) -> ok
%% @doc The application:stop callback for rabbit_publisher.
stop(_State) -> ok.


    

