####
# Multi-Platform Configuration Support
# Provides platform-specific configuration for:
#   - STM32H723ZG running ZephyrRTOS
#   - Raspberry Pi Zero W 2 running Linux
####

# Include common configuration
add_subdirectory(Common)

# Platform-specific configuration overrides
if(FPRIME_TARGET_PLATFORM STREQUAL "Zephyr")
    add_subdirectory(Zephyr)
elseif(FPRIME_TARGET_PLATFORM STREQUAL "Linux")
    add_subdirectory(Linux)
endif()
