// ======================================================================
// \title  Main.cpp
// \brief main function for Linux/Raspberry Pi Zero W 2 deployment
//
// ======================================================================

#include <Fw/Types/MallocAllocator.hpp>
#include <Fw/Types/TaskCommon.hpp>
#include <Os/Task.hpp>
#include <Fw/Types/Assert.hpp>
#include <Fw/Logger/Logger.hpp>
#include "ReferenceDeploymentTopology.hpp"

#include <cstdlib>
#include <getopt.h>

// ----------------------------------------------------------------------
// Command line argument processing
// ----------------------------------------------------------------------

void printUsage(const char* app) {
    (void)printf("Usage: ./%s [options]\n", app);
    (void)printf("  -u <device>   UART device path (e.g., /dev/ttyUSB0)\n");
    (void)printf("  -b <baud>     UART baud rate (default: 115200)\n");
    (void)printf("  -h <host>     Hostname/IP address for TCP connection\n");
    (void)printf("  -p <port>     Port number for TCP connection\n");
    (void)printf("  --help        Show this help message\n");
}

// ----------------------------------------------------------------------
// Main entry point
// ----------------------------------------------------------------------

int main(int argc, char* argv[]) {
    I32 option = 0;
    const char* uartDevice = nullptr;
    const char* hostname = nullptr;
    U16 port = 0;
    U32 baudRate = 115200;

    // Initialize OSAL
    Os::init();

    // Parse command line arguments
    static struct option longOptions[] = {
        {"uart-device", required_argument, nullptr, 'u'},
        {"baud", required_argument, nullptr, 'b'},
        {"host", required_argument, nullptr, 'h'},
        {"port", required_argument, nullptr, 'p'},
        {"help", no_argument, nullptr, '?'},
        {nullptr, 0, nullptr, 0}
    };

    while ((option = getopt_long(argc, argv, "u:b:h:p:", longOptions, nullptr)) != -1) {
        switch (option) {
            case 'u':
                uartDevice = optarg;
                break;
            case 'b':
                baudRate = static_cast<U32>(atoi(optarg));
                break;
            case 'h':
                hostname = optarg;
                break;
            case 'p':
                port = static_cast<U16>(atoi(optarg));
                break;
            case '?':
            default:
                printUsage(argv[0]);
                return (option == '?') ? 0 : 1;
        }
    }

    // Setup topology state
    ReferenceDeployment::TopologyState state;
    state.uartDevice = uartDevice;
    state.hostname = hostname;
    state.port = port;
    state.baudRate = baudRate;

    Fw::Logger::log("[Linux] F Prime Linux Deployment starting...\n");

    // Setup, run, and teardown topology
    ReferenceDeployment::setupTopology(state);
    
    Fw::Logger::log("[Linux] Entering main loop. Press Ctrl-C to exit.\n");
    
    // Main program loop - keep running until interrupted
    // The rate groups are driven by the clockSource started in setupTopology
    while (true) {
        Os::Task::delay(Fw::TimeInterval(1, 0));  // 1 second delay
    }

    // This code is unreachable but included for completeness
    ReferenceDeployment::teardownTopology(state);
    Fw::Logger::log("[Linux] Exiting...\n");
    
    return 0;
}
