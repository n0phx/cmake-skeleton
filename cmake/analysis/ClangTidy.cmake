# Creates a custom clang-tidy target for each given target
#
# Usage:
#   include(ClangTidy)
#   clangtidy_targets(target1 target2 ...)
#
# or in order to use CMake's built-in clang-tidy support
# without adding a custom clang-tidy target:
#
#   auto_clangtidy_targets(target1 target2 ...)
#
# Module dependencies:
#   FindClangTidy.cmake
#   FindRunClangTidy.cmake

if(NOT ClangTidy_FOUND)
    find_package(ClangTidy)
endif()
if(NOT RunClangTidy_FOUND)
    find_package(RunClangTidy)
endif()

function(_clangtidy_target target_name)
    set(source_dir "$<TARGET_PROPERTY:${target_name},SOURCE_DIR>")
    add_custom_target(${target_name}-clangtidy
        COMMAND
            ${RunClangTidy_EXECUTABLE}
            "-clang-tidy-binary=${ClangTidy_EXECUTABLE}"
            "-p=${PROJECT_BINARY_DIR}"
            "-header-filter=${source_dir}/.*"
            "${source_dir}/.*"
        DEPENDS ${target_name}
        WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
        VERBATIM)
    set_property(TARGET ${target_name}-clangtidy PROPERTY
        FOLDER static-analysis)
endfunction()

# Add a custom analysis target for running clang-tidy
function(clangtidy_targets)
    if(NOT ClangTidy_EXECUTABLE OR NOT RunClangTidy_EXECUTABLE)
        return()
    endif()

    if(NOT CMAKE_EXPORT_COMPILE_COMMANDS OR NOT (CMAKE_GENERATOR MATCHES "Make|Ninja"))
        message(STATUS "No compilation database available with the selected generator.")
        return()
    endif()

    foreach(target_name IN LISTS ARGN)
        _clangtidy_target(${target_name})
    endforeach()
endfunction()

# Use CMake's built-in clang-tidy support to integrate the tool
function(auto_clangtidy_targets)
    if(NOT ClangTidy_EXECUTABLE)
        return()
    endif()

    foreach(target_name IN LISTS ARGN)
        set_target_properties(${target_name} PROPERTIES
            CXX_CLANG_TIDY ${ClangTidy_EXECUTABLE})
    endforeach()
endfunction()

