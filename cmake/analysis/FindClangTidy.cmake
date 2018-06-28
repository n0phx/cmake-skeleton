# Find clang-tidy
#
# Module dependencies:
#   FindPackageHandleStandardArgs
#
# Cache Variables:
#   CLANG_TIDY_ROOT_DIR
#
# Non-cache variables for users of the module:
#   ClangTidy_EXECUTABLE
#   ClangTidy_FOUND
#   ClangTidy_VERSION

file(TO_CMAKE_PATH "${CLANG_TIDY_ROOT_DIR}" CLANG_TIDY_ROOT_DIR)
set(CLANG_TIDY_ROOT_DIR
    "${CLANG_TIDY_ROOT_DIR}"
    CACHE
    PATH
    "Path to directory containing clang-tidy executable")

if(CLANG_TIDY_ROOT_DIR)
    find_program(ClangTidy_EXECUTABLE
        NAMES clang-tidy
        PATHS "${CLANG_TIDY_ROOT_DIR}"
        NO_DEFAULT_PATH
        DOC "Path to clang-tidy executable")
else()
    find_program(ClangTidy_EXECUTABLE
        NAMES clang-tidy
        DOC "Path to clang-tidy executable")
endif()

mark_as_advanced(ClangTidy_EXECUTABLE ClangTidy_FOUND ClangTidy_VERSION)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(ClangTidy
    FOUND_VAR ClangTidy_FOUND
    REQUIRED_VARS ClangTidy_EXECUTABLE
    VERSION_VAR ClangTidy_VERSION)

