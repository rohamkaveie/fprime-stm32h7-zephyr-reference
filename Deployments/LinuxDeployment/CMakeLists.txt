#####
# 'LinuxDeployment' Deployment:
#
# Platform: Raspberry Pi Zero W 2 running Linux
#
# This registers the 'LinuxDeployment' deployment to the build system. 
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

# Linux/Raspberry Pi Zero W 2 deployment
register_fprime_deployment(
    LinuxDeployment
    SOURCES
        "${CMAKE_CURRENT_LIST_DIR}/Main.cpp"
    DEPENDS
        LinuxDeployment_Top
)
