# Find FlintPlusPlus
#
# Module dependencies:
#   FindPackageHandleStandardArgs
#
# Cache Variables:
#   FLINT_ROOT_DIR
#
# Non-cache variables for users of the module:
#   flint_EXECUTABLE
#   flint_FOUND
#   flint_VERSION

file(TO_CMAKE_PATH "${FLINT_ROOT_DIR}" FLINT_ROOT_DIR)
set(FLINT_ROOT_DIR
    "${FLINT_ROOT_DIR}"
    CACHE
    PATH
    "Path to directory containing flint++ executable")

if(FLINT_ROOT_DIR)
    find_program(flint_EXECUTABLE
        NAMES flint++
        PATHS "${FLINT_ROOT_DIR}"
        NO_DEFAULT_PATH
        DOC "Path to flint++ executable")
else()
    find_program(flint_EXECUTABLE
        NAMES flint++
        DOC "Path to flint++ executable")
endif()

mark_as_advanced(flint_EXECUTABLE flint_FOUND flint_VERSION)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(flint
    FOUND_VAR flint_FOUND
    REQUIRED_VARS flint_EXECUTABLE
    VERSION_VAR flint_VERSION)

