#!/usr/bin/env escript

main(Args) ->
    RawInput = hd(Args),
    NewRequest = rewriteHexHttpRequest(RawInput),

    io:format("Final Result:~n~s~n", [NewRequest]).

%
% Main function of challenge.
% 
% Accepts a hex string containing an HTTP request. Updates it, and returns the resulting hex string.
%
rewriteHexHttpRequest(RawInput) ->
    Input = hex2s(RawInput),

    % Write the original request in ascii text
    io:format("ORIGINAL REQUEST:~n~s~n", [Input]),

    % Use the Erlang HTTP parser to parse the original request
    MethodLine = erlang:decode_packet(http, list_to_binary(Input), []),

    % Extract the info we need from the request. I really only need the Path and Headers now, but I'll
    % need the rest to rewrite the full request
    {ok, {http_request, Method, {abs_path, Path}, {VersionMajor, VersionMinor}}, Headers} = MethodLine,
    HeaderMap = parseHeaders(Headers),
    {ok, Host} = maps:find("Host", HeaderMap),

    % We have the host extracted from the headers, and the path extracted from the method line
    io:format("Host: ~s~nPath: ~s~n", [Host, Path]),

    % Compute a potentially-changed new host and path
    {NewHost, NewPath} = rewriteRequest(Host, Path), 

    % Rewrite the host into the header map
    NewHeaderMap = HeaderMap#{"Host" => NewHost},

    % Reconstruct the output
    % [ Note to self: is there a way to compute an HTTP request and then just output that? ]
    Result = lists:flatten(io_lib:format("~s ~s HTTP/~B.~B~n", [atom_to_list(Method), NewPath, VersionMajor, VersionMinor]) ++
        lists:flatten(maps:values(maps:map(fun(K, V) -> io_lib:format("~s: ~s~n", [K, V]) end, NewHeaderMap))) ++
        io_lib:format("~n", [])),

    % Write the new request in ascii text
    io:format("UPDATED REQUEST:~n~s~n", [Result]),

    % Return the hex result
    toHex(Result).

parseHeaders(Headers) ->
    parseHeaders(Headers, #{}).

parseHeaders(Headers, HeaderMap) ->
    HeaderResult = erlang:decode_packet(httph, Headers, []),
    case HeaderResult of
        {ok, http_eoh, _} -> HeaderMap;
        {ok, {http_header, _, _, Header, Value}, Rest} -> parseHeaders(Rest, HeaderMap#{Header => Value})
    end.

rewriteRequest(Host, Path) ->
    case {Host, Path} of
        {"www.illumio.com", _} -> {Host, Path};
        {_, _} ->
            io:format("Changing ~p, ~p to Illumio~n~n", [Host, Path]),
            {"www.illumio.com", "/"}
    end.

%
% Utilities to convert hex string to chars and vice-versa. Cribbed from StackOverflow.
% 
hex2s(HStr) -> hex2s(HStr, []).

hex2s([X1,X2|Rest], Acc) ->  hex2s(Rest, [ list_to_integer([X1,X2], 16) |Acc ]);
hex2s([], Acc)           -> lists:reverse(Acc).

hexChar(Num) when Num < 10 andalso Num >= 0->
    $0 + Num;
hexChar(Num) when Num < 16 ->
    $a + Num - 10.

toHex([Byte | Rest]) ->
    [hexChar(Byte div 16), hexChar(Byte rem 16)] ++ toHex(Rest);
toHex([]) -> [].