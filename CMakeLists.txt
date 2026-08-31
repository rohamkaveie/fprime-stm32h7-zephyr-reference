####
# Multi-Platform F Prime Project Configuration
# Supports:
#   - STM32H723ZG board running ZephyrRTOS
#   - Raspberry Pi Zero W 2 running Linux
####

cmake_minimum_required(VERSION 3.24.2)

# Detect target platform
if(NOT DEFINED FPRIME_TARGET_PLATFORM)
    # Default to Zephyr for backward compatibility
    set(FPRIME_TARGET_PLATFORM "Zephyr" CACHE STRING "Target platform: Zephyr or Linux")
endif()

message(STATUS "Building for platform: ${FPRIME_TARGET_PLATFORM}")

# Platform-specific configuration
if(FPRIME_TARGET_PLATFORM STREQUAL "Zephyr")
    # Zephyr/STM32H723ZG Configuration
    list(APPEND BOARD_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/lib/fprime-stm32h7-zephyr")
    find_package(Zephyr HINTS "${CMAKE_CURRENT_LIST_DIR}/lib/zephyr-workspace")
    project(fprime-stm32h723z-zephyr C CXX)
    
    # Put in an option to force the device back into programable state for automated testing
    option(FPRIME_CI_FAILSAFE_ENABLED "Cycle count before a forced reset to programable state" OFF)
    if (FPRIME_CI_FAILSAFE_ENABLED)
        set(FPRIME_CI_FAILSAFE_CYCLE_COUNT 6000 CACHE STRING "Cycles before a forced reset")
        add_compile_definitions(FPRIME_CI_FAILSAFE_CYCLE_COUNT=${FPRIME_CI_FAILSAFE_CYCLE_COUNT})
    endif()
    
elseif(FPRIME_TARGET_PLATFORM STREQUAL "Linux")
    # Linux/Raspberry Pi Zero W 2 Configuration
    project(fprime-rpi-zero-w2-linux C CXX)
    
    # Linux-specific compile definitions
    add_compile_definitions(FPRIME_LINUX_TARGET=1)
    add_compile_definitions(RASPBERRY_PI_ZERO_W2=1)
else()
    message(FATAL_ERROR "Unsupported platform: ${FPRIME_TARGET_PLATFORM}. Use 'Zephyr' or 'Linux'")
endif()

###
# F' Core Setup
# This includes all of the F prime core components, and imports the make-system.
###
include("${CMAKE_CURRENT_LIST_DIR}/lib/fprime/cmake/FPrime.cmake")
# NOTE: register custom targets between these two lines
fprime_setup_included_code()


# This includes project-wide objects
include("${CMAKE_CURRENT_LIST_DIR}/project.cmake")

# Platform-specific target properties
if(FPRIME_TARGET_PLATFORM STREQUAL "Zephyr")
    set_target_properties(Svc_FatalHandler PROPERTIES EXCLUDE_FROM_ALL TRUE)
endif()