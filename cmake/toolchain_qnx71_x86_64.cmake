# QNX cross-compiler setup for SDP 7.1.0)
set(CMAKE_SYSTEM_VERSION 7.1.0)
set(arch gcc_ntox86_64)
include( ${CMAKE_CURRENT_LIST_DIR}/common_qnx.cmake )
# required on SDP 7.1 only
set(CMAKE_EXE_LINKER_FLAGS "-lregex" CACHE INTERNAL "")

