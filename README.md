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
└── stare_dispozitiv.h
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
[INFO] [UHD] linux; GNU C++ version 5.4.0 20160609; Boost_105800; UHD_3.14.0.0-release
[INFO] [B200] Loading firmware image: /usr/share/uhd/images/usrp_b200_fw.hex...
--------------------------------------------------
-- UHD Device 0
--------------------------------------------------
Device Address:
    serial: 315A8CF
    name: B200mini
    product: B200mini
    type: b200


```

Figure 1. The Final Architecture Target of the Project
![Imgur](https://i.imgur.com/ul77zik.png)
