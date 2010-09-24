-module(rabbit_publisher_sup).
-author('Andy Gross <andy@basho.com>').
-behaviour(supervisor).

%% External exports
-export([start_link/0]).
%% supervisor callbacks
-export([init/1]).

%% @spec start_link() -> ServerRet
%% @doc API for starting the supervisor.
start_link() ->
    supervisor:start_link({local, ?MODULE}, ?MODULE, []).


%% @spec init([]) -> SupervisorTree
%% @doc supervisor callback.
init([]) ->
    Processes = [
                 {rabbit_publisher_server,
                  {rabbit_publisher_server, start_link, []},
                  permanent, 5000, worker, [rabbit_publisher_server]}
                ],
    {ok, {{one_for_one, 9, 10}, Processes}}.
