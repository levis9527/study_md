-module (tut14).
-export ([start/0, say_something/2]).
-import (tut6, [show/1]).

say_something(_, 0) ->
	ok;
say_something(What, Times) ->
	io:format("~p~n", [What]),
	say_something(What, Times -1).

start() ->
	spawn(tut14, say_something, ["hello", 3]),
	spawn(tut6, show, [91]).
	spawn(tut14, say_something, ["goodbye", 4]).