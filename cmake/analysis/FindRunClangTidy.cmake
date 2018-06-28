# Find run-clang-tidy
#
# Module dependencies:
#   FindPackageHandleStandardArgs
#
# Cache Variables:
#   RUN_CLANG_TIDY_ROOT_DIR
#
# Non-cache variables for users of the module:
#   RunClangTidy_EXECUTABLE
#   RunClangTidy_FOUND
#   RunClangTidy_VERSION

file(TO_CMAKE_PATH "${RUN_CLANG_TIDY_ROOT_DIR}" RUN_CLANG_TIDY_ROOT_DIR)
set(RUN_CLANG_TIDY_ROOT_DIR
    "${RUN_CLANG_TIDY_ROOT_DIR}"
    CACHE
    PATH
    "Path to directory containing run-clang-tidy script")

if(RUN_CLANG_TIDY_ROOT_DIR)
    find_program(RunClangTidy_EXECUTABLE
        NAMES run-clang-tidy run-clang-tidy.py
        PATHS "${RUN_CLANG_TIDY_ROOT_DIR}"
        NO_DEFAULT_PATH
        DOC "Path to run-clang-tidy script")
else()
    find_program(RunClangTidy_EXECUTABLE
        NAMES run-clang-tidy run-clang-tidy.py
        DOC "Path to run-clang-tidy script")
endif()

mark_as_advanced(RunClangTidy_EXECUTABLE RunClangTidy_FOUND RunClangTidy_VERSION)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(RunClangTidy
    FOUND_VAR RunClangTidy_FOUND
    REQUIRED_VARS RunClangTidy_EXECUTABLE
    VERSION_VAR RunClangTidy_VERSION)

