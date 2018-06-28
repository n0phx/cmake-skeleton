# Orchestrates the creation of all possible linter targets and additionally
# creates wrapper targets that can trigger the execution of all linters
#
# Usage:
#   include(Analysis)
#   set(target_ignore_list "/path/to/ignore" "/other/path/to/ignore")
#   analyse_targets("${target_ignore_list}" target1 target2 ...)
#
# Module dependencies:
#   ClangTidy.cmake
#   CppCheck.cmake
#   FlintPlusPlus.cmake
#   OCLint.cmake

include(ClangTidy)
include(CppCheck)
include(FlintPlusPlus)
include(OCLint)

function(_analyse_target target_name target_ignore_list parent_target_name)
    # Attempt adding analyzers
    clangtidy_targets(${target_name})
    cppcheck_targets("${target_ignore_list}" ${target_name})
    flint_targets(${target_name})
    oclint_targets("${target_ignore_list}" ${target_name})
    # Add as dependencies only the successfully integrated analyzers
    foreach(analyzer IN ITEMS "${target_name}-clangtidy"
                              "${target_name}-cppcheck"
                              "${target_name}-flint"
                              "${target_name}-oclint")
        if(TARGET ${analyzer})
            add_dependencies(${parent_target_name} ${analyzer})
        else()
            message("${analyzer} was not added.")
        endif()
    endforeach()
endfunction()

function(analyse_targets common_ignore_list)
    set(wrapper_target_name analysis)
    set(label_name "static-analysis")

    add_custom_target(${wrapper_target_name})
    set_property(TARGET ${wrapper_target_name}
        PROPERTY FOLDER ${label_name})

    foreach(target_name IN LISTS ARGN)
        set(target_ignore_list ${common_ignore_list})
        # Get all target source folders except for the target that is
        # currently being processed
        foreach(other_target_name IN LISTS ARGN)
            if(NOT other_target_name STREQUAL target_name)
                list(APPEND target_ignore_list "$<TARGET_PROPERTY:${other_target_name},SOURCE_DIR>")
            endif()
        endforeach()

        set(analysis_target_name "${target_name}-${wrapper_target_name}")
        add_custom_target(${analysis_target_name})
        set_property(TARGET ${analysis_target_name}
            PROPERTY FOLDER ${label_name})

        _analyse_target(${target_name} "${target_ignore_list}" ${analysis_target_name})
        add_dependencies(${wrapper_target_name} ${analysis_target_name})
    endforeach()
endfunction()

