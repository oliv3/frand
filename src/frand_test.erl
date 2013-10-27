-module(frand_test).

-compile([export_all, native]).

-export([test/1, test/2, test/3]).

-export([compare/0]).

-define(SEED, 12345).
-define(MAX,  100).


test([S0, N0]) ->
    S = list_to_integer(atom_to_list(S0)),
    N = list_to_integer(atom_to_list(N0)),
    test(S, N).

test(S, N) ->
    frand:srand48(S),
    V = [X rem ?MAX || X <- frand:vector(N)],
    Res = {S, V},
    io:format("~w.~n", [Res]),
    Res.

test(S, N, M) ->
    [test(S+X, N) || X <- lists:seq(0, M-1)],
    ok.


compare() ->
    compare(?MAX).
compare(N) ->
    frand:srand48(?SEED),
    Seeds = frand:vector(N),
    [run(Test, N) || Test <- Seeds],
    ok.


run(Seed, Number) ->
    {_, C} = c_frand(Seed, Number),

    frand:srand48(Seed),
    Vec0 = frand:vector(Number),
    E = [Value rem ?MAX || Value <- Vec0],

    io:format("S: ~w\tOk: ~p (Diff: ~w)~n", [Seed, C =:= E, C -- E]),
    ok.


c_frand(Seed0, Number0) ->
    Seed = integer_to_list(Seed0),
    Number = integer_to_list(Number0),
    Cmd = "priv/frand " ++ Seed ++ " " ++ Number,

    Port = open_port({spawn, Cmd}, [in, exit_status, line]),
    Str = do_port(Port),
    string2term(Str).


string2term(Str) ->
    {ok, Tokens, _} = erl_scan:string(Str),
    {ok, Term} = erl_parse:parse_term(Tokens),
    Term.


do_port(Port) ->
    do_port(Port, undefined, []).

do_port(Port, Res, Acc) ->
    receive
	{Port, {data, {noeol, Line}}} ->
	    do_port(Port, Res, [Line | Acc]);

	{Port, {data, {eol, Line}}} ->
	    Res2 = lists:flatten(lists:reverse([Line | Acc])),
	    do_port(Port, Res2, []);

	{Port, {exit_status, 0}} ->
	    Res
    end.
