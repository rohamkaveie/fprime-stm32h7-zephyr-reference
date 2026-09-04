# Include project-wide components here

# Platform-agnostic components
add_subdirectory(Common)

# Platform-specific components (conditionally included)
if(FPRIME_TARGET_PLATFORM STREQUAL "Zephyr")
    add_subdirectory(Zephyr)
elseif(FPRIME_TARGET_PLATFORM STREQUAL "Linux")
    add_subdirectory(Linux)
endif()

# add_fprime_subdirectory("${CMAKE_CURRENT_LIST_DIR}/MyComponent")
