-module (tut15).
-export ([start/0, ping/2, pong/0]).

ping(0, Pong_PID) ->
	Pong_PID ! finished,
	io:format("ping finished~n", []);
ping(N, Pong_PID) ->
	Pong_PID ! {ping, self(), "hello"},
	receive
		pong ->
			io:format("Ping receive pong~n")
	end,
	ping(N - 1, Pong_PID).

pong() ->
	receive
		finished ->
			io:format("Pong finished~n", []);
		{ping, Ping_PID, Str} ->
			io:format("Pong receive Ping ~p~n", [Str]),
			Ping_PID ! pong,
			pong()
	end.

start() ->
	Pong_PID = spawn(tut15, pong, []),
	spawn(tut15, ping, [3, Pong_PID]).
