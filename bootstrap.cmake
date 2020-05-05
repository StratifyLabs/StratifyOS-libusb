cmake_minimum_required (VERSION 3.6)

# cmake -P ./bootstrap.cmake

if( ${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Darwin" )
	set(SOS_TOOLCHAIN_CMAKE_PATH /Applications/StratifyLabs-SDK/Tools/gcc/arm-none-eabi/cmake)
	set(PREFIX /Applications/StratifyLabs-SDK/Tools/gcc)
elseif( ${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows" )
	set(SOS_TOOLCHAIN_CMAKE_PATH C:/StratifyLabs-SDK/Tools/gcc/arm-none-eabi/cmake)
	set(PREFIX C:/StratifyLabs-SDK/Tools/gcc)
elseif( ${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Linux" )
	set(SOS_TOOLCHAIN_CMAKE_PATH /StratifyLabs-SDK/Tools/gcc/arm-none-eabi/cmake)
	set(PREFIX /StratifyLabs-SDK/Tools/gcc)
endif()

include(${SOS_TOOLCHAIN_CMAKE_PATH}/sos-sdk.cmake)

file(REMOVE_RECURSE libusb)
file(REMOVE_RECURSE build_libusb)
sos_sdk_clone_or_pull(./libusb https://github.com/libusb/libusb.git ./)
sos_sdk_checkout(libusb "v1.0.23")
file(MAKE_DIRECTORY build_libusb)
execute_process(COMMAND ./bootstrap.sh WORKING_DIRECTORY libusb)
execute_process(COMMAND ../libusb/configure --prefix=${PREFIX} --disable-shared WORKING_DIRECTORY build_libusb)
execute_process(COMMAND make -j12 WORKING_DIRECTORY build_libusb)
execute_process(COMMAND make install WORKING_DIRECTORY build_libusb)

