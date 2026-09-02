# Deployments - Platform-specific F Prime deployments

# Include platform-specific deployments based on target platform
if(FPRIME_TARGET_PLATFORM STREQUAL "Zephyr")
    add_subdirectory(ZephyrDeployment)
elseif(FPRIME_TARGET_PLATFORM STREQUAL "Linux")
    add_subdirectory(LinuxDeployment)
endif()
