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

-module(test_insert_element).

-export([start/0, f/1, t/3]).

start() ->
    f(t({world}, 1, hello)) + f(t({hello, world}, 2, test)) * 20 +
        f(t({hello, test}, 3, world)) * 40.

t(T, I, V) ->
    erlang:insert_element(I, T, V).

f({hello, world}) ->
    1;
f({hello, test, world}) ->
    2;
f({test, world}) ->
    10;
f({hello, test}) ->
    100;
f(T) when is_tuple(T) ->
    3;
f(_T) ->
    4.
