%% I see clearly in your game.

-module(imaku_game).
-export([init/0, loop/2, terminate/1]).

-record(state, {
}).

-include_lib("wx/include/gl.hrl").

-spec init() -> #state{}.
init() ->
	#state{}.

loop(Canvas, State) ->
	gl:clear(?GL_COLOR_BUFFER_BIT bor ?GL_DEPTH_BUFFER_BIT),

	gl:color4f(1.0, 0.0, 0.0, 1.0),

	gl:'begin'(?GL_QUADS),
		gl:vertex2f( 0.0,  0.0),
		gl:vertex2f(50.0,  0.0),
		gl:vertex2f(50.0, 50.0),
		gl:vertex2f( 0.0, 50.0),
	gl:'end'(),

	wxGLCanvas:swapBuffers(Canvas),

	State.

terminate(_State) ->
	ok.
