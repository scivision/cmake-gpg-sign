cmake_minimum_required(VERSION 3.14...3.25)

project(PGPdemo LANGUAGES C)

enable_testing()

# --- auto-ignore build directory
if(NOT EXISTS ${PROJECT_BINARY_DIR}/.gitignore)
  file(WRITE ${PROJECT_BINARY_DIR}/.gitignore "*")
endif()

set(CMAKE_EXECUTE_PROCESS_COMMAND_ECHO STDOUT)

list(APPEND CMAKE_MODULE_PATH ${PROJECT_SOURCE_DIR}/cmake)

find_package(GPG REQUIRED)

# --- example executable to sign
add_executable(hello hello.c)

install(TARGETS hello)
install(FILES $<TARGET_FILE:hello>.asc TYPE BIN)

# --- GPG sign target
gpg_sign(hello)

# --- GPG verify target signature
add_test(NAME test_sign
COMMAND ${CMAKE_COMMAND} -Dfile:FILEPATH=$<TARGET_FILE:hello> -P ${CMAKE_CURRENT_SOURCE_DIR}/cmake/GPGverify.cmake
)
set_property(TEST test_sign PROPERTY TIMEOUT 10)
set_property(TEST test_sign PROPERTY PASS_REGULAR_EXPRESSION "gpg: Good signature")

include(cmake/cpacker.cmake)
