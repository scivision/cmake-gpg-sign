# file: binary filename to sign filename.asc of

set(CMAKE_MODULE_PATH ${CMAKE_CURRENT_LIST_DIR})

find_package(GPG REQUIRED)

foreach(file IN LISTS CPACK_PACKAGE_FILES)
  gpg_sign(${file})
  file(COPY ${file}.asc DESTINATION ${CPACK_PACKAGE_DIRECTORY}/)
endforeach()
