-module (server).
-export ([start_echo_server/0, echo_client_eval/1, test_wait/0, main/0]).

start_echo_server() ->
	{ok, Listen} = gen_tcp:listen(1234, [binary, {packet, 4}, {reuseaddr, true}, {active, true}]),
	{ok, Socket} = gen_tcp:accept(Listen),
	gen_tcp:close(Listen),
	loop(Socket).

loop(Socket) ->
	receive
		{tcp, Socket, Bin} ->
			io:format("serverreceived binary = ~p~n", [Bin]),
			Str = binary_to_term(Bin),
			io:format("server  (unpacked) ~p~n", [Str]),
			% Reply = lib_misc:string2value(Str),
			Reply = "***lib_misc:string2value(Str)****",
			io:format("serverreplying = ~p~n", [Reply]),
			gen_tcp:send(Socket, term_to_binary(Reply)),
			loop(Socket);
		{tcp_close, Socket} ->
			io:format("ServerSocket closed ~n")
	end.


echo_client_eval(Str) ->
	{ok, Socket} = gen_tcp:connect("localhost", 1234, [binary, {packet, 4}]),
	ok = gen_tcp:send(Socket, term_to_binary(Str)),
	receive
		{tcp, Socket, Bin} ->
			io:format("Clientreceived binary  = ~p~n", [Bin]),
			Val = binary_to_term(Bin),
			io:format("Clientresult = ~p~n", [Val]),
			gen_tcp:close(Socket)
	end.

test_wait() ->
	receive
		{ok, Msg} ->
			io:format("msg is ~p~n", [Msg]);
		_ ->
			io:format("server error")
	end,
	io:format("end, next---").

main() ->
	register(abbbbbbbbbbb, spawn(server, test_wait, [])).