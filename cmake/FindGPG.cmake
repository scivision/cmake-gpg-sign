# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:

FindGPG
---------

by Michael Hirsch www.scivision.dev

Finds GPG library, typically used to sign files.
We don't check that GPG signature is available as that may require
interactive terminal, which is not possible at CMake configure time
with execute_process().

Provides functions:

* gpg_sign(target) to sign binary targets from add_library or add_exectuable.
  The signature filename is like: $<TARGET_FILE:target>.asc
* gpg_verify(binary_file) to verify binary file GPG signature.

Result Variables
^^^^^^^^^^^^^^^^

``GPG_FOUND``
  GPG binary was found

``GPG_EXECUTABLE``
  full path to GPG executable


#]=======================================================================]

find_program(GPG_EXECUTABLE
NAMES gpg2 gpg
DOC "GPG executable"
)


include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GPG
REQUIRED_VARS GPG_EXECUTABLE
)

function(gpg_sign target)

if(CMAKE_VERSION VERSION_LESS 3.17)
  set(rm "remove")
else()
  set(rm "rm")
endif()

if(TARGET ${target})
  set(target_file $<TARGET_FILE:${target}>)
elseif(EXISTS ${target})
  set(target_file ${target})
else()
  message(FATAL_ERROR "Target ${target} not found")
endif()

set(target_sig ${target_file}.asc)

if(TARGET ${target})
  add_custom_command(TARGET ${target} POST_BUILD
  COMMAND ${CMAKE_COMMAND} -E ${rm} ${target_sig}
  COMMAND ${GPG_EXECUTABLE} --detach-sign --armor ${target_file}
  VERBATIM
  )
else()
  file(REMOVE ${target_sig})

  execute_process(COMMAND ${GPG_EXECUTABLE} --detach-sign --armor ${target_file}
  RESULT_VARIABLE ret)
  if(NOT ret EQUAL 0)
    message(FATAL_ERROR "${GPG_EXECUTABLE} Failed to sign ${target_file}")
  endif()
endif()

install(FILES ${target_sig} TYPE BIN)

endfunction(gpg_sign)


function(gpg_verify binary_file)

get_filename_component(binary_file ${binary_file} ABSOLUTE)
if(NOT EXISTS ${binary_file})
  message(FATAL_ERROR "File ${binary_file} does not exist")
endif()

get_filename_component(bp ${binary_file} DIRECTORY)
get_filename_component(bn ${binary_file} NAME)

find_file(sigfile
NAMES ${bn}.asc ${bn}.sig
HINTS ${bp}
NO_DEFAULT_PATH
)
if(NOT sigfile)
  message(FATAL_ERROR "could not find signature file in ${bp}")
endif()

execute_process(COMMAND ${GPG_EXECUTABLE} --verify ${sigfile} ${binary_file}
RESULT_VARIABLE ret
)
if(NOT ret EQUAL 0)
  message(FATAL_ERROR "Failed to GPG verify ${binary_file} with ${GPG_EXECUTABLE}")
endif()

endfunction(gpg_verify)
