%% Template for application.

-module(imaku_app).
-behaviour(application).

-export([start/0, start/2, stop/1]). %% API.

-type application_start_type() :: normal
	| {takeover, node()} | {failover, node()}.

%% API.

-spec start() -> ok.
start() ->
	application:start(imaku).

-spec start(application_start_type(), any()) -> {ok, pid()}.
start(_Type, _Args) ->
	imaku_sup:start_link().

-spec stop(any()) -> ok.
stop(_State) ->
	ok.

%% Internal.
