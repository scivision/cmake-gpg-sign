set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

find_package(GPG REQUIRED)

gpg_verify(${binary_file})
