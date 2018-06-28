# From the list of passed in compiler flags, add only those to the target
# which are supported by the selected compiler
#
# Usage:
#   include(SupportedCompileOptions)
#   set(CXX_FLAGS -Wall -Wextra -Wpedantic -Wduplicated-branches -Wunused)
#   target_supported_compile_options(target_name PUBLIC "${CXX_FLAGS}")
#
# Module dependencies:
#   CheckCXXCompilerFlag

include(CheckCXXCompilerFlag)

function(target_add_cxx_flag_if_supported target_name visibility flag_name)
    check_cxx_compiler_flag("${flag_name}" has_flag_${flag_name})
    if(has_flag_${flag_name})
        target_compile_options(${target_name} ${visibility} ${flag_name})
    endif()
endfunction()

function(target_supported_compile_options target_name visibility flags)
    foreach(flag_name IN LISTS flags)
        target_add_cxx_flag_if_supported(${target_name} ${visibility} ${flag_name})
    endforeach()
endfunction()

