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

Provides function gpg_sign(target) to sign binary targets from
add_library or add_exectuable. The signature filename is like:
$<TARGET_FILE:target>.asc

Result Variables
^^^^^^^^^^^^^^^^

``GPG_FOUND``
  GPG binary was found

``GPG_EXECUTABLE``
  full path to GPG executable


#]=======================================================================]

find_program(GPG_EXECUTABLE
  NAMES gpg2 gpg
  DOC "GPG executable")


include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(GPG
  REQUIRED_VARS GPG_EXECUTABLE
)

if(GPG_FOUND)

function(gpg_sign target)

add_custom_command(TARGET ${target} POST_BUILD
  COMMAND ${GPG_EXECUTABLE} ARGS --detach-sig --armor $<TARGET_FILE:${target}>
  # BYPRODUCTS $<TARGET_FILE:${target}>.asc
)

install(TARGETS ${target} EXPORT ${PROJECT_NAME}Targets)
install(FILES $<TARGET_FILE:${target}>.asc TYPE BIN)

endfunction(gpg_sign)

endif()
