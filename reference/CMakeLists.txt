cmake_minimum_required(VERSION 3.8 FATAL_ERROR)
project(cppref LANGUAGES CXX)

add_library(cppref STATIC
    functions.cpp
    functions.h
    interface.cpp
  )
