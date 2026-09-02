// ====================================================================== 
// \title  Main.cpp
// \brief main function for Linux/Raspberry Pi Zero W 2 deployment
//
// ====================================================================== 

#include <Fw/Types/MallocAllocator.hpp>
#include <Fw/Types/TaskCommon.hpp>
#include <Os/Task.hpp>
#include <Fw/Types/Assert.hpp>
#include "ReferenceDeploymentTopology.hpp"

// ----------------------------------------------------------------------
// Memory allocation
// ----------------------------------------------------------------------

static Fw::MallocAllocator allocator;

// ----------------------------------------------------------------------
// Main entry point
// ----------------------------------------------------------------------

int main(int argc, char* argv[]) {
    // Initialize the topology
    ReferenceDeployment::Topology::setup(allocator);

    // Run the topology
    ReferenceDeployment::Topology::run();

    return 0;
}
