// // ======================================================================
// // \title  Main.cpp
// // \brief main program for the F' application. Intended for CLI-based systems (Linux, macOS)
// //
// // ======================================================================
// // Used to access topology functions
// #include <ReferenceDeployment/Top/ReferenceDeploymentTopology.hpp>
// // OSAL initialization
// #include <Os/Os.hpp>
// // Used for signal handling shutdown
// #include <signal.h>
// // Used for command line argument processing
// #include <getopt.h>
// // Used for printf functions
// #include <cstdlib>

// const struct device *serial = DEVICE_DT_GET(DT_NODELABEL(cdc_acm_uart0));
// /**
//  * \brief print command line help message
//  *
//  * This will print a command line help message including the available command line arguments.
//  *
//  * @param app: name of application
//  */
// void print_usage(const char* app) {
//     (void)printf("Usage: ./%s [options]\n-a\thostname/IP address\n-p\tport_number\n", app);
// }

// /**
//  * \brief shutdown topology cycling on signal
//  *
//  * The reference topology allows for a simulated cycling of the rate groups. This simulated cycling needs to be stopped
//  * in order for the program to shutdown. This is done via handling signals such that it is performed via Ctrl-C
//  *
//  * @param signum
//  */
// static void signalHandler(int signum) {
//     ReferenceDeployment::stopSimulatedCycle();
// }

// /**
//  * \brief execute the program
//  *
//  * This F´ program is designed to run in standard environments (e.g. Linux/macOs running on a laptop). Thus it uses
//  * command line inputs to specify how to connect.
//  *
//  * @param argc: argument count supplied to program
//  * @param argv: argument values supplied to program
//  * @return: 0 on success, something else on failure
//  */
// int main(int argc, char* argv[]) {
//     I32 option = 0;
//     CHAR* hostname = nullptr;
//     U16 port_number = 0;
//     Os::init();

//     // Loop while reading the getopt supplied options
//     while ((option = getopt(argc, argv, "hp:a:")) != -1) {
//         switch (option) {
//             // Handle the -a argument for address/hostname
//             case 'a':
//                 hostname = optarg;
//                 break;
//             // Handle the -p port number argument
//             case 'p':
//                 port_number = static_cast<U16>(atoi(optarg));
//                 break;
//             // Cascade intended: help output
//             case 'h':
//             // Cascade intended: help output
//             case '?':
//             // Default case: output help and exit
//             default:
//                 print_usage(argv[0]);
//                 return (option == 'h') ? 0 : 1;
//         }
//     }
//     // Object for communicating state to the reference topology
//     ReferenceDeployment::TopologyState inputs;
//     inputs.baudRate = 115200;
//     inputs.uartDevice = serial;

//     // Setup program shutdown via Ctrl-C
//     signal(SIGINT, signalHandler);
//     signal(SIGTERM, signalHandler);
//     (void)printf("Hit Ctrl-C to quit\n");

//     // Setup, cycle, and teardown topology
//     ReferenceDeployment::setupTopology(inputs);
//     ReferenceDeployment::startSimulatedCycle(Fw::TimeInterval(0,10000));  // Program loop cycling rate groups at 1Hz
//     ReferenceDeployment::teardownTopology(inputs);
//     (void)printf("Exiting...\n");
//     return 0;
// }

// ======================================================================
// \title  Main.cpp
// \brief main program for the F' application. Intended for CLI-based systems (Linux, macOS)
//
// ======================================================================
// Used to access topology functions
#include <ReferenceDeployment/Top/ReferenceDeploymentTopology.hpp>
#include <ReferenceDeployment/Top/ReferenceDeploymentTopologyAc.hpp>
// OSAL initialization
#include <Os/Os.hpp>
#include <Fw/Logger/Logger.hpp>
#include <Fw/Types/Assert.hpp>

// const struct device *serial = DEVICE_DT_GET(DT_NODELABEL(usart1)); // For STM32H753I-EVAL
const struct device *serial = DEVICE_DT_GET(DT_NODELABEL(usart3)); // For NUCLEO-STM32H723ZG
/**
 * \brief execute the program
 *
 * This F´ program is designed to run in standard environments (e.g. Linux/macOs running on a laptop). Thus it uses
 * command line inputs to specify how to connect.
 *
 * @param argc: argument count supplied to program
 * @param argv: argument values supplied to program
 * @return: 0 on success, something else on failure
 */
int main(int argc, char* argv[]) {
    Os::init();
    // Object for communicating state to the reference topology
    ReferenceDeployment::TopologyState inputs;
    inputs.baudRate = 115200;
    inputs.uartDevice = serial;


    // Setup, cycle, and teardown topology
    Fw::Logger::log("[F Prime] Initializing topology\n");
    ReferenceDeployment::setupTopology(inputs);
    Fw::Logger::log("[F Prime] Entering main loop\n");

    // Main program loop
    while (true) {
        // This cycles the rate group by spinning on a timer
        ReferenceDeployment::clockSource.cycle();
        // This section will force teensy specific boards into the programing bootloader after the specified number of
        // cycles. This will ensure that CI programs will always return to a programable state.
        #if defined(FPRIME_CI_FAILSAFE_CYCLE_COUNT)
            static U64 failsafe_count = 0;
            if (FPRIME_CI_FAILSAFE_CYCLE_COUNT <= failsafe_count) {
                fatalHandler.reboot();        
            }
            failsafe_count = failsafe_count + 1;
        #endif
    }
    Fw::Logger::log("[F Prime] Resetting main loop\n");
    return 0;
}
