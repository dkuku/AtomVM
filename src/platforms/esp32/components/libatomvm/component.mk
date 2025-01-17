#
# This file is part of AtomVM.
#
# Copyright 2017-2019 Davide Bettio <davide@uninstall.it>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0 OR LGPL-2.1-or-later
#

CODESUBDIR := $(COMPONENT_PATH)/../../../../libAtomVM

LIBRARY := -llibAtomVM

CFLAGS := -Og -ggdb -ffunction-sections -fdata-sections -fstrict-volatile-bitfields -mlongcalls -nostdlib -DWITH_POSIX -DMBEDTLS_CONFIG_FILE='"mbedtls/esp_config.h"' -DHAVE_CONFIG_H  -g -pipe -fvisibility=hidden -fPIC
CPPFLAGS := -Og -ggdb -ffunction-sections -fdata-sections -fstrict-volatile-bitfields -mlongcalls -nostdlib -DWITH_POSIX -DMBEDTLS_CONFIG_FILE='"mbedtls/esp_config.h"' -DHAVE_CONFIG_H  -g -pipe -fvisibility=hidden -fPIC

INCLUDE_FIXUP_DIR := $(IDF_PATH)/components/lwip/include/lwip/posix

COMPONENT_ADD_INCLUDEDIRS := ../../../../libAtomVM $(COMPONENT_PATH)/../../build/libatomvm

COMPONENT_ADD_LDFLAGS := $(LIBRARY)

CINCLUDES := $(COMPONENT_INCLUDES) $(COMPONENT_EXTRA_INCLUDES) $(COMPONENT_ADD_INCLUDEDIRS) $(INCLUDE_FIXUP_DIR)

CMAKE_TOOLCHAIN_FILE := cmake_toolchain_file.txt

$(CMAKE_TOOLCHAIN_FILE):
	${file >$(CMAKE_TOOLCHAIN_FILE),#Autogenerated from component.mk}
	${file >>$(CMAKE_TOOLCHAIN_FILE),SET(CMAKE_SYSTEM_NAME ESP_IDF)}
	${file >>$(CMAKE_TOOLCHAIN_FILE),SET(CMAKE_SYSTEM_VERSION 3.2)}
	${file >>$(CMAKE_TOOLCHAIN_FILE),SET(CMAKE_SYSTEM_PROCESSOR xtensa_esp32)}
	${file >>$(CMAKE_TOOLCHAIN_FILE),SET(CMAKE_C_COMPILER $(CC))}
	${file >>$(CMAKE_TOOLCHAIN_FILE),SET(CMAKE_FIND_ROOT_PATH_MODE_PROGRAM NEVER)}
	${file >>$(CMAKE_TOOLCHAIN_FILE),SET(CMAKE_FIND_ROOT_PATH_MODE_LIBRARY ONLY)}
	${file >>$(CMAKE_TOOLCHAIN_FILE),SET(CMAKE_FIND_ROOT_PATH_MODE_INCLUDE ONLY)}
	${file >>$(CMAKE_TOOLCHAIN_FILE),SET(CFLAGS $(CFLAGS))}
	${foreach incdir,$(CINCLUDES),${file >>$(CMAKE_TOOLCHAIN_FILE),include_directories($(incdir))}}


Makefile: $(CODESUBDIR)/CMakeLists.txt $(CMAKE_TOOLCHAIN_FILE) $(COMPONENT_PATH)/component.mk
	cmake -DCMAKE_TOOLCHAIN_FILE=$(CMAKE_TOOLCHAIN_FILE) $(CODESUBDIR)

build: Makefile
ifeq ($(V),)
	VERBOSE=0 COLOR=1 make
else
	VERBOSE=1 COLOR=1 make
endif

clean: Makefile
	make clean
	rm -rf CMakeCache.txt CMakeFiles *.cmake

COMPONENT_OWNCLEANTARGET := clean
COMPONENT_OWNBUILDTARGE := build
