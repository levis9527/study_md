-module (tut16).
-export ([start/0, ping/1, pong/0]).

ping(0) ->
	pong ! finished,
	io:format("ping finished~n", []);
ping(N) ->
	pong ! {ping, self()},
	receive
		pong ->
			io:format("ping receive pong~n")
	end,
	ping(N - 1).

pong() ->
	receive
		finished ->
			io:format("pong finished~n");
		{ping, Ping_PID} ->
			io:format("pong receive ping, Ping_PID is ~p~n", [Ping_PID]),
			Ping_PID ! pong,
			pong()
	end.

start() ->
	register(pong, spawn(tut16, pong, [])).
	% spawn(tut16, ping, [3]).