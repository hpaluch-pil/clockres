#
# CMakeLists.txt - cmake build file for clockres
#

### BUILD SECTION ###
# under scratchbox we have cmake-3.0.2 
# Recent versions does not build under old gcc4
cmake_minimum_required(VERSION 3.0)

project(clockres VERSION 0.2.0 LANGUAGES C)

# simplified boilerplate from CMake presentation
set(default_build_type "Release")
if(NOT CMAKE_BUILD_TYPE)
  message(STATUS
  "Setting build type to '${default_build_type}' as none was specified.")
  set(CMAKE_BUILD_TYPE "${default_build_type}" CACHE
      STRING "Choose the type of build." FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS
    "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()


add_executable(clockres clockres.c)
set(CLOCKRES_LIBS m)
# add -lrt if exist (required on most Linux/ARM platforms)
# Must filter with Linux, becasue on QNX6 this library is mysteriously
# detected as present (maybe crossbuild error?)
if(CMAKE_SYSTEM_NAME STREQUAL "Linux")
	find_library(RT_LIB rt)
	if (RT_LIB)
		list(APPEND CLOCKRES_LIBS rt)
	endif()
endif()

target_link_libraries(clockres PUBLIC ${CLOCKRES_LIBS})

### INSTALL SECTION ###
install(TARGETS clockres DESTINATION bin)

### PACK SECTION ###
if(DEFINED ENV{SBOX_UNAME_MACHINE})
	# under scratchbox CMAKE_SYSTEM_VERSION is HOST kernel version
	# so replace it with "sbox" literal...
	set(CPACK_PACKAGE_FILE_NAME
		"${PROJECT_NAME}-${PROJECT_VERSION}-${CMAKE_SYSTEM_NAME}-sbox-${CMAKE_SYSTEM_PROCESSOR}-${CMAKE_BUILD_TYPE}")
else()
	set(CPACK_PACKAGE_FILE_NAME
		"${PROJECT_NAME}-${PROJECT_VERSION}-${CMAKE_SYSTEM_NAME}${CMAKE_SYSTEM_VERSION}-${CMAKE_SYSTEM_PROCESSOR}-${CMAKE_BUILD_TYPE}")
endif()
set(CPACK_GENERATOR "TGZ")
include(CPack)

