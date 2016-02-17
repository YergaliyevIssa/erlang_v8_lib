-module(generic_SUITE).

-include_lib("common_test/include/ct.hrl").

-export([all/0]).
-export([init_per_suite/1]).
-export([end_per_suite/1]).

-export([console_log/1]).
-export([instructions/1]).
-export([return/1]).
-export([context/1]).

%% Callbacks

all() ->
    [
        %% console_log,
        instructions,
        context
        %% return
    ].

init_per_suite(Config) ->
    application:ensure_all_started(erlang_v8_lib),
    Config.

end_per_suite(_Config) ->
    ok.

%% Tests

console_log(_Config) ->
    ok = erlang_v8_lib:run(<<"console.log('test');">>),
    ok.

instructions(_Config) ->
    {ok, 1} = erlang_v8_lib:run([
        {eval, <<"function lol() { process.return(1); }">>},
        {call, <<"lol">>, []}
    ]),
    ok.

context(_Config) ->
    {ok, <<"abc">>} = erlang_v8_lib:run([
        {context, #{ type => <<"abc">> }},
        {eval, <<"process.return(Context.get().type);">>}
    ]),
    ok.

return(_Config) ->
    {ok, 1} = erlang_v8_lib:run(<<"process.return(1);">>),
    ok.
