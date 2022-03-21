%
% This file is part of AtomVM.
%
% Copyright 2018 Davide Bettio <davide@uninstall.it>
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%    http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%
% SPDX-License-Identifier: Apache-2.0 OR LGPL-2.1-or-later
%

-module(state_test).

-export([start/0, loop/1]).

start() ->
    Pid = spawn(state_test, loop, [initial_state()]),
    send_integer(Pid, 1),
    send_integer(Pid, 2),
    send_integer(Pid, 3),
    Pid ! {get, self()},
    Value =
        receive
            Any -> hd(Any)
        end,
    Pid ! terminate,
    Value.

initial_state() ->
    [].

send_integer(Pid, Index) ->
    Pid ! {put, Index}.

loop(State) ->
    case handle_request(State) of
        nil ->
            ok;
        Value ->
            loop(Value)
    end.

handle_request(State) ->
    receive
        {put, Item} ->
            [Item] ++ State;
        {get, Pid} ->
            Pid ! State,
            State;
        terminate ->
            nil;
        _Any ->
            State
    end.
