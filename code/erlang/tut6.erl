%% find max value in list

-module (tut6).
-export ([list_max/1, show/1, test/2]).

list_max([Head | Rest]) ->
	list_max(Rest, Head).

list_max([], Res) ->
	Res;
list_max([Head | Rest], Rest_so_far) when Head > Rest_so_far ->
	New_res = Head,
	list_max(Rest, New_res);
list_max([Head | Rest], Rest_so_far) when Head =< Rest_so_far ->
	list_max(Rest, Rest_so_far).


show(Score)->
	if
		Score > 90 ->
			"youxiu";
		Score > 60 ->
			"jige";
		Score > 30 ->
			"jiabajin";
		true ->
			"nizheyangbuxinga"
	end.

test(F, Num) ->
	F(Num).