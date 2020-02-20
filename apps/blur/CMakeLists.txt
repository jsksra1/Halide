cmake_minimum_required(VERSION 3.14)
project(blur)

enable_testing()

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS NO)

find_package(Halide REQUIRED)

add_executable(blur.generator halide_blur_generator.cpp)
target_link_libraries(blur.generator PRIVATE Halide::Generator)

add_halide_library(halide_blur FROM blur.generator)

find_package(OpenMP)

add_executable(blur_test test.cpp)
target_link_libraries(blur_test
                      PRIVATE
                      Halide::Runtime
                      Halide::Tools
                      halide_blur
                      $<TARGET_NAME_IF_EXISTS:OpenMP::OpenMP_CXX>)
target_compile_options(blur_test
                       PRIVATE
                       $<$<CXX_COMPILER_ID:GNU,Clang,AppleClang>:-O2>)

add_test(NAME blur
         COMMAND blur_test)