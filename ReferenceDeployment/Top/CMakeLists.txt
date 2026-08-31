####
# F prime CMakeLists.txt:
#
# Multi-Platform Support:
#   - STM32H723ZG running ZephyrRTOS
#   - Raspberry Pi Zero W 2 running Linux
#
# SOURCE_FILES: combined list of source and autocoding files
# MOD_DEPS: (optional) module dependencies
####

# Determine platform-specific instances file
set(SPECIFIC_INSTANCES "${CMAKE_CURRENT_LIST_DIR}/instances-native.fpp")

if(FPRIME_TARGET_PLATFORM STREQUAL "Zephyr")
    set(SPECIFIC_INSTANCES "${CMAKE_CURRENT_LIST_DIR}/instances-zephyr.fpp")
elseif(FPRIME_TARGET_PLATFORM STREQUAL "Linux")
    # Use native instances for Linux target
    set(SPECIFIC_INSTANCES "${CMAKE_CURRENT_LIST_DIR}/instances-native.fpp")
elseif("${FPRIME_PLATFORM}" STREQUAL "Zephyr")
    # Fallback to legacy FPRIME_PLATFORM detection
    set(SPECIFIC_INSTANCES "${CMAKE_CURRENT_LIST_DIR}/instances-zephyr.fpp")
endif()

register_fprime_module(
    AUTOCODER_INPUTS
        "${CMAKE_CURRENT_LIST_DIR}/instances.fpp"
        "${SPECIFIC_INSTANCES}"
        "${CMAKE_CURRENT_LIST_DIR}/topology.fpp"
    SOURCES
        "${CMAKE_CURRENT_LIST_DIR}/ReferenceDeploymentTopology.cpp"
)

