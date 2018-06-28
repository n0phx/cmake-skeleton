# Enable sanitizers
#
# Usage:
#   include(EnableSanitizers)
#   sanitize_targets(target1 target2 ...)
#
# Then invoke CMake with the list of needed sanitizers:
#   -DENABLE_SANITIZERS='address;leak;undefined'
#
# The list of supported sanitizers are:
# - address
# - memory
# - thread
# - leak
# - undefined
#
# among which "address", "memory" and "thread" are mutually exclusive and cannot
# be used at the same time. "leak" requires the "address" sanitizer.
#
# Since the sanitizers carry a significant performance overhead, it is
# recommended to use the `-O1` optimization whenever using them.

function(check_compiler_version gcc_min_version clang_min_version)
    set(compiler_ver "${CMAKE_CXX_COMPILER_ID} v${CMAKE_CXX_COMPILER_VERSION}")

    if(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
        if(NOT gcc_min_version)
            message(FATAL_ERROR
                "${compiler_ver} detected, which doesn't support the \
                ${sanitizer} sanitizer.")
        elseif(CMAKE_CXX_COMPILER_VERSION VERSION_LESS ${gcc_min_version})
            message(FATAL_ERROR
                "${compiler_ver} detected, but the ${sanitizer} sanitizer is \
                supported since v${gcc_min_version} only.")
        endif()
    endif()

    if(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        if(NOT clang_min_version)
            message(FATAL_ERROR
                "${compiler_ver} detected, which doesn't support the \
                ${sanitizer} sanitizer.")
        elseif(CMAKE_CXX_COMPILER_VERSION VERSION_LESS ${clang_min_version})
            message(FATAL_ERROR
                "${compiler_ver} detected, but the ${sanitizer} sanitizer is \
                supported since v${clang_min_version} only.")
        endif()
    endif()
endfunction()

function(enable_sanitizer_flags sanitize_option compile_flags_var link_flags_var)
    if(${sanitize_option} MATCHES "address")
        check_compiler_version("4.8" "3.1")
        set(${compile_flags_var}
            "-fsanitize=address -fno-omit-frame-pointer -fno-optimize-sibling-calls"
            PARENT_SCOPE)
        set(${link_flags_var} "-fsanitize=address" PARENT_SCOPE)
    elseif(${sanitize_option} MATCHES "thread")
        check_compiler_version("4.8" "3.1")
        set(${compile_flags_var} "-fsanitize=thread" PARENT_SCOPE)
        set(${link_flags_var} "-fsanitize=thread" PARENT_SCOPE)
    elseif(${sanitize_option} MATCHES "memory")
        check_compiler_version("" "3.1")
        set(${compile_flags_var} "-fsanitize=memory" PARENT_SCOPE)
        set(${link_flags_var} "-fsanitize=memory" PARENT_SCOPE)
    elseif(${sanitize_option} MATCHES "leak")
        check_compiler_version("4.9" "3.4")
        set(${compile_flags_var} "-fsanitize=leak" PARENT_SCOPE)
        set(${link_flags_var} "-fsanitize=leak" PARENT_SCOPE)
    elseif(${sanitize_option} MATCHES "undefined")
        check_compiler_version("4.9" "3.1")
        set(${compile_flags_var}
            "-fsanitize=undefined -fno-omit-frame-pointer -fno-optimize-sibling-calls"
            PARENT_SCOPE)
        set(${link_flags_var} "-fsanitize=undefined" PARENT_SCOPE)
    else()
        message(FATAL_ERROR "Compiler sanitizer option `${sanitize_option}` not supported.")
    endif()
endfunction()

function(_sanitize_target target_name)
    foreach(sanitizer IN LISTS ENABLE_SANITIZERS)
        string(TOLOWER ${sanitizer} sanitizer)
        enable_sanitizer_flags(${sanitizer} san_compile_flags san_link_flags)
        set_property(TARGET ${target_name} APPEND_STRING
            PROPERTY COMPILE_FLAGS " ${san_compile_flags}")
        set_property(TARGET ${target_name} APPEND_STRING
            PROPERTY LINK_FLAGS " ${san_link_flags}")
    endforeach()
endfunction()

function(sanitize_targets)
    if(NOT ENABLE_SANITIZERS)
        return()
    endif()

    if(NOT CMAKE_CXX_COMPILER_ID MATCHES "GNU" AND NOT CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        message(STATUS "Compiler (${CMAKE_CXX_COMPILER_ID}) does not have sanitizer support.")
        return()
    endif()

    foreach(target_name IN LISTS ARGN)
        _sanitize_target(${target_name})
    endforeach()
endfunction()

