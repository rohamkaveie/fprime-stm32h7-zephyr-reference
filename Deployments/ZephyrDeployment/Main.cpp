// ======================================================================
// \title  Main.cpp
// \brief main program for the F' application. Intended for Zephyr RTOS
//
// ======================================================================
// Used to access topology functions
#include <ReferenceDeployment/Top/ReferenceDeploymentTopology.hpp>
#include <ReferenceDeployment/Top/ReferenceDeploymentTopologyAc.hpp>
// OSAL initialization
#include <Os/Os.hpp>
#include <Fw/Logger/Logger.hpp>
#include <Fw/Types/Assert.hpp>

// Zephyr UART device
#include <zephyr/drivers/uart.h>

// For STM32H753I-EVAL use usart1, for NUCLEO-STM32H723ZG use usart3
const struct device* serial = DEVICE_DT_GET(DT_NODELABEL(usart3));

/**
 * \brief execute the program
 *
 * This F´ program is designed to run on Zephyr RTOS. It uses the Zephyr
 * device tree to obtain the UART device and runs the F Prime topology
 * in an infinite loop.
 *
 * @return: 0 on success (never returns in normal operation)
 */
int main(void) {
    Os::init();
    
    // Object for communicating state to the reference topology
    ReferenceDeployment::TopologyState inputs;
    inputs.uartDevice = serial;
    inputs.baudRate = 115200;

    // Setup topology
    Fw::Logger::log("[Zephyr] Initializing topology\n");
    ReferenceDeployment::setupTopology(inputs);
    Fw::Logger::log("[Zephyr] Entering main loop\n");

    // Main program loop - Zephyr RTOS handles scheduling
    // The rate groups are driven by the clockSource started in setupTopology
    while (true) {
        // This cycles the rate group by spinning on a timer
        ReferenceDeployment::clockSource.cycle();
        
        // Failsafe mechanism for CI testing
#if defined(FPRIME_CI_FAILSAFE_CYCLE_COUNT)
        static U64 failsafe_count = 0;
        if (FPRIME_CI_FAILSAFE_CYCLE_COUNT <= failsafe_count) {
            fatalHandler.reboot();        
        }
        failsafe_count = failsafe_count + 1;
#endif
    }
    
    // Unreachable in normal operation
    Fw::Logger::log("[Zephyr] Resetting main loop\n");
    return 0;
}
