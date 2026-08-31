####
# Multi-Platform Configuration Support
# Provides platform-specific configuration for:
#   - STM32H723ZG running ZephyrRTOS
#   - Raspberry Pi Zero W 2 running Linux
####

# Platform-specific configuration overrides
set(PLATFORM_CONFIG_OVERRIDES "")

if(FPRIME_TARGET_PLATFORM STREQUAL "Zephyr")
    list(APPEND PLATFORM_CONFIG_OVERRIDES
        "${CMAKE_CURRENT_LIST_DIR}/FpConfig.h"
    )
elseif(FPRIME_TARGET_PLATFORM STREQUAL "Linux")
    list(APPEND PLATFORM_CONFIG_OVERRIDES
        "${CMAKE_CURRENT_LIST_DIR}/FpConfig.h"
        "${CMAKE_CURRENT_LIST_DIR}/FpConfig2.h"
    )
endif()

register_fprime_config(
    CONFIGURATION_OVERRIDES
        "${CMAKE_CURRENT_LIST_DIR}/CommandDispatcherImplCfg.hpp"
        "${CMAKE_CURRENT_LIST_DIR}/TlmChanImplCfg.hpp"
        ${PLATFORM_CONFIG_OVERRIDES}
    INTERFACE
)
