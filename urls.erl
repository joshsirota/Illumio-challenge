#!/usr/bin/env escript

main(Args) ->
    RawInput = hd(Args),
    Input = hex2s(RawInput),
    Lines = string:lexemes(Input, [[$\r,$\n]]),

    {Method, Path, Version} = list_to_tuple(string:lexemes(hd(Lines), " ")),
    Headers = getHeaders(lists:nthtail(1, Lines)),

    {_, Host} = maps:find("Host", Headers),
    {NewHost, NewPath} = rewriteRequest(Host, Path), 

    % reconstruct the output
    NewHeaders = Headers#{"Host" => NewHost},

    io:format("~s ~s ~s~n", [Method, NewPath, Version]),
    maps:foreach(fun(K, V) -> io:format("~s: ~s~n", [K, V]) end, NewHeaders),
    io:fwrite("~n").

getHeaders(Lines) ->
    maps:from_list(lists:map(fun(X) -> list_to_tuple(string:lexemes(X, ": ")) end, Lines)).

rewriteRequest(Host, Path) ->
    case {Host, Path} of
        {"www.illumio.com", _} -> {Host, Path};
        {_, _} ->
            io:format("Changing ~p, ~p to Illumio~n~n", [Host, Path]),
            {"www.illumio.com", "/"}
    end.

%
% Utility to convert original hex string to usable input. Cribbed from StackOverflow.
% 
hex2s(HStr) -> hex2s(HStr,[]).

hex2s([X1,X2|Rest], Acc) ->  hex2s(Rest, [ list_to_integer([X1,X2], 16) |Acc ]);
hex2s([], Acc)           -> lists:reverse(Acc).
