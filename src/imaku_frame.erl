%% Hello. What are you doing here? You shouldn't be here.

-module(imaku_frame).

-behaviour(wx_object).

-export([start_link/0]). %% API.
-export([init/1, handle_call/3, handle_event/2,
	handle_info/2, terminate/2, code_change/3]). %% wx_object.

-include_lib("wx/include/wx.hrl").
-include_lib("wx/include/gl.hrl").
-include_lib("wx/include/glu.hrl").

-record(state, {
	frame,
	canvas,
	timer
}).

%% API.

start_link() ->
	{wx_ref, _N, wxFrame, Pid} = wx_object:start_link(?MODULE, [], []),
	{ok, Pid}.

%% wx_object.

init([]) ->
	wx:new([]),

	Frame = wxFrame:new(wx:null(), ?wxID_ANY, "imaku", [
		{size, {960, 540}},
		{style, ?wxDEFAULT_FRAME_STYLE
					bxor (?wxRESIZE_BORDER bor ?wxMAXIMIZE_BOX)
				band ?wxBORDER_NONE}
	]),
	wxFrame:show(Frame),

	Canvas = wx:batch(fun() ->
		Canvas = wxGLCanvas:new(Frame, [
			{size, {960, 540}}, {style, ?wxBORDER_NONE},
			{attribList, [
				?WX_GL_RGBA,
				?WX_GL_DOUBLEBUFFER,
				?WX_GL_MIN_RED, 8,
				?WX_GL_MIN_GREEN, 8,
				?WX_GL_MIN_BLUE, 8,
				?WX_GL_DEPTH_SIZE, 24, 0
			]}
		]),
		wxGLCanvas:setCurrent(Canvas),

		{W, H} = wxWindow:getClientSize(Canvas),
		gl:viewport(0, 0, W, H),
		gl:matrixMode(?GL_PROJECTION),
		gl:loadIdentity(),
		gl:ortho(-2.0, 2.0, -2.0 * H / W, 2.0 * H / W, -20.0, 20.0),
		gl:matrixMode(?GL_MODELVIEW),
		gl:loadIdentity(),
		gl:enable(?GL_DEPTH_TEST),
		gl:depthFunc(?GL_LESS),
		gl:clearColor(1.0, 1.0, 1.0, 1.0),
		Canvas
	end),

	wxFrame:layout(Frame),

	Timer = timer:send_interval(16, self(), update),

	{Frame, #state{frame=Frame, canvas=Canvas, timer=Timer}}.

handle_call(_Msg, _From, State) ->
	{reply, ok, State}.

handle_event(#wx{event=#wxClose{}}, State) ->
	{stop, normal, State};
handle_event(_Event, State) ->
	{noreply, State}.

handle_info(update, State=#state{canvas=Canvas}) ->
	gl:clear(?GL_COLOR_BUFFER_BIT bor ?GL_DEPTH_BUFFER_BIT),
	wxGLCanvas:swapBuffers(Canvas),
	{noreply, State};
handle_info(_Msg, State) ->
	{noreply, State}.

code_change(_, _, State) ->
	{stop, not_yet_implemented, State}.

terminate(_Reason, #state{timer=Timer}) ->
	timer:cancel(Timer),
	wx:destroy(),
	application:stop(imaku).
