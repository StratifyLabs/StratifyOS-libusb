cmake_minimum_required (VERSION 3.6)

# cmake -P ./bootstrap.cmake

# Grab the SDK location
if(NOT DEFINED SOS_SDK_PATH)
	if(DEFINED ENV{SOS_SDK_PATH})
		set(SOS_SDK_PATH $ENV{SOS_SDK_PATH})
	elseif( ${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Darwin" )
		message(WARNING "default SDK locations are deprecated")
		set(SOS_SDK_PATH /Applications/StratifyLabs-SDK)
	elseif( ${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Windows" )
		message(WARNING "default SDK locations are deprecated")
		set(SOS_SDK_PATH C:/StratifyLabs-SDK)
	elseif( ${CMAKE_HOST_SYSTEM_NAME} STREQUAL "Linux" )
		message(WARNING "default SDK locations are deprecated")
		set(SOS_SDK_PATH /StratifyLabs-SDK)
	endif()
endif()
if(NOT DEFINED SOS_SDK_PATH)
	message(FATAL_ERROR "Please set environment variable SOS_SDK_PATH to location of the StratifyLabs-SDK directory")
endif()
set(SOS_TOOLCHAIN_CMAKE_PATH ${SOS_SDK_PATH}/Tools/gcc/arm-none-eabi/cmake)

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

