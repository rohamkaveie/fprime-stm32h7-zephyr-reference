# Multi-Platform F Prime Project - Quick Reference

## Overview

This project supports building and deploying F Prime flight software on:
- **STM32H723ZG** board running **ZephyrRTOS**
- **Raspberry Pi Zero W 2** running **Linux**

## Modified CMakeLists.txt Files

### 1. Root CMakeLists.txt (`/workspace/CMakeLists.txt`)
**Purpose**: Platform detection and configuration
- Introduces `FPRIME_TARGET_PLATFORM` variable (Zephyr or Linux)
- Configures platform-specific project settings
- Sets up compile definitions for platform-aware code

### 2. ReferenceDeployment CMakeLists.txt (`/workspace/ReferenceDeployment/CMakeLists.txt`)
**Purpose**: Platform-aware deployment registration
- Uses `register_fprime_zephyr_deployment()` for Zephyr target
- Uses `register_fprime_deployment()` for Linux target
- Includes fallback to legacy `FPRIME_PLATFORM` detection

### 3. Topology CMakeLists.txt (`/workspace/ReferenceDeployment/Top/CMakeLists.txt`)
**Purpose**: Platform-specific instance file selection
- Selects `instances-zephyr.fpp` for Zephyr builds
- Selects `instances-native.fpp` for Linux builds
- Maintains backward compatibility with `FPRIME_PLATFORM`

### 4. Config CMakeLists.txt (`/workspace/config/CMakeLists.txt`)
**Purpose**: Platform-specific configuration overrides
- Applies different config files based on target platform
- Supports platform-specific FpConfig headers

### 5. Components CMakeLists.txt (`/workspace/Components/CMakeLists.txt`)
**Purpose**: Component registration (unchanged, platform-agnostic)

### 6. Led Component CMakeLists.txt (`/workspace/Components/Led/CMakeLists.txt`)
**Purpose**: Example component registration (unchanged, platform-agnostic)

## Build Presets (CMakePresets.json)

| Preset Name | Platform | Build Type | Description |
|-------------|----------|------------|-------------|
| `fprime-zephyr` | STM32H723ZG | Release | Production build for Zephyr |
| `fprime-zephyr-debug` | STM32H723ZG | Debug | Debug build for Zephyr |
| `fprime-linux-rpi` | Raspberry Pi Zero W 2 | Release | Production build for Linux |
| `fprime-linux-rpi-debug` | Raspberry Pi Zero W 2 | Debug | Debug build for Linux |
| `fprime-ut` | Native (Linux) | Debug | Unit test build |

## Build Commands

### For STM32H723ZG (Zephyr)
```bash
# Using presets
cmake --preset=fprime-zephyr
cmake --build --preset=fprime-zephyr

# Or using script
./scripts/build-zephyr.sh [debug|release]
```

### For Raspberry Pi Zero W 2 (Linux)
```bash
# Using presets
cmake --preset=fprime-linux-rpi
cmake --build --preset=fprime-linux-rpi

# Or using script
./scripts/build-linux.sh [debug|release]
```

### For Unit Tests
```bash
cmake --preset=fprime-ut
cmake --build --preset=fprime-ut
```

## Deployment Commands

### Flash to STM32H723ZG
```bash
./scripts/flash-zephyr.sh
# Or manually:
west flash -b nucleo_h723zg --build-dir build-fprime-automatic-zephyr
```

### Deploy to Raspberry Pi
```bash
./scripts/deploy-linux.sh [hostname] [username]
# Default: deploy-linux.sh raspberrypi.local pi
```

## Repository Structure

```
/workspace/
├── CMakeLists.txt              # Multi-platform root config
├── CMakePresets.json           # Build presets for all platforms
├── Components/                 # Reusable components
│   ├── CMakeLists.txt
│   └── Led/                    # Example component
├── ReferenceDeployment/        # Main deployment
│   ├── CMakeLists.txt          # Platform-aware deployment
│   ├── Main.cpp
│   └── Top/
│       ├── CMakeLists.txt      # Platform-specific instances
│       ├── instances.fpp       # Common instances
│       ├── instances-zephyr.fpp # Zephyr-specific
│       └── instances-native.fpp # Linux-specific
├── config/                     # Configuration
│   ├── CMakeLists.txt          # Platform-aware config
│   ├── FpConfig.h
│   └── FpConfig2.h             # Linux-specific config
├── scripts/                    # Build & deployment scripts
│   ├── build-zephyr.sh
│   ├── build-linux.sh
│   ├── flash-zephyr.sh
│   └── deploy-linux.sh
├── lib/                        # External dependencies
├── docs/                       # Documentation
├── prj.conf                    # Zephyr configuration
├── project.cmake               # Module registration
└── MULTIPLATFORM_GUIDE.md      # Comprehensive guide
```

## Recommended Folder Structure for New Projects

For optimal organization when developing modules for both platforms:

```
project-root/
├── CMakeLists.txt
├── CMakePresets.json
├── Components/
│   ├── CMakeLists.txt
│   ├── Common/             # Platform-agnostic components
│   ├── Zephyr/             # Zephyr-specific components
│   └── Linux/              # Linux-specific components
├── Deployments/
│   ├── ZephyrDeployment/
│   └── LinuxDeployment/
├── Config/
│   ├── Common/
│   ├── Zephyr/
│   └── Linux/
├── Drivers/
│   ├── Interface/
│   ├── STM32/
│   └── RPi/
├── scripts/
├── lib/
└── docs/
```

## Platform-Specific Code

Use these preprocessor definitions in your source code:

```cpp
#ifdef FPRIME_LINUX_TARGET
    // Linux/Raspberry Pi specific code
#elif defined(__ZEPHYR__)
    // Zephyr/STM32 specific code
#else
    // Generic code
#endif
```

## Key Features

1. **Single Codebase**: Develop modules once, deploy to multiple platforms
2. **CMake Integration**: Seamless platform switching via presets
3. **Backward Compatible**: Maintains support for existing Zephyr builds
4. **Script Automation**: Ready-to-use build and deployment scripts
5. **Clear Organization**: Well-documented folder structure recommendations

## Next Steps

1. Review `MULTIPLATFORM_GUIDE.md` for detailed documentation
2. Organize components into Common/Zephyr/Linux folders as needed
3. Add platform-specific drivers in the `Drivers/` directory
4. Create separate deployment configurations if needed
5. Implement platform-specific hardware abstraction layers

## Troubleshooting

- **Build fails for Zephyr**: Ensure Zephyr environment is sourced
- **Build fails for Linux**: Check cmake and gcc installation
- **Platform not detected**: Verify `FPRIME_TARGET_PLATFORM` is set correctly
- **Missing instances file**: Ensure `instances-native.fpp` exists for Linux builds
