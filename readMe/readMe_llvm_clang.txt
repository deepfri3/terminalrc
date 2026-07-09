
/////////////////////////////////////////////////
// Downlaod latest and greatest from GIT repos //
/////////////////////////////////////////////////
http://llvm.org/docs/GettingStarted.html

Git mirrors are available for a number of LLVM subprojects. These mirrors sync automatically with each Subversion commit and contain all necessary git-svn marks (so, you can recreate git-svn metadata locally). Note that right now mirrors reflect only trunk for each project. You can do the read-only Git clone of LLVM via:

$ git clone http://llvm.org/git/llvm.git

If you want to check out clang too, run:

$ cd llvm/tools
$ git clone http://llvm.org/git/clang.git

If you want to check out compiler-rt (required to build the sanitizers), run:

$ cd llvm/projects
$ git clone http://llvm.org/git/compiler-rt.git

If you want to check out libcxx and libcxxabi (optional), run:

$ cd llvm/projects
$ git clone http://llvm.org/git/libcxx.git
$ git clone http://llvm.org/git/libcxxabi.git

If you want to check out the Test Suite Source Code (optional), run:

$ cd llvm/projects
$ git clone http://llvm.org/git/test-suite.git

Since the upstream repository is in Subversion, you should use git pull --rebase instead of git pull to avoid generating a non-linear history in your clone. To configure git pull to pass --rebase by default on the master branch, run the following command:

$ git config branch.master.rebase true

//////////////////////////////
// Local LLVM Configuration //
//////////////////////////////

Once checked out from the Subversion repository, the LLVM suite source code must be configured before being built. For instructions using autotools please see Building LLVM With Autotools. The recommended process uses CMake. Unlinke the normal configure script, CMake generates the build files in whatever format you request as well as various *.inc files, and llvm/include/Config/config.h.

Variables are passed to cmake on the command line using the format -D<variable name>=<value>. The following variables are some common options used by people developing LLVM.
Variable 	Purpose
CMAKE_C_COMPILER 	Tells cmake which C compiler to use. By default, this will be /usr/bin/cc.
CMAKE_CXX_COMPILER 	Tells cmake which C++ compiler to use. By default, this will be /usr/bin/c++.
CMAKE_BUILD_TYPE 	Tells cmake what type of build you are trying to generate files for. Valid options are Debug, Release, RelWithDebInfo, and MinSizeRel. Default is Debug.
CMAKE_INSTALL_PREFIX 	Specifies the install directory to target when running the install action of the build files.
LLVM_TARGETS_TO_BUILD 	A semicolon delimited list controlling which targets will be built and linked into llc. This is equivalent to the --enable-targets option in the configure script. The default list is defined as LLVM_ALL_TARGETS, and can be set to include out-of-tree targets. The default value includes: AArch64, AMDGPU, ARM, BPF, CppBackend, Hexagon, Mips, MSP430, NVPTX, PowerPC, Sparc, SystemZ X86, XCore.
LLVM_ENABLE_DOXYGEN 	Build doxygen-based documentation from the source code This is disabled by default because it is slow and generates a lot of output.
LLVM_ENABLE_SPHINX 	Build sphinx-based documentation from the source code. This is disabled by default because it is slow and generates a lot of output.
LLVM_BUILD_LLVM_DYLIB 	Generate libLLVM.so. This library contains a default set of LLVM components that can be overridden with LLVM_DYLIB_COMPONENTS. The default contains most of LLVM and is defined in tools/llvm-shlib/CMakelists.txt.
LLVM_OPTIMIZED_TABLEGEN 	Builds a release tablegen that gets used during the LLVM build. This can dramatically speed up debug builds.

To configure LLVM, follow these steps:

    Change directory into the object root directory:

    % cd OBJ_ROOT

    Run the cmake:

    % cmake -G "Unix Makefiles" -DCMAKE_INSTALL_PREFIX=prefix=/install/path
      [other options] SRC_ROOT

    % cmake -G "Unix Makefiles" -DCMAKE_C_COMPILER=/usr/bin/gcc-4.7 -DCMAKE_CXX_COMPILER=g++-4.7 -DCMAKE_INSTALL_PREFIX=/usr/local/llvm-3.6 ../llvm     

Compiling the LLVM Suite Source Code

Unlike with autotools, with CMake your build type is defined at configuration. If you want to change your build type, you can re-run cmake with the following invocation:

    % cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=type SRC_ROOT

Between runs, CMake preserves the values set for all options. CMake has the following build types defined:

Debug

    These builds are the default. The build system will compile the tools and libraries unoptimized, with debugging information, and asserts enabled.

Release

    For these builds, the build system will compile the tools and libraries with optimizations enabled and not generate debug info. CMakes default optimization level is -O3. This can be configured by setting the CMAKE_CXX_FLAGS_RELEASE variable on the CMake command line.

RelWithDebInfo

    These builds are useful when debugging. They generate optimized binaries with debug information. CMakes default optimization level is -O2. This can be configured by setting the CMAKE_CXX_FLAGS_RELWITHDEBINFO variable on the CMake command line.

Once you have LLVM configured, you can build it by entering the OBJ_ROOT directory and issuing the following command:

% make

If the build fails, please check here to see if you are using a version of GCC that is known not to compile LLVM.

If you have multiple processors in your machine, you may wish to use some of the parallel build options provided by GNU Make. For example, you could use the command:

% make -j2

There are several special targets which are useful when working with the LLVM source code:

make clean

    Removes all files generated by the build. This includes object files, generated C/C++ files, libraries, and executables.

make install

    Installs LLVM header files, libraries, tools, and documentation in a hierarchy under $PREFIX, specified with CMAKE_INSTALL_PREFIX, which defaults to /usr/local.

make docs-llvm-html

    If configured with -DLLVM_ENABLE_SPHINX=On, this will generate a directory at OBJ_ROOT/docs/html which contains the HTML formatted documentation.

///////////////////////
// Clang user manual //
///////////////////////

http://clang.llvm.org/docs/UsersManual.html
http://clang.llvm.org/get_started.html

Building Clang and Working with the Code
On Unix-like Systems

If you would like to check out and build Clang, the current procedure is as follows:

    Get the required tools.
        See Getting Started with the LLVM System - Requirements.
        Note also that Python is needed for running the test suite. Get it at: http://www.python.org/download
        Standard build process uses CMake. Get it at: http://www.cmake.org/download
    Checkout LLVM:
        Change directory to where you want the llvm directory placed.
        svn co http://llvm.org/svn/llvm-project/llvm/trunk llvm
    Checkout Clang:
        cd llvm/tools
        svn co http://llvm.org/svn/llvm-project/cfe/trunk clang
        cd ../..
    Checkout extra Clang Tools: (optional)
        cd llvm/tools/clang/tools
        svn co http://llvm.org/svn/llvm-project/clang-tools-extra/trunk extra
        cd ../../../..
    Checkout Compiler-RT:
        cd llvm/projects
        svn co http://llvm.org/svn/llvm-project/compiler-rt/trunk compiler-rt
        cd ../..
    Build LLVM and Clang:
        mkdir build (in-tree build is not supported)
        cd build
        cmake -G "Unix Makefiles" ../llvm
        make
        This builds both LLVM and Clang for debug mode.
        Note: For subsequent Clang development, you can just run make clang.
        CMake allows you to generate project files for several IDEs: Xcode, Eclipse CDT4, CodeBlocks, Qt-Creator (use the CodeBlocks generator), KDevelop3. For more details see Building LLVM with CMake page.
        You can also build Clang with autotools, but some features may be unavailable there.
    If you intend to use Clang's C++ support, you may need to tell it how to find your C++ standard library headers. In general, Clang will detect the best version of libstdc++ headers available and use them - it will look both for system installations of libstdc++ as well as installations adjacent to Clang itself. If your configuration fits neither of these scenarios, you can use the --with-gcc-toolchain configure option to tell Clang where the gcc containing the desired libstdc++ is installed.
    Try it out (assuming you add llvm/Debug+Asserts/bin to your path):
        clang --help
        clang file.c -fsyntax-only (check for correctness)
        clang file.c -S -emit-llvm -o - (print out unoptimized llvm code)
        clang file.c -S -emit-llvm -o - -O3
        clang file.c -S -O3 -o - (output native machine code)

Note that the C front-end uses LLVM, but does not depend on llvm-gcc. If you encounter problems with building Clang, make sure you have the latest SVN version of LLVM. LLVM contains support libraries for Clang that will be updated as well as development on Clang progresses.
Simultaneously Building Clang and LLVM:

Once you have checked out Clang into the llvm source tree it will build along with the rest of llvm. To build all of LLVM and Clang together all at once simply run make from the root LLVM directory.

Note: Observe that Clang is technically part of a separate Subversion repository. As mentioned above, the latest Clang sources are tied to the latest sources in the LLVM tree. You can update your toplevel LLVM project and all (possibly unrelated) projects inside it with make update. This will run svn update on all subdirectories related to subversion. 




