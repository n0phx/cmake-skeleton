cmake_minimum_required(VERSION 3.10)

# Enforce cpp standard
set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)
# Prevent in-source builds
set(CMAKE_DISABLE_SOURCE_CHANGES ON)
set(CMAKE_DISABLE_IN_SOURCE_BUILD ON)
# Create compilation database
set(CMAKE_EXPORT_COMPILE_COMMANDS ON CACHE BOOL "" FORCE)

project(ProjectName)

set_property(GLOBAL PROPERTY USE_FOLDERS ON)

list(APPEND CMAKE_MODULE_PATH
    "${PROJECT_SOURCE_DIR}/cmake"
    "${PROJECT_SOURCE_DIR}/cmake/analysis")

# Check assumptions about the compiler being used
include(CheckCXXSourceFileCompiles)
check_cxx_source_file_compiles(tests/compiler/compiler_test.cxx COMPILER_ASSERTIONS_PASSED)
if(NOT COMPILER_ASSERTIONS_PASSED)
    message(FATAL_ERROR "Compiler assertions failed.")
endif()

# Global compiler options that should apply to all targets
# Must be defined before targets are introduced
if(MSVC)
    add_compile_options($<$<CONFIG:Release>:/O2>)
else()
    add_compile_options($<$<CONFIG:Release>:-O3>)
    link_libraries(stdc++fs)
endif()

add_subdirectory(engine/src)
set(ENGINE_TARGET engine)

add_subdirectory(game/src)
set(GAME_TARGET game)

# Target specific compiler options
include(SupportedCompileOptions)
if(MSVC)
    set(CXX_FLAGS /permissive- /W4 /w44061 /w44062 /w14242 /w14254 /w14263
                  /w14265 /w14266 /w14287 /we4289 /w14296 /w14302 /w14311
                  /w14365 /w14388 /w14545 /w14546 /w14547 /w14549 /w14555
                  /w14619 /w14640 /w14826 /w14905 /w14906 /w14928)
    target_supported_compile_options(${ENGINE_TARGET} PUBLIC "${CXX_FLAGS}")
else()
    set(CXX_FLAGS -Wall -Wextra -Wpedantic -Wcast-align -Wconversion
                  -Wduplicated-branches -Wduplicated-cond -Wexit-time-destructors
                  -Wglobal-constructors -Wlogical-op -Wmissing-noreturn
                  -Wnon-virtual-dtor -Wnull-dereference -Wold-style-cast
                  -Woverloaded-virtual -Wshadow -Wsign-conversion -Wunreachable-code
                  -Wunused -Wuseless-cast -Wweak-vtables
                  -Wno-unknown-pragmas)
    target_supported_compile_options(${ENGINE_TARGET} PUBLIC "${CXX_FLAGS}")
endif()

include(EnableSanitizers)
sanitize_targets(${GAME_TARGET} ${ENGINE_TARGET})

# Static analysis
include(Analysis)
set(COMMON_IGNORE_LIST "${PROJECT_SOURCE_DIR}/ext" "${PROJECT_BINARY_DIR}")
analyse_targets("${COMMON_IGNORE_LIST}" ${ENGINE_TARGET} ${GAME_TARGET})
