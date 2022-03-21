%
% This file is part of AtomVM.
%
% Copyright 2019 Davide Bettio <davide@uninstall.it>
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

-module(test_funs7).

-export([start/0, sumeach/3, g/1, id/1]).

start() ->
    C = g(four),
    sumeach(fun(_V) -> C end, [1, 2, 3, 4], 0) +
        sumeach(fun(V) -> V - C end, [1, 2, 3, 4], 0) * 100 +
        sumeach(fun(V) -> V end, [1, 2, 3, 4], 0) * 1000.

sumeach(F, [H | T], Acc) ->
    R = F(H),
    sumeach(F, T, R + Acc);
sumeach(_F, [], Acc) ->
    Acc.

g(zero) ->
    0;
g(four) ->
    4;
g(five) ->
    5.

id(I) ->
    I.
