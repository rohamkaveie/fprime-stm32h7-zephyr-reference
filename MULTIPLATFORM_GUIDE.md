# Multi-Platform F Prime Project Guide

This project supports building and deploying F Prime flight software on two different platforms:
- **STM32H723ZG** board running **ZephyrRTOS**
- **Raspberry Pi Zero W 2** running **Linux**

## Repository Structure

```
/workspace/
├── CMakeLists.txt              # Root CMake configuration (multi-platform)
├── CMakePresets.json           # Build presets for different platforms
├── Components/                 # Reusable F Prime components
│   ├── CMakeLists.txt
│   └── Led/                    # Example LED component
│       ├── CMakeLists.txt
│       ├── Led.fpp
│       └── Led.cpp
├── ReferenceDeployment/        # Main deployment
│   ├── CMakeLists.txt          # Platform-aware deployment registration
│   ├── Main.cpp                # Application entry point
│   └── Top/                    # Topology definitions
│       ├── CMakeLists.txt      # Platform-specific instances
│       ├── instances.fpp       # Common instances
│       ├── instances-zephyr.fpp # Zephyr-specific instances
│       ├── instances-native.fpp # Linux/native instances
│       ├── topology.fpp        # System topology
│       └── ReferenceDeploymentTopology.cpp
├── config/                     # Configuration files
│   ├── CMakeLists.txt          # Platform-aware config registration
│   ├── FpConfig.h              # Base F Prime configuration
│   ├── FpConfig2.h             # Linux-specific configuration
│   ├── CommandDispatcherImplCfg.hpp
│   └── TlmChanImplCfg.hpp
├── lib/                        # External libraries (submodules)
│   ├── fprime/                 # F Prime core
│   ├── fprime-zephyr/          # F Prime Zephyr integration
│   ├── fprime-stm32h7-zephyr/  # STM32H7 board support
│   └── zephyr-workspace/       # Zephyr RTOS workspace
├── docs/                       # Documentation
├── prj.conf                    # Zephyr project configuration
├── project.cmake               # Project-wide module registration
└── settings.ini                # F Prime settings
```

## Recommended Folder Structure for New Projects

For optimal organization when developing modules and components for both platforms:

```
project-root/
├── CMakeLists.txt              # Multi-platform root configuration
├── CMakePresets.json           # Platform-specific build presets
├── Components/                 # All reusable components
│   ├── CMakeLists.txt
│   ├── Common/                 # Platform-agnostic components
│   │   ├── ComponentA/
│   │   └── ComponentB/
│   ├── Zephyr/                 # Zephyr-specific components
│   │   └── ZephyrDriver/
│   └── Linux/                  # Linux-specific components
│       └── LinuxDriver/
├── Deployments/                # Platform-specific deployments
│   ├── ZephyrDeployment/
│   │   ├── CMakeLists.txt
│   │   ├── Main.cpp
│   │   └── Top/
│   └── LinuxDeployment/
│       ├── CMakeLists.txt
│       ├── Main.cpp
│       └── Top/
├── Config/                     # Configuration files
│   ├── CMakeLists.txt
│   ├── Common/                 # Shared configuration
│   │   └── FpConfig.h
│   ├── Zephyr/                 # Zephyr-specific config
│   │   └── FpConfigZephyr.h
│   └── Linux/                  # Linux-specific config
│       └── FpConfigLinux.h
├── Drivers/                    # Hardware abstraction layer
│   ├── CMakeLists.txt
│   ├── Interface/              # Hardware interfaces
│   ├── STM32/                  # STM32 implementations
│   └── RPi/                    # Raspberry Pi implementations
├── lib/                        # External dependencies
│   ├── fprime/
│   ├── fprime-zephyr/
│   └── zephyr-workspace/
├── docs/                       # Documentation
├── scripts/                    # Build and deployment scripts
│   ├── build-zephyr.sh
│   ├── build-linux.sh
│   ├── flash-zephyr.sh
│   └── deploy-linux.sh
├── prj.conf                    # Zephyr configuration
├── project.cmake               # Module registration
└── settings.ini                # F Prime settings
```

## Building for Different Platforms

### Prerequisites

1. **For Zephyr/STM32H723ZG:**
   - Install Zephyr SDK and dependencies
   - Set up Zephyr workspace
   - Connect STM32H723ZG board via USB

2. **For Linux/Raspberry Pi Zero W 2:**
   - Standard Linux development tools (gcc, make, cmake)
   - Cross-compilation toolchain (if building on different architecture)
   - SSH access to Raspberry Pi (for deployment)

### Build Commands

#### Using CMake Presets (Recommended)

**For STM32H723ZG (Zephyr):**
```bash
# Release build
cmake --preset=fprime-zephyr
cmake --build --preset=fprime-zephyr

# Debug build
cmake --preset=fprime-zephyr-debug
cmake --build --preset=fprime-zephyr-debug
```

**For Raspberry Pi Zero W 2 (Linux):**
```bash
# Release build
cmake --preset=fprime-linux-rpi
cmake --build --preset=fprime-linux-rpi

# Debug build
cmake --preset=fprime-linux-rpi-debug
cmake --build --preset=fprime-linux-rpi-debug
```

**For Unit Tests (Native):**
```bash
cmake --preset=fprime-ut
cmake --build --preset=fprime-ut
```

#### Manual Configuration

**For Zephyr:**
```bash
cmake -B build-zephyr \
    -DFPRIME_TARGET_PLATFORM=Zephyr \
    -DBOARD=nucleo_h723zg \
    -DCMAKE_TOOLCHAIN_FILE=lib/fprime-zephyr/cmake/toolchain/zephyr.cmake \
    -G Ninja
cmake --build build-zephyr
```

**For Linux:**
```bash
cmake -B build-linux \
    -DFPRIME_TARGET_PLATFORM=Linux \
    -DCMAKE_BUILD_TYPE=Release
cmake --build build-linux
```

### Flashing/Deployment

#### STM32H723ZG (Zephyr)
```bash
# Flash to board
west flash -b nucleo_h723zg --build-dir build-fprime-automatic-zephyr

# Or using dfu-util
dfu-util -a 0 -s 0x08000000 -D build-fprime-automatic-zephyr/zephyr/zephyr.bin
```

#### Raspberry Pi Zero W 2 (Linux)
```bash
# Copy binary to Raspberry Pi
scp build-fprime-automatic-linux-rpi/bin/fprime-rpi-zero-w2-linux pi@raspberrypi.local:/home/pi/

# SSH and run
ssh pi@raspberrypi.local
./fprime-rpi-zero-w2-linux
```

## Platform-Specific Code

### Using Preprocessor Definitions

In your source code, use these definitions for platform-specific logic:

```cpp
#ifdef FPRIME_LINUX_TARGET
    // Linux-specific code
#elif defined(__ZEPHYR__)
    // Zephyr-specific code
#endif
```

### Component Organization

For maximum code reuse:

1. **Common Components**: Place in `Components/Common/` - these should be platform-agnostic
2. **Platform Drivers**: Place in `Drivers/<Platform>/` - hardware-specific implementations
3. **Configuration**: Use platform-specific config files in `Config/<Platform>/`

### Example: Platform-Aware Component

```cpp
// Components/Common/Led/Led.cpp
#include "LedComponentAc.hpp"

void LedComponent::ledOn() {
#ifdef FPRIME_LINUX_TARGET
    // GPIO control for Raspberry Pi
    writeSysfsGpio(1, true);
#elif defined(__ZEPHYR__)
    // GPIO control for STM32
    gpio_pin_set_dt(&led_spec, 1);
#endif
}
```

## CMake Integration Points

The multi-platform support is implemented through these key modifications:

1. **Root CMakeLists.txt**: Detects `FPRIME_TARGET_PLATFORM` and configures accordingly
2. **CMakePresets.json**: Provides pre-configured build options for each platform
3. **Deployment CMakeLists.txt**: Registers appropriate deployment type per platform
4. **Topology CMakeLists.txt**: Selects platform-specific instance files
5. **Config CMakeLists.txt**: Applies platform-specific configuration overrides

## Adding New Platforms

To add support for another platform:

1. Add platform detection in root `CMakeLists.txt`
2. Create new build preset in `CMakePresets.json`
3. Update deployment registration in `ReferenceDeployment/CMakeLists.txt`
4. Add platform-specific configuration if needed
5. Create platform-specific instance files if required

## Troubleshooting

### Common Issues

1. **Zephyr build fails**: Ensure Zephyr environment is properly sourced
2. **Linux build fails**: Check that all dependencies are installed
3. **Cross-compilation issues**: Verify toolchain configuration for Raspberry Pi

### Getting Help

- F Prime Documentation: https://fprime.jpl.nasa.gov
- Zephyr Documentation: https://docs.zephyrproject.org
- Raspberry Pi Documentation: https://www.raspberrypi.com/documentation
