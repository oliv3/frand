-module(frand).
-on_load(init/0).

-export([srand48/1]).
-export([lrand48/0]).
-export([vector/1]).

-export([test/2, test/3]).

-define(MAX, 100).

%% =============================================================================
init() ->
    ok = erlang:load_nif("./priv/frand", 0).

srand48(_S) ->
    exit(nif_library_not_loaded).

lrand48() ->
    exit(nif_library_not_loaded).


%% =============================================================================
vector(N) ->
    [lrand48() || _ <- lists:seq(1, N)].

test(S, N) ->
    srand48(S),
    V = [X rem ?MAX || X <- vector(N)],
    Res = {S, V},
    io:format("~w.~n", [Res]),
    Res.

test(S, N, M) ->
    [test(S+X, N) || X <- lists:seq(0, M-1)],
    ok.
