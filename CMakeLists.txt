cmake_minimum_required(VERSION 3.19...3.21)

project(PGPdemo LANGUAGES C)

enable_testing()

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake/Modules)

find_package(GPG REQUIRED)

add_executable(hello hello.c)

gpg_sign(hello)

add_test(NAME test_sign
  COMMAND ${CMAKE_COMMAND} -Dbinary_file:FILEPATH=$<TARGET_FILE:hello> -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/GPGverify.cmake)