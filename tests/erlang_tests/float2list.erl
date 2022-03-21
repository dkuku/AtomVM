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

-module(float2list).

-export([start/0, add/2, compare_list/2, id/1, float_to_list_badarg/1]).

start() ->
    F1 = id((add(id(2.5), id(-1.0)))),
    L1 = id(erlang:float_to_list(id(F1))),
    F2 = id(id(F1) + id(id(0.5) * id(-1.0))),
    L2 = id(erlang:float_to_list(id(F2))),
    F3 = id(id(F2) * id(-1.0)),
    L3 = id(erlang:float_to_list(id(F3))),
    F4 = id(add(id(F2), id(F3))),
    L4 = id(erlang:float_to_list(id(F4))),
    compare_list(L1, id("1.50000000000000000000e+00")) +
        compare_list(L2, id("1.00000000000000000000e+00")) * 2 +
        compare_list(L3, id("-1.00000000000000000000e+00")) * 4 +
        compare_list(L4, id("0.00000000000000000000e+00")) * 8 +
        float_to_list_badarg({1}) * 16.

add(A, B) when is_float(A) and is_float(B) ->
    id(id(A) + id(B)).

compare_list([], []) ->
    1;
compare_list([H_A | T_A], [H_B | T_B]) when H_A == H_B ->
    compare_list(T_A, T_B);
compare_list(_A, _B) ->
    0.

id(I) when is_float(I) ->
    I;
id(I) when is_list(I) ->
    I.

float_to_list_badarg(F) ->
    try erlang:float_to_list(F) of
        Res -> Res
    catch
        error:badarg -> 1;
        _:_ -> -1
    end.
