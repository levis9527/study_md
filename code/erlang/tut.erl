-module (tut).
-export ([double/1, fac/1, convert/1, test/1, list_length/1, sort/1, append/1, test_catch/2, re/1]).

% bit匹配，匹配一段二进制数据，一段一段的取，用<<>>包裹
% 算是最简单的解析二进制数据的方法了，<<A:6, B:10>> = <<213, 12>>直接给AB赋值
% bit example
% <<Characteristics : ?DWORD,
%      TimeDateStamp : ?DWORD,
%      MajorVersion : ?WORD,
%      MinVersion : ?WORD,
%      NumberOfNamedEntries : ?WORD,
%      NumberOfIdEntries : ?WORD>>.
% 定义宏，通过?宏名来调用
-define(DWORD, 32/unsigned-little-integer).
-define(LONG, 32/unsigned-little-integer).
-define(WORD, 16/unsigned-little-integer).
-define(BYTE, 8/unsigned-little-integer).

% 定义方法
double(X) ->
	2*X.

% 定义多个匹配要求的方法
fac(1) ->
	1;
fac(N) ->
	N + fac(N - 1).

convert({cm, X})->
	{m, X/100};
convert({m, X})->
	{cm, X*100}.

test([A|B])->
	A + test(B);
test([])->
	0.

list_length([_ | B])->
	1 + list_length(B);
list_length([])->
	0.

sort([]) ->
	[];
sort([Head | T]) ->
	sort([X || X <- T, X < Head]) ++
	[Head] ++
	sort([X || X <- T, X >= Head]).

% L格式未[[1,2,3], [4,5], [6,2]]，合并数组
append(L)   ->  
	[X || L1 <- L, X <- L1].

re([]) ->
	[];
re([Head | T]) ->
	re(T) ++ [Head].

% the try catch userd, like java, but not same as java
test_catch(A, B) ->
	% io:format("~p", [8/signed-little-integer]),
	% io:format("BYTE value is ~p", [?BYTE]),
	try dev(A, B) of
		{ok, Val} ->
			io:format("~p / ~p = ~p~n", [A, B, Val]);
		{error, Res} ->
			io:format("error, the res is ~p~n", [Res])
	catch
		X:Y -> {X, Y}
	end.

% dev(_, 0) ->
% 	{error, "by zero"};
dev(A, B) ->
	if
		B == 0 ->
			{error, "by zero"};
		true ->
			{ok, A / B}
	end,
	io:format("~p", ["func dev execute end"]),
	{ok, A / B}.
