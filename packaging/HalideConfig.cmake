set(known_components PNG JPEG)

if (${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS)
    set(comps ${${CMAKE_FIND_PACKAGE_NAME}_FIND_COMPONENTS})
else ()
    set(comps ${known_components})
endif ()

include("${CMAKE_CURRENT_LIST_DIR}/Halide-Targets.cmake")
include("${CMAKE_CURRENT_LIST_DIR}/HalideGeneratorHelpers.cmake")

include(CMakeFindDependencyMacro)
find_dependency(Threads)

foreach (comp IN LISTS ${CMAKE_FIND_PACKAGE_NAME}_comps)
    if (NOT ${comp} IN_LIST known_components)
        set(${CMAKE_FIND_PACKAGE_NAME}_NOT_FOUND_MESSAGE
            "Halide does not recognize requested component: ${comp}")
        set(${CMAKE_FIND_PACKAGE_NAME}_FOUND FALSE)
        return()
    endif ()

    if (NOT TARGET ${comp}::${comp})
        unset(extraArgs)
        if (${CMAKE_FIND_PACKAGE_NAME}_FIND_QUIETLY)
            list(APPEND extraArgs QUIET)
        endif ()
        if (${CMAKE_FIND_PACKAGE_NAME}_FIND_REQUIRED_${comp})
            list(APPEND extraArgs REQUIRED)
        endif ()
        find_package(${comp} ${extraArgs})
    endif ()
endforeach ()