## eMTC

This file is design to controll the RRUnit using the UHD-Framework

In order to work with this software there are two steps that have to be completed:

Step no 1. **Prepare the environment** of the hoasting machie ( either VirtualMachine or PhysicalMachine)
    **Note** check the commands below.
    
Step no 2. **Build** the eMTC project.
    **Note** check the commands below.
    
Step no 3. In order to **run the software**, go to the $eMTCPATH/build director and run the below command


The project structure:
```
.
├── build.sh
├── CMakeLists.txt
├── fisier_main
├── fisier_main.cpp
├── logs
│   ├── cmake.log
│   └── make.log
├── output
│   └── output.log
├── prepare_environment.sh
├── README.md
├── RXtoUDP.cpp
└── stare_dispozitiv.h

2 directories, 11 files
```
Prepare the hoast machine environment in order to work with the UHD Framework

```
mihai@mihaix411ua:~/eMTC$ ./prepare_environment.sh

```
In order to build the project please run the following command:

```
mihai@mihaix411ua:~/eMTC$  ./build.sh 
###############################
The compile process has started
###############################
The process has finished
###############################

```

After the compilation of the project the structure of the project directory it is the following:

```
.
├── build
│   ├── CMakeCache.txt
│   ├── CMakeFiles
│   │   ├── 3.5.1
│   │   │   ├── CMakeCCompiler.cmake
│   │   │   ├── CMakeCXXCompiler.cmake
│   │   │   ├── CMakeDetermineCompilerABI_C.bin
│   │   │   ├── CMakeDetermineCompilerABI_CXX.bin
│   │   │   ├── CMakeSystem.cmake
│   │   │   ├── CompilerIdC
│   │   │   │   ├── a.out
│   │   │   │   └── CMakeCCompilerId.c
│   │   │   └── CompilerIdCXX
│   │   │       ├── a.out
│   │   │       └── CMakeCXXCompilerId.cpp
│   │   ├── cmake.check_cache
│   │   ├── CMakeDirectoryInformation.cmake
│   │   ├── CMakeError.log
│   │   ├── CMakeOutput.log
│   │   ├── CMakeTmp
│   │   ├── feature_tests.bin
│   │   ├── feature_tests.c
│   │   ├── feature_tests.cxx
│   │   ├── fisier_main.dir
│   │   │   ├── build.make
│   │   │   ├── cmake_clean.cmake
│   │   │   ├── CXX.includecache
│   │   │   ├── DependInfo.cmake
│   │   │   ├── depend.internal
│   │   │   ├── depend.make
│   │   │   ├── fisier_main.cpp.o
│   │   │   ├── flags.make
│   │   │   ├── link.txt
│   │   │   └── progress.make
│   │   ├── Makefile2
│   │   ├── Makefile.cmake
│   │   ├── progress.marks
│   │   └── TargetDirectories.txt
│   ├── cmake_install.cmake
│   ├── fisier_main
│   └── Makefile
├── CMakeLists.txt
├── fisier_main
├── fisier_main.cpp
└── stare_dispozitiv.h

7 directories, 38 files
```

The following output it is the aspected one
```
mihai@mihaix411ua:~/eMTC/build$ ./fisier_main 
[INFO] [UHD] linux; GNU C++ version 7.3.0; Boost_106501; UHD_3.14.0.0-release
[WARNING
] [UHD] Unable to set the thread priority. Performance may be negatively affected.
Please see the general application notes in the manual for instructions.
EnvironmentError: OSError: error in pthread_setschedparamCreating the usrp device with: ...

[INFO] [B200] Detected Device: B200mini
[INFO] [B200] Operating over USB 3.
[INFO] [B200] Initialize CODEC control...
[INFO] [B200] Initialize Radio control...
[INFO] [B200] Performing register loopback test... 
[INFO] [B200] Register loopback test passed
[INFO] [B200] Setting master clock rate selection to 'automatic'.
[INFO] [B200] Asking for clock rate 16.000000 MHz... 
[INFO] [B200] Actually got clock rate 16.000000 MHz.
Using Device: Single USRP:
  Device: B-Series Device
  Mboard 0: B200mini
  RX Channel: 0
    RX DSP: 0
    RX Dboard: A
    RX Subdev: FE-RX1
  TX Channel: 0
    TX DSP: 0
    TX Dboard: A
    TX Subdev: FE-TX1

Setting RX Rate: 6.250000 Msps...
[INFO] [B200] Asking for clock rate 50.000000 MHz... 
[INFO] [B200] Actually got clock rate 50.000000 MHz.
Actual RX Rate: 6.250000 Msps...

Setting RX Freq: 0.000000 MHz...
Actual RX Freq: 25.000000 MHz...

Setting RX Gain: 0.000000 dB...
Actual RX Gain: 0.000000 dB...

Checking RX: LO: locked ...

Done!


```

Figure 1. The Final Architecture Target of the Project
![Imgur](https://i.imgur.com/ul77zik.png)
