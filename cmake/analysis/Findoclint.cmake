# Find OCLint
#
# Module dependencies:
#   FindPackageHandleStandardArgs
#
# Cache Variables:
#   OCLINT_ROOT_DIR
#
# Non-cache variables for users of the module:
#   oclint_EXECUTABLE
#   oclint_FOUND
#   oclint_VERSION

file(TO_CMAKE_PATH "${OCLINT_ROOT_DIR}" OCLINT_ROOT_DIR)
set(OCLINT_ROOT_DIR
    "${OCLINT_ROOT_DIR}"
    CACHE
    PATH
    "Path to directory containing oclint executable")

if(OCLINT_ROOT_DIR)
    find_program(oclint_EXECUTABLE
        NAMES oclint-json-compilation-database
        PATHS "${OCLINT_ROOT_DIR}"
        NO_DEFAULT_PATH
        DOC "Path to oclint executable")
else()
    find_program(oclint_EXECUTABLE
        NAMES oclint-json-compilation-database
        DOC "Path to oclint executable")
endif()

mark_as_advanced(oclint_EXECUTABLE oclint_FOUND oclint_VERSION)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(oclint
    FOUND_VAR oclint_FOUND
    REQUIRED_VARS oclint_EXECUTABLE
    VERSION_VAR oclint_VERSION)

