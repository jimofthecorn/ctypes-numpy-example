cmake_minimum_required(VERSION 3.8 FATAL_ERROR)
project(cppref LANGUAGES CXX)

set(CMAKE_POSITION_INDEPENDENT_CODE ON)

add_library(cppref STATIC
    functions.cpp
    functions.h
    interface.cpp
)
