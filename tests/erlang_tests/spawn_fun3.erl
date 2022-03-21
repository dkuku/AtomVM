%
% This file is part of AtomVM.
%
% Copyright 2019 Riccardo Binetti <rbino@gmx.com>
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

-module(spawn_fun3).

-export([start/0]).

start() ->
    L = [1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    Fun = fun() ->
        receive
            {Pid, sum} ->
                Pid ! sum(L)
        end
    end,
    Pid = spawn(Fun),
    Pid ! {self(), sum},
    receive
        N -> N
    end.

sum([]) ->
    0;
sum([H | T]) ->
    H + sum(T).
