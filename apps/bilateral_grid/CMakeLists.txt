cmake_minimum_required(VERSION 3.14)
project(bilateral_grid)

enable_testing()

# Set up language settings
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS NO)

# Find Halide
find_package(Halide REQUIRED)

add_executable(bilateral_grid_process filter.cpp)
target_link_libraries(bilateral_grid_process
                      PRIVATE
                      Halide::ImageIO # For halide_image_io.h
                      Halide::Tools # For halide_benchmark.h
                      Halide::Runtime # For HalideBuffer.h  -- TODO: This should probably be part of ::Tools
                      )

add_executable(bilateral_grid.generator bilateral_grid_generator.cpp)
target_link_libraries(bilateral_grid.generator PRIVATE Halide::Generator Halide::Tools)

add_halide_library(bilateral_grid FROM bilateral_grid.generator
                   EXTRA_OUTPUTS stmt schedule)

add_halide_library(bilateral_grid_auto_schedule FROM bilateral_grid.generator
                   GENERATOR bilateral_grid
                   EXTRA_OUTPUTS stmt schedule
                   PARAMS auto_schedule=true
                   USE_RUNTIME bilateral_grid.runtime)

target_link_libraries(bilateral_grid_process
                      PRIVATE
                      bilateral_grid
                      bilateral_grid_auto_schedule)
