# common_qnx.cmake - shared include for QNX SDP 7.1, 7.0 and 6.5
# NOTE: Parent must define "arch" - see toolchain_qnx70_x86_64.cmake
#       for example
# mostly copied from:
# - https://cmake.org/cmake/help/latest/manual/cmake-toolchains.7.html#cross-compiling-for-qnx
# with these changes:
# - use q++ instead of QCC (missing on SDP 7.1) 
# - removed disabled sysroot (not supported by q++)
set(CMAKE_SYSTEM_NAME QNX)
set(CMAKE_C_COMPILER qcc)
set(arch "gcc_nto${CMAKE_SYSTEM_PROCESSOR}")
set(CMAKE_C_COMPILER_TARGET ${arch})
# SDP 7.1 has not QCC anymore, but all have q++ (like g++)
set(CMAKE_CXX_COMPILER q++)
set(CMAKE_CXX_COMPILER_TARGET ${arch})
set(QNX 1)
