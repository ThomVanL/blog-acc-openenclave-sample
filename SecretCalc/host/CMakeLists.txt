#Copyright (c) Open Enclave SDK contributors.
# Licensed under the MIT License.

add_custom_command(
  OUTPUT
    SecretCalc_u.h
    SecretCalc_u.c
    SecretCalc_args.h
  DEPENDS ${CMAKE_SOURCE_DIR}/SecretCalc.edl
  COMMAND openenclave::oeedger8r --untrusted ${CMAKE_SOURCE_DIR}/SecretCalc.edl)

add_executable(SecretCalc
    host.c
    main.c
    ${CMAKE_CURRENT_BINARY_DIR}/SecretCalc_u.c)

target_include_directories(SecretCalc PRIVATE ${CMAKE_CURRENT_BINARY_DIR})

target_link_libraries(SecretCalc openenclave::oehost)
