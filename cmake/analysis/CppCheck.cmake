# Creates a custom cppcheck target for each given target
#
# Usage:
#   include(CppCheck)
#   set(target_ignore_list "/path/to/ignore" "/other/path/to/ignore")
#   cppcheck_targets("${target_ignore_list}" target1 target2 ...)
#
# Module dependencies:
#   Findcppcheck.cmake
#   expand_command.cmake
#
# Cache variables:
#   CPPCHECK_ENABLED_CHECKS
#   CPPCHECK_IGNORE_SYSTEM_HEADERS

if(NOT cppcheck_FOUND)
    find_package(cppcheck)
endif()

set(CPPCHECK_ENABLED_CHECKS
    "warning,style,performance,portability,unusedFunction,missingInclude"
    CACHE
    STRING
    "Comma separated list of enabled linter checks.") 

set(CPPCHECK_IGNORE_SYSTEM_HEADERS
    ON
    CACHE
    BOOL
    "Do not report missing system headers")

# 3rd-party workaround for a CMake bug that causes spaces to be escaped in
# the output of generator expressions
include(expand_command)

function(_cppcheck_target target_name cppcheck_suppress)
    set(source_dir "$<TARGET_PROPERTY:${target_name},SOURCE_DIR>")
    set(binary_dir "$<TARGET_PROPERTY:${target_name},BINARY_DIR>")
    set(include_dirs "$<TARGET_PROPERTY:${target_name},INCLUDE_DIRECTORIES>")

    unset(cppcheck_target_args)

    # If available, use either a compilation database, or the Visual Studio
    # project files
    if(CMAKE_EXPORT_COMPILE_COMMANDS)
        if (CMAKE_GENERATOR MATCHES "Make|Ninja")
            list(APPEND cppcheck_target_args "--project=${PROJECT_BINARY_DIR}/compile_commands.json")
        elseif(CMAKE_GENERATOR MATCHES "Visual Studio")
            list(APPEND cppcheck_target_args "--project=${binary_dir}/${target_name}.vcxproj")
        endif()
    endif()

    # Fallback to using the recursive directory scan mode
    if(NOT DEFINED cppcheck_target_args)
        list(APPEND cppcheck_target_args "${source_dir}")
    endif()

    expandable_command(cppcheck_cmd ${PROJECT_BINARY_DIR}
        ${cppcheck_EXECUTABLE}
        $<$<BOOL:${include_dirs}>:-I$<JOIN:${include_dirs}, -I>>
        --enable=${CPPCHECK_ENABLED_CHECKS}
        $<$<BOOL:${CPPCHECK_IGNORE_SYSTEM_HEADERS}>:--suppress=missingIncludeSystem>
        ${cppcheck_suppress}
        ${cppcheck_target_args}
        --force)
    add_custom_target(${target_name}-cppcheck
        COMMAND ${cppcheck_cmd}
        DEPENDS ${target_name}
        VERBATIM)
    set_property(TARGET ${target_name}-cppcheck
        PROPERTY FOLDER static-analysis)
endfunction()

function(cppcheck_targets suppress_list)
    if(NOT cppcheck_EXECUTABLE)
        return()
    endif()

    foreach(dir IN LISTS suppress_list)
        list(APPEND cppcheck_suppress "--suppress=*:${dir}*" "-i${dir}")
    endforeach()

    foreach(target_name IN LISTS ARGN)
        _cppcheck_target(${target_name} "${cppcheck_suppress}")
    endforeach()
endfunction()
