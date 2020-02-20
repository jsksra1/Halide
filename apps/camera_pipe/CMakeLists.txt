cmake_minimum_required(VERSION 3.14)
project(camera_pipe)

enable_testing()

# Set up language settings
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS NO)

# Find Halide
find_package(Halide REQUIRED)

# Generator executable
add_executable(camera_pipe.generator camera_pipe_generator.cpp)
target_link_libraries(camera_pipe.generator
                      PRIVATE
                      Halide::Generator
                      Halide::Tools)

# Libraries
add_halide_library(camera_pipe FROM camera_pipe.generator)
add_halide_library(camera_pipe_auto_schedule FROM camera_pipe.generator
                   GENERATOR camera_pipe
                   PARAMS auto_schedule=true)

# Main executable
add_executable(camera_pipe_process process.cpp)
target_link_libraries(camera_pipe_process
                      PRIVATE
                      Halide::Runtime
                      Halide::ImageIO
                      camera_pipe
                      camera_pipe_auto_schedule)