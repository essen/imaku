%% I see clearly in your game.

-module(imaku_game).
-export([init/0, loop/2, terminate/1]).

-record(state, {
	bullets,
	scenes,
	objects,
	t = 0 %% Current frame number.
}).

-record(bullet, {
	class = generator,
	color = {0.0, 0.0, 0.0, 0.0},
	pos = {-10000.0, -10000.0},
	dims = {1.0, 1.0},
	dir = 0.0,
	speed = 0.0,
	accel = {0.0, 0.0},
	actions = [],
	wait = 0,
	vars = []
}).

-define(BEGIN, 'begin').
-define(END, 'end').

-include_lib("wx/include/gl.hrl").

%% API.

-spec init() -> #state{}.
init() ->
	io:format("Loading bullets...~n"),
	{ok, Bullets} = file:consult("priv/bullets.hrl"),
	io:format("Loading scenes...~n"),
	{ok, Scenes} = file:consult("priv/scenes.hrl"),
	{Name, Folder} = hd(Scenes),
	io:format("Loading scene ~s...~n", [Name]),
	{ok, [{scene, Scene1}]} = file:consult(["priv/", Folder, "/scene.hrl"]),
	io:format("Ready.~n"),
	#state{bullets=Bullets, scenes=Scenes, objects=[#bullet{actions=Scene1}]}.

loop(Canvas, State=#state{bullets=Bullets, objects=Objects, t=T}) ->
	Objects2 = update_scene(Bullets, Objects),
	gl:clear(?GL_COLOR_BUFFER_BIT bor ?GL_DEPTH_BUFFER_BIT),
	draw_scene(Objects2),
	wxGLCanvas:swapBuffers(Canvas),
	State#state{objects=Objects2, t=T + 1}.

terminate(_State) ->
	ok.

%% Engine.

update_scene(Bullets, Objects) ->
	update_scene(Bullets, Objects, []).
update_scene(_Bullets, [], Acc) ->
	lists:flatten(Acc);
update_scene(Bullets, [Object = #bullet{
		pos={X, Y}, dir=Dir, speed=Speed}|Tail], Acc) ->
	Dir2 = Dir - 90.0,
	X2 = X + Speed * math:cos(math:pi() * Dir2 / 180.0),
	Y2 = Y + Speed * math:sin(math:pi() * Dir2 / 180.0),
	Object2 = Object#bullet{pos={X2, Y2}},
	NewObjects = update_object(Bullets, Object2),
	update_scene(Bullets, Tail, [NewObjects|Acc]).

update_object(_Bullets, Object = #bullet{wait=Wait}) when Wait =/= 0 ->
	[Object#bullet{wait=Wait - 1}];
update_object(Bullets, Object = #bullet{actions=Actions}) ->
	update_object_actions(Bullets, Object, Actions, []).

update_object_actions(_Bullets, Object, [], Acc) ->
	[Object#bullet{actions=[]}|Acc];
update_object_actions(Bullets, Object = #bullet{vars=Vars},
		[{dir, VarName}|Tail], Acc) when is_atom(VarName) ->
	{VarName, Dir} = lists:keyfind(VarName, 1, Vars),
	update_object_actions(Bullets, Object#bullet{dir=Dir}, Tail, Acc);
update_object_actions(Bullets, Object, [{dir, Dir}|Tail], Acc) ->
	update_object_actions(Bullets, Object#bullet{dir=Dir}, Tail, Acc);
update_object_actions(Bullets, Object, [{fire, Class, Actions}|Tail], Acc) ->
	{Class, Dims, Col} = lists:keyfind(Class, 1, Bullets),
	New = Object#bullet{class=Class, color=Col, dims=Dims, actions=Actions},
	update_object_actions(Bullets, Object, Tail, [New|Acc]);
update_object_actions(Bullets, Object, [{repeat, N, Actions}|Tail], Acc) ->
	Expanded = [Actions || _I <- lists:seq(1, N)],
	update_object_actions(Bullets, Object, lists:flatten([Expanded|Tail]), Acc);
update_object_actions(Bullets, Object,
		[{spawn, Class, Pos, Actions}|Tail], Acc) ->
	{Class, Dims, Col} = lists:keyfind(Class, 1, Bullets),
	New = #bullet{class=Class, color=Col, pos=Pos, dims=Dims, actions=Actions},
	update_object_actions(Bullets, Object, Tail, [New|Acc]);
update_object_actions(Bullets, Object, [{speed, Speed}|Tail], Acc) ->
	update_object_actions(Bullets, Object#bullet{speed=Speed}, Tail, Acc);
update_object_actions(_Bullets, _Object, [vanish|_Tail], Acc) ->
	Acc;
update_object_actions(Bullets, Object = #bullet{vars=Vars},
		[{var, Name, Value}|Tail], Acc) ->
	Vars2 = lists:keydelete(Name, 1, Vars),
	Vars3 = [{Name, Value}|Vars2],
	update_object_actions(Bullets, Object#bullet{vars=Vars3}, Tail, Acc);
update_object_actions(Bullets, Object = #bullet{vars=Vars},
		[{var, Name, add, AddValue}|Tail], Acc) ->
	{Name, CurrentValue} = lists:keyfind(Name, 1, Vars),
	Vars2 = lists:keydelete(Name, 1, Vars),
	Vars3 = [{Name, CurrentValue + AddValue}|Vars2],
	update_object_actions(Bullets, Object#bullet{vars=Vars3}, Tail, Acc);
%% @todo getting value for use in speed/dir/...
update_object_actions(_Bullets, Object, [{wait, Wait}|Tail], Acc) ->
	[Object#bullet{actions=Tail, wait=Wait}|Acc].

draw_scene([]) ->
	ok;
draw_scene([#bullet{color={R, G, B, A}, pos={X, Y}, dims={W, H}}|Tail]) ->
	W2 = W / 2,
	H2 = H / 2,
	gl:color4f(R, G, B, A),
	gl:?BEGIN(?GL_QUADS),
		gl:vertex2f(X - W2, Y - H2),
		gl:vertex2f(X + W2, Y - H2),
		gl:vertex2f(X + W2, Y + H2),
		gl:vertex2f(X - W2, Y + H2),
	gl:?END(),
	draw_scene(Tail).
