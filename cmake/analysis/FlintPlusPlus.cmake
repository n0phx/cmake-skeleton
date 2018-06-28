# Creates a custom flint target for each given target
#
# Usage:
#   include(FlintPlusPlus)
#   flint_targets(target1 target2 ...)
#
# Module dependencies:
#   Findflintplusplus.cmake

if(NOT flint_FOUND)
    find_package(flint)
endif()

function(_flint_target target_name)
    set(source_dir "$<TARGET_PROPERTY:${target_name},SOURCE_DIR>")
    add_custom_target(${target_name}-flint
        COMMAND ${flint_EXECUTABLE} -r ${source_dir}
        DEPENDS ${target_name}
        WORKING_DIRECTORY ${PROJECT_BINARY_DIR}
        VERBATIM)
    set_property(TARGET ${target_name}-flint PROPERTY
        FOLDER static-analysis)
endfunction()

function(flint_targets)
    if(NOT flint_EXECUTABLE)
        return()
    endif()

    foreach(target_name IN LISTS ARGN)
        _flint_target(${target_name})
    endforeach()
endfunction()

