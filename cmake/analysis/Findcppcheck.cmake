# Find CppCheck
#
# Module dependencies:
#   FindPackageHandleStandardArgs
#
# Cache Variables:
#   CPPCHECK_ROOT_DIR
#
# Non-cache variables for users of the module:
#   cppcheck_EXECUTABLE
#   cppcheck_FOUND
#   cppcheck_VERSION

file(TO_CMAKE_PATH "${CPPCHECK_ROOT_DIR}" CPPCHECK_ROOT_DIR)
set(CPPCHECK_ROOT_DIR
    "${CPPCHECK_ROOT_DIR}"
    CACHE
    PATH
    "Path to directory containing cppcheck executable")

if(CPPCHECK_ROOT_DIR)
    find_program(cppcheck_EXECUTABLE
        NAMES cppcheck
        PATHS "${CPPCHECK_ROOT_DIR}"
        PATH_SUFFIXES cli
        NO_DEFAULT_PATH
        DOC "Path to cppcheck executable")
else()
    find_program(cppcheck_EXECUTABLE
        NAMES cppcheck
        DOC "Path to cppcheck executable")
endif()

mark_as_advanced(cppcheck_EXECUTABLE cppcheck_FOUND cppcheck_VERSION)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(cppcheck
    FOUND_VAR cppcheck_FOUND
    REQUIRED_VARS cppcheck_EXECUTABLE
    VERSION_VAR cppcheck_VERSION)

