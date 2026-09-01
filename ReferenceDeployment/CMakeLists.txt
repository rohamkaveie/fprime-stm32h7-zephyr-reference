#####
# 'ReferenceDeployment' Deployment:
#
# Multi-Platform Support:
#   - STM32H723ZG running ZephyrRTOS
#   - Raspberry Pi Zero W 2 running Linux
#
# This registers the 'ReferenceDeployment' deployment to the build system. 
# Custom components that have not been added at the project-level should be added to 
# the list below.
#
#####

###
# Topology and Components
###
add_fprime_subdirectory("${CMAKE_CURRENT_LIST_DIR}/Top/")

# Add custom components to this specific deployment here
# add_fprime_subdirectory("${CMAKE_CURRENT_LIST_DIR}/MyComponent/")

# Platform-specific deployment registration
if(FPRIME_TARGET_PLATFORM STREQUAL "Zephyr")
    # Zephyr/STM32H723ZG deployment
    register_fprime_zephyr_deployment(
        ${FPRIME_CURRENT_MODULE}
        SOURCES
            "${CMAKE_CURRENT_LIST_DIR}/Main.cpp"
        DEPENDS
            ${FPRIME_CURRENT_MODULE}_Top
    )
else()
    # Linux/Raspberry Pi Zero W 2 deployment (default)
    # Also used as fallback for any non-Zephyr platform
    register_fprime_deployment(
        ${FPRIME_CURRENT_MODULE}
        SOURCES
            "${CMAKE_CURRENT_LIST_DIR}/Main.cpp"
        DEPENDS
            ${FPRIME_CURRENT_MODULE}_Top
    )
endif()