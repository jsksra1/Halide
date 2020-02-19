cmake_minimum_required(VERSION 3.14 FATAL_ERROR)

set(${CMAKE_FIND_PACKAGE_NAME}_known_components Halide PNG JPEG)

if (${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)
    set(${CMAKE_FIND_PACKAGE_NAME}_comps ${${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS})
else ()
    # Try to include all components optionally by default
    set(${CMAKE_FIND_PACKAGE_NAME}_comps ${known_components})
endif ()

# Allow people to specify explicitly that they only want Halide
list(REMOVE_ITEM ${CMAKE_FIND_PACKAGE_NAME}_comps Halide)

include("${CMAKE_CURRENT_LIST_DIR}/Halide-Targets.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/HalideGeneratorHelpers.cmake")

include(CMakeFindDependencyMacro)
find_dependency(Threads)

foreach (comp IN LISTS ${CMAKE_FIND_PACKAGE_NAME}_comps)
    if (NOT ${comp} IN_LIST ${CMAKE_FIND_PACKAGE_NAME}_known_components)
        set(${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE
            "Halide does not recognize requested component: ${comp}")
        set(${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
        return()
    endif ()

    # ${comp} is either PNG or JPEG, and this works for both packages
    if (NOT TARGET ${comp}::${comp})
        unset(extraArgs)
        if (${CMAKE_FIND_PACKAGE_NAME}_FIND_QUIETLY)
            list(APPEND extraArgs QUIET)
        endif ()
        if (${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_${comp})
            list(APPEND extraArgs REQUIRED)
        endif ()
        find_package(${comp} ${extraArgs})
        if (TARGET ${comp}::${comp})
            set_target_properties(${comp}::${comp} PROPERTIES IMPORTED_GLOBAL TRUE)
        endif ()
    endif ()
endforeach ()