# NOTE: Unlike all other CMakeLists.txt in the apps/ folder, this
# is deliberately intended to be standalone (not included from the toplevel)
# in order to show the minimum scaffolding necessary to use ahead-of-time
# Generators in a simple app.
#
# To use:
# $ mkdir build
# $ cd build
# $ cmake -DCMAKE_PREFIX_PATH=<path/to/Halide> -DCMAKE_BUILD_TYPE=Release ..
# $ cmake --build . -j 4
# $ ./bin/wavelet ../../images/gray.png .

project(wavelet)
cmake_minimum_required(VERSION 3.14)

# Set up language settings
set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED YES)
set(CMAKE_CXX_EXTENSIONS NO)

# Find Halide
find_package(Halide REQUIRED COMPONENTS JPEG PNG)

# Define the wavelet app
add_executable(wavelet wavelet.cpp)
target_link_libraries(wavelet PRIVATE Halide::Halide Halide::ImageIO)

# Define a halide library for each generator we have, and link each one into wavelet
foreach (GEN IN ITEMS daubechies_x inverse_daubechies_x haar_x inverse_haar_x)
    add_executable("${GEN}.generator" "${GEN}_generator.cpp" daubechies_constants.h)
    target_link_libraries("${GEN}.generator" PRIVATE Halide::Generator)

    add_halide_library("${GEN}" FROM "${GEN}.generator")
    target_link_libraries(wavelet PRIVATE "${GEN}")
endforeach ()