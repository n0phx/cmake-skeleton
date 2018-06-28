# Creates a custom oclint target for each given target
#
# Usage:
#   include(OCLint)
#   oclint_targets(target1 target2 ...)
#
# Module dependencies:
#   Findoclint.cmake

if(NOT oclint_FOUND)
    find_package(oclint)
endif()

function(_oclint_target target_name oclint_suppress)
    add_custom_target(${target_name}-oclint
        COMMAND ${oclint_EXECUTABLE} ${oclint_suppress}
        DEPENDS ${target_name}
        WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
        VERBATIM)
    set_property(TARGET ${target_name}-oclint PROPERTY
        FOLDER static-analysis)
endfunction()

function(oclint_targets suppress_list)
    if(NOT oclint_EXECUTABLE)
        return()
    endif()

    foreach(dir IN LISTS suppress_list)
        list(APPEND oclint_suppress "-e${dir}.*")
    endforeach()

    foreach(target_name IN LISTS ARGN)
        _oclint_target(${target_name} "${oclint_suppress}")
    endforeach()
endfunction()

