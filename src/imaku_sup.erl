%% Template for supervisor.

-module(imaku_sup).
-behaviour(supervisor).

-export([start_link/0]). %% API.
-export([init/1]). %% supervisor.

-define(SUPERVISOR, ?MODULE).

%% API.

-spec start_link() -> {ok, pid()}.
start_link() ->
	supervisor:start_link({local, ?SUPERVISOR}, ?MODULE, []).

%% supervisor.

init([]) ->
	Procs = [
		{imaku_frame, {imaku_frame, start_link, []},
			transient, 5000, worker, dynamic}
	],
	{ok, {{one_for_one, 10, 10}, Procs}}.
