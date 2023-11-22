cmake_minimum_required(VERSION 3.5)

project(goldfish-sample)

#add_definitions("-march=native -ftree-vectorize -ffast-math -fsigned-char -fno-optimize-sibling-calls")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -Wall -Werror -std=c11 -Og -g")
set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Werror -std=c++11 -Og -g")

include(goldfish/dependencies.cmake)

# Add any additional include paths here
include_directories(
    include
    vendor/include
)

FILE(GLOB_RECURSE C_SOURCES src/*.c vendor/src/*.c)
FILE(GLOB_RECURSE CPP_SOURCES src/*.cpp vendor/src/*.cpp)

## Build and link
# Add all the files needed to compile here
add_executable(${PROJECT_NAME}
    ${CPP_ENGINE_SOURCES}
    ${C_ENGINE_SOURCES}

    ${CPP_SOURCES}
    ${C_SOURCES}
)

include(goldfish/linking.cmake)
