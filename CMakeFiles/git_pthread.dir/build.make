# CMAKE generated file: DO NOT EDIT!
# Generated by "Unix Makefiles" Generator, CMake Version 3.7

# Delete rule output on recipe failure.
.DELETE_ON_ERROR:


#=============================================================================
# Special targets provided by cmake.

# Disable implicit rules so canonical targets will work.
.SUFFIXES:


# Remove some rules from gmake that .SUFFIXES does not remove.
SUFFIXES =

.SUFFIXES: .hpux_make_needs_suffix_list


# Suppress display of executed commands.
$(VERBOSE).SILENT:


# A target that is always out of date.
cmake_force:

.PHONY : cmake_force

#=============================================================================
# Set environment variables for the build.

# The shell in which to execute make rules.
SHELL = /bin/sh

# The CMake executable.
CMAKE_COMMAND = /usr/local/bin/cmake

# The command to remove a file.
RM = /usr/local/bin/cmake -E remove -f

# Escaping for special characters.
EQUALS = =

# The top-level source directory on which CMake was run.
CMAKE_SOURCE_DIR = /home/jame/share_user/git_pthread

# The top-level build directory on which CMake was run.
CMAKE_BINARY_DIR = /home/jame/share_user/git_pthread

# Include any dependencies generated for this target.
include CMakeFiles/git_pthread.dir/depend.make

# Include the progress variables for this target.
include CMakeFiles/git_pthread.dir/progress.make

# Include the compile flags for this target's objects.
include CMakeFiles/git_pthread.dir/flags.make

CMakeFiles/git_pthread.dir/main.cpp.o: CMakeFiles/git_pthread.dir/flags.make
CMakeFiles/git_pthread.dir/main.cpp.o: main.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jame/share_user/git_pthread/CMakeFiles --progress-num=$(CMAKE_PROGRESS_1) "Building CXX object CMakeFiles/git_pthread.dir/main.cpp.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/git_pthread.dir/main.cpp.o -c /home/jame/share_user/git_pthread/main.cpp

CMakeFiles/git_pthread.dir/main.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/git_pthread.dir/main.cpp.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jame/share_user/git_pthread/main.cpp > CMakeFiles/git_pthread.dir/main.cpp.i

CMakeFiles/git_pthread.dir/main.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/git_pthread.dir/main.cpp.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jame/share_user/git_pthread/main.cpp -o CMakeFiles/git_pthread.dir/main.cpp.s

CMakeFiles/git_pthread.dir/main.cpp.o.requires:

.PHONY : CMakeFiles/git_pthread.dir/main.cpp.o.requires

CMakeFiles/git_pthread.dir/main.cpp.o.provides: CMakeFiles/git_pthread.dir/main.cpp.o.requires
	$(MAKE) -f CMakeFiles/git_pthread.dir/build.make CMakeFiles/git_pthread.dir/main.cpp.o.provides.build
.PHONY : CMakeFiles/git_pthread.dir/main.cpp.o.provides

CMakeFiles/git_pthread.dir/main.cpp.o.provides.build: CMakeFiles/git_pthread.dir/main.cpp.o


CMakeFiles/git_pthread.dir/easylogger/elog.c.o: CMakeFiles/git_pthread.dir/flags.make
CMakeFiles/git_pthread.dir/easylogger/elog.c.o: easylogger/elog.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jame/share_user/git_pthread/CMakeFiles --progress-num=$(CMAKE_PROGRESS_2) "Building C object CMakeFiles/git_pthread.dir/easylogger/elog.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/git_pthread.dir/easylogger/elog.c.o   -c /home/jame/share_user/git_pthread/easylogger/elog.c

CMakeFiles/git_pthread.dir/easylogger/elog.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/git_pthread.dir/easylogger/elog.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/jame/share_user/git_pthread/easylogger/elog.c > CMakeFiles/git_pthread.dir/easylogger/elog.c.i

CMakeFiles/git_pthread.dir/easylogger/elog.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/git_pthread.dir/easylogger/elog.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/jame/share_user/git_pthread/easylogger/elog.c -o CMakeFiles/git_pthread.dir/easylogger/elog.c.s

CMakeFiles/git_pthread.dir/easylogger/elog.c.o.requires:

.PHONY : CMakeFiles/git_pthread.dir/easylogger/elog.c.o.requires

CMakeFiles/git_pthread.dir/easylogger/elog.c.o.provides: CMakeFiles/git_pthread.dir/easylogger/elog.c.o.requires
	$(MAKE) -f CMakeFiles/git_pthread.dir/build.make CMakeFiles/git_pthread.dir/easylogger/elog.c.o.provides.build
.PHONY : CMakeFiles/git_pthread.dir/easylogger/elog.c.o.provides

CMakeFiles/git_pthread.dir/easylogger/elog.c.o.provides.build: CMakeFiles/git_pthread.dir/easylogger/elog.c.o


CMakeFiles/git_pthread.dir/easylogger/elog_port.c.o: CMakeFiles/git_pthread.dir/flags.make
CMakeFiles/git_pthread.dir/easylogger/elog_port.c.o: easylogger/elog_port.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jame/share_user/git_pthread/CMakeFiles --progress-num=$(CMAKE_PROGRESS_3) "Building C object CMakeFiles/git_pthread.dir/easylogger/elog_port.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/git_pthread.dir/easylogger/elog_port.c.o   -c /home/jame/share_user/git_pthread/easylogger/elog_port.c

CMakeFiles/git_pthread.dir/easylogger/elog_port.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/git_pthread.dir/easylogger/elog_port.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/jame/share_user/git_pthread/easylogger/elog_port.c > CMakeFiles/git_pthread.dir/easylogger/elog_port.c.i

CMakeFiles/git_pthread.dir/easylogger/elog_port.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/git_pthread.dir/easylogger/elog_port.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/jame/share_user/git_pthread/easylogger/elog_port.c -o CMakeFiles/git_pthread.dir/easylogger/elog_port.c.s

CMakeFiles/git_pthread.dir/easylogger/elog_port.c.o.requires:

.PHONY : CMakeFiles/git_pthread.dir/easylogger/elog_port.c.o.requires

CMakeFiles/git_pthread.dir/easylogger/elog_port.c.o.provides: CMakeFiles/git_pthread.dir/easylogger/elog_port.c.o.requires
	$(MAKE) -f CMakeFiles/git_pthread.dir/build.make CMakeFiles/git_pthread.dir/easylogger/elog_port.c.o.provides.build
.PHONY : CMakeFiles/git_pthread.dir/easylogger/elog_port.c.o.provides

CMakeFiles/git_pthread.dir/easylogger/elog_port.c.o.provides.build: CMakeFiles/git_pthread.dir/easylogger/elog_port.c.o


CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.o: CMakeFiles/git_pthread.dir/flags.make
CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.o: easylogger/elog_utils.c
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jame/share_user/git_pthread/CMakeFiles --progress-num=$(CMAKE_PROGRESS_4) "Building C object CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.o"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -o CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.o   -c /home/jame/share_user/git_pthread/easylogger/elog_utils.c

CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing C source to CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.i"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -E /home/jame/share_user/git_pthread/easylogger/elog_utils.c > CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.i

CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling C source to assembly CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.s"
	/usr/bin/cc  $(C_DEFINES) $(C_INCLUDES) $(C_FLAGS) -S /home/jame/share_user/git_pthread/easylogger/elog_utils.c -o CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.s

CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.o.requires:

.PHONY : CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.o.requires

CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.o.provides: CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.o.requires
	$(MAKE) -f CMakeFiles/git_pthread.dir/build.make CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.o.provides.build
.PHONY : CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.o.provides

CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.o.provides.build: CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.o


CMakeFiles/git_pthread.dir/easylogger/log.cpp.o: CMakeFiles/git_pthread.dir/flags.make
CMakeFiles/git_pthread.dir/easylogger/log.cpp.o: easylogger/log.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jame/share_user/git_pthread/CMakeFiles --progress-num=$(CMAKE_PROGRESS_5) "Building CXX object CMakeFiles/git_pthread.dir/easylogger/log.cpp.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/git_pthread.dir/easylogger/log.cpp.o -c /home/jame/share_user/git_pthread/easylogger/log.cpp

CMakeFiles/git_pthread.dir/easylogger/log.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/git_pthread.dir/easylogger/log.cpp.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jame/share_user/git_pthread/easylogger/log.cpp > CMakeFiles/git_pthread.dir/easylogger/log.cpp.i

CMakeFiles/git_pthread.dir/easylogger/log.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/git_pthread.dir/easylogger/log.cpp.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jame/share_user/git_pthread/easylogger/log.cpp -o CMakeFiles/git_pthread.dir/easylogger/log.cpp.s

CMakeFiles/git_pthread.dir/easylogger/log.cpp.o.requires:

.PHONY : CMakeFiles/git_pthread.dir/easylogger/log.cpp.o.requires

CMakeFiles/git_pthread.dir/easylogger/log.cpp.o.provides: CMakeFiles/git_pthread.dir/easylogger/log.cpp.o.requires
	$(MAKE) -f CMakeFiles/git_pthread.dir/build.make CMakeFiles/git_pthread.dir/easylogger/log.cpp.o.provides.build
.PHONY : CMakeFiles/git_pthread.dir/easylogger/log.cpp.o.provides

CMakeFiles/git_pthread.dir/easylogger/log.cpp.o.provides.build: CMakeFiles/git_pthread.dir/easylogger/log.cpp.o


CMakeFiles/git_pthread.dir/src/dump_core.cpp.o: CMakeFiles/git_pthread.dir/flags.make
CMakeFiles/git_pthread.dir/src/dump_core.cpp.o: src/dump_core.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jame/share_user/git_pthread/CMakeFiles --progress-num=$(CMAKE_PROGRESS_6) "Building CXX object CMakeFiles/git_pthread.dir/src/dump_core.cpp.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/git_pthread.dir/src/dump_core.cpp.o -c /home/jame/share_user/git_pthread/src/dump_core.cpp

CMakeFiles/git_pthread.dir/src/dump_core.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/git_pthread.dir/src/dump_core.cpp.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jame/share_user/git_pthread/src/dump_core.cpp > CMakeFiles/git_pthread.dir/src/dump_core.cpp.i

CMakeFiles/git_pthread.dir/src/dump_core.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/git_pthread.dir/src/dump_core.cpp.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jame/share_user/git_pthread/src/dump_core.cpp -o CMakeFiles/git_pthread.dir/src/dump_core.cpp.s

CMakeFiles/git_pthread.dir/src/dump_core.cpp.o.requires:

.PHONY : CMakeFiles/git_pthread.dir/src/dump_core.cpp.o.requires

CMakeFiles/git_pthread.dir/src/dump_core.cpp.o.provides: CMakeFiles/git_pthread.dir/src/dump_core.cpp.o.requires
	$(MAKE) -f CMakeFiles/git_pthread.dir/build.make CMakeFiles/git_pthread.dir/src/dump_core.cpp.o.provides.build
.PHONY : CMakeFiles/git_pthread.dir/src/dump_core.cpp.o.provides

CMakeFiles/git_pthread.dir/src/dump_core.cpp.o.provides.build: CMakeFiles/git_pthread.dir/src/dump_core.cpp.o


CMakeFiles/git_pthread.dir/src/pthread_template.cpp.o: CMakeFiles/git_pthread.dir/flags.make
CMakeFiles/git_pthread.dir/src/pthread_template.cpp.o: src/pthread_template.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jame/share_user/git_pthread/CMakeFiles --progress-num=$(CMAKE_PROGRESS_7) "Building CXX object CMakeFiles/git_pthread.dir/src/pthread_template.cpp.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/git_pthread.dir/src/pthread_template.cpp.o -c /home/jame/share_user/git_pthread/src/pthread_template.cpp

CMakeFiles/git_pthread.dir/src/pthread_template.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/git_pthread.dir/src/pthread_template.cpp.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jame/share_user/git_pthread/src/pthread_template.cpp > CMakeFiles/git_pthread.dir/src/pthread_template.cpp.i

CMakeFiles/git_pthread.dir/src/pthread_template.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/git_pthread.dir/src/pthread_template.cpp.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jame/share_user/git_pthread/src/pthread_template.cpp -o CMakeFiles/git_pthread.dir/src/pthread_template.cpp.s

CMakeFiles/git_pthread.dir/src/pthread_template.cpp.o.requires:

.PHONY : CMakeFiles/git_pthread.dir/src/pthread_template.cpp.o.requires

CMakeFiles/git_pthread.dir/src/pthread_template.cpp.o.provides: CMakeFiles/git_pthread.dir/src/pthread_template.cpp.o.requires
	$(MAKE) -f CMakeFiles/git_pthread.dir/build.make CMakeFiles/git_pthread.dir/src/pthread_template.cpp.o.provides.build
.PHONY : CMakeFiles/git_pthread.dir/src/pthread_template.cpp.o.provides

CMakeFiles/git_pthread.dir/src/pthread_template.cpp.o.provides.build: CMakeFiles/git_pthread.dir/src/pthread_template.cpp.o


CMakeFiles/git_pthread.dir/src/time_operate.cpp.o: CMakeFiles/git_pthread.dir/flags.make
CMakeFiles/git_pthread.dir/src/time_operate.cpp.o: src/time_operate.cpp
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --progress-dir=/home/jame/share_user/git_pthread/CMakeFiles --progress-num=$(CMAKE_PROGRESS_8) "Building CXX object CMakeFiles/git_pthread.dir/src/time_operate.cpp.o"
	/usr/bin/c++   $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -o CMakeFiles/git_pthread.dir/src/time_operate.cpp.o -c /home/jame/share_user/git_pthread/src/time_operate.cpp

CMakeFiles/git_pthread.dir/src/time_operate.cpp.i: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Preprocessing CXX source to CMakeFiles/git_pthread.dir/src/time_operate.cpp.i"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -E /home/jame/share_user/git_pthread/src/time_operate.cpp > CMakeFiles/git_pthread.dir/src/time_operate.cpp.i

CMakeFiles/git_pthread.dir/src/time_operate.cpp.s: cmake_force
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green "Compiling CXX source to assembly CMakeFiles/git_pthread.dir/src/time_operate.cpp.s"
	/usr/bin/c++  $(CXX_DEFINES) $(CXX_INCLUDES) $(CXX_FLAGS) -S /home/jame/share_user/git_pthread/src/time_operate.cpp -o CMakeFiles/git_pthread.dir/src/time_operate.cpp.s

CMakeFiles/git_pthread.dir/src/time_operate.cpp.o.requires:

.PHONY : CMakeFiles/git_pthread.dir/src/time_operate.cpp.o.requires

CMakeFiles/git_pthread.dir/src/time_operate.cpp.o.provides: CMakeFiles/git_pthread.dir/src/time_operate.cpp.o.requires
	$(MAKE) -f CMakeFiles/git_pthread.dir/build.make CMakeFiles/git_pthread.dir/src/time_operate.cpp.o.provides.build
.PHONY : CMakeFiles/git_pthread.dir/src/time_operate.cpp.o.provides

CMakeFiles/git_pthread.dir/src/time_operate.cpp.o.provides.build: CMakeFiles/git_pthread.dir/src/time_operate.cpp.o


# Object files for target git_pthread
git_pthread_OBJECTS = \
"CMakeFiles/git_pthread.dir/main.cpp.o" \
"CMakeFiles/git_pthread.dir/easylogger/elog.c.o" \
"CMakeFiles/git_pthread.dir/easylogger/elog_port.c.o" \
"CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.o" \
"CMakeFiles/git_pthread.dir/easylogger/log.cpp.o" \
"CMakeFiles/git_pthread.dir/src/dump_core.cpp.o" \
"CMakeFiles/git_pthread.dir/src/pthread_template.cpp.o" \
"CMakeFiles/git_pthread.dir/src/time_operate.cpp.o"

# External object files for target git_pthread
git_pthread_EXTERNAL_OBJECTS =

git_pthread: CMakeFiles/git_pthread.dir/main.cpp.o
git_pthread: CMakeFiles/git_pthread.dir/easylogger/elog.c.o
git_pthread: CMakeFiles/git_pthread.dir/easylogger/elog_port.c.o
git_pthread: CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.o
git_pthread: CMakeFiles/git_pthread.dir/easylogger/log.cpp.o
git_pthread: CMakeFiles/git_pthread.dir/src/dump_core.cpp.o
git_pthread: CMakeFiles/git_pthread.dir/src/pthread_template.cpp.o
git_pthread: CMakeFiles/git_pthread.dir/src/time_operate.cpp.o
git_pthread: CMakeFiles/git_pthread.dir/build.make
git_pthread: CMakeFiles/git_pthread.dir/link.txt
	@$(CMAKE_COMMAND) -E cmake_echo_color --switch=$(COLOR) --green --bold --progress-dir=/home/jame/share_user/git_pthread/CMakeFiles --progress-num=$(CMAKE_PROGRESS_9) "Linking CXX executable git_pthread"
	$(CMAKE_COMMAND) -E cmake_link_script CMakeFiles/git_pthread.dir/link.txt --verbose=$(VERBOSE)

# Rule to build all files generated by this target.
CMakeFiles/git_pthread.dir/build: git_pthread

.PHONY : CMakeFiles/git_pthread.dir/build

CMakeFiles/git_pthread.dir/requires: CMakeFiles/git_pthread.dir/main.cpp.o.requires
CMakeFiles/git_pthread.dir/requires: CMakeFiles/git_pthread.dir/easylogger/elog.c.o.requires
CMakeFiles/git_pthread.dir/requires: CMakeFiles/git_pthread.dir/easylogger/elog_port.c.o.requires
CMakeFiles/git_pthread.dir/requires: CMakeFiles/git_pthread.dir/easylogger/elog_utils.c.o.requires
CMakeFiles/git_pthread.dir/requires: CMakeFiles/git_pthread.dir/easylogger/log.cpp.o.requires
CMakeFiles/git_pthread.dir/requires: CMakeFiles/git_pthread.dir/src/dump_core.cpp.o.requires
CMakeFiles/git_pthread.dir/requires: CMakeFiles/git_pthread.dir/src/pthread_template.cpp.o.requires
CMakeFiles/git_pthread.dir/requires: CMakeFiles/git_pthread.dir/src/time_operate.cpp.o.requires

.PHONY : CMakeFiles/git_pthread.dir/requires

CMakeFiles/git_pthread.dir/clean:
	$(CMAKE_COMMAND) -P CMakeFiles/git_pthread.dir/cmake_clean.cmake
.PHONY : CMakeFiles/git_pthread.dir/clean

CMakeFiles/git_pthread.dir/depend:
	cd /home/jame/share_user/git_pthread && $(CMAKE_COMMAND) -E cmake_depends "Unix Makefiles" /home/jame/share_user/git_pthread /home/jame/share_user/git_pthread /home/jame/share_user/git_pthread /home/jame/share_user/git_pthread /home/jame/share_user/git_pthread/CMakeFiles/git_pthread.dir/DependInfo.cmake --color=$(COLOR)
.PHONY : CMakeFiles/git_pthread.dir/depend

