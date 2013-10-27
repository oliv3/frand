-module(frand).
-on_load(init/0).

-export([srand48/1]).
-export([lrand48/0]).
-export([vector/1]).


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
