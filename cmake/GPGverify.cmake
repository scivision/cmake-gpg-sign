cmake_minimum_required(VERSION 3.20...3.21)

function(gpg_verify binary_file)

find_program(gpg NAMES gpg2 gpg REQUIRED)

cmake_path(GET binary_file PARENT_PATH bp)
cmake_path(GET binary_file FILENAME bn)

find_file(sigfile
  NAMES ${bn}.asc ${bn}.sig
  HINTS ${bp}
  NO_DEFAULT_PATH
  REQUIRED)

execute_process(COMMAND ${gpg} --verify ${sigfile} ${binary_file}
  TIMEOUT 10
  COMMAND_ERROR_IS_FATAL ANY)

endfunction(gpg_verify)


if(CMAKE_SCRIPT_MODE_FILE)
  gpg_verify(${binary_file})
endif()
