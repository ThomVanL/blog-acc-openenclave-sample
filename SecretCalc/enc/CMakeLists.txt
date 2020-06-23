# Copyright (c) Open Enclave SDK contributors.
# Licensed under the MIT License.

include(../cmake/add-enclave.cmake)

add_custom_command(
  OUTPUT
    SecretCalc_t.h
    SecretCalc_t.c
    SecretCalc_args.h
  DEPENDS ${CMAKE_SOURCE_DIR}/SecretCalc.edl
  COMMAND openenclave::oeedger8r --trusted ${CMAKE_SOURCE_DIR}/SecretCalc.edl)

add_enclave(
  TARGET SecretCalc_enclave
  UUID 62da2184-18bb-4b45-a3f7-ea69e96b1603
  SOURCES
    enc.c
    ${CMAKE_CURRENT_BINARY_DIR}/SecretCalc_t.c)
