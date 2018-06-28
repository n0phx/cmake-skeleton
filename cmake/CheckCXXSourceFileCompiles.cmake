# Attempts compiling the passed in source filename and returns the result
#
# Usage:
#   include(CheckCXXSourceFileCompiles)
#   check_cxx_source_file_compiles(filename.cpp COMPILE_SUCCEEDED)
#   if(NOT COMPILE_SUCCEEDED)
#       message(FATAL_ERROR "Compilation failed.")
#   endif()
#
# Module dependencies:
#   CheckCXXSourceCompiles

include(CheckCXXSourceCompiles)

function(check_cxx_source_file_compiles filename var)
    file(READ ${filename} cxx_source_to_check)
    if(cxx_source_to_check)
        check_cxx_source_compiles("${cxx_source_to_check}" ${var} ${ARGN})
        set(${var} ${${var}} PARENT_SCOPE)
    else()
        message(FATAL_ERROR "Source file is empty")
    endif()
endfunction()

