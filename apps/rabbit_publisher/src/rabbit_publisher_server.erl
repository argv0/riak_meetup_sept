-module(rabbit_publisher_server).
-behaviour(gen_server).
-export([start_link/0]).
-export([init/1, handle_call/3, handle_cast/2, handle_info/2,
         terminate/2, code_change/3]).
-export([send/1]).
-record(state, {bunnyc_pid, qname}).

send(Message) -> gen_server:call(?MODULE, {send, Message}).

start_link() ->
    gen_server:start_link({local, ?MODULE}, ?MODULE, [], []).

init([]) ->
    {ok, IP} = application:get_env(rabbit_publisher, rabbit_ip),
    {ok, QName} = application:get_env(rabbit_publisher, rabbit_queue),
    {ok, Pid} = bunnyc:start_link(bunnyc_test, {network, IP},
                                  QName, []),
    {ok, #state{bunnyc_pid=Pid, qname=QName}}.

handle_call({send, Message}, _From, State=#state{bunnyc_pid=Pid, 
                                                 qname=QName}) ->
    {reply, bunnyc:publish(Pid, QName, Message), State}.

handle_cast(_Msg, State) -> {noreply, State}.
handle_info(_Info, State) -> {noreply, State}.
terminate(_Reason, _State) -> ok.
code_change(_OldVsn, State, _Extra) -> {ok, State}.




