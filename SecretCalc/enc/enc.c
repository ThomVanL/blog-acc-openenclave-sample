#include <stdio.h>
#include <malloc.h>
#include "SecretCalc_t.h"

int ecall_calc_sum(
    int numberA,
    int numberB)
{
    unsigned int enclave_msg_size = 512;
    char *enclaveMessage = (char *)malloc(enclave_msg_size * sizeof(char));
    int numberC = numberA + numberB;

    if (snprintf(
            enclaveMessage,
            enclave_msg_size,
            "{ \"sum\": %d }",
            numberC) < 0)
    {
        fprintf(stderr, "calculating sum failed\n");
        return 1;
    }

    int retval = 0;
    oe_result_t result = ocall_log(&retval, enclaveMessage);

    free(enclaveMessage);
    if (result != OE_OK)
    {
        fprintf(
            stderr,
            "Call to ecall_calc_sum failed: result=%u (%s)\n",
            result,
            oe_result_str(result));
        return 1;
    }

    return retval;
}

#define TA_UUID                                            \
    { /* 62da2184-18bb-4b45-a3f7-ea69e96b1603 */           \
        0x62da2184, 0x18bb, 0x4b45,                        \
        {                                                  \
            0xa3, 0xf7, 0xea, 0x69, 0xe9, 0x6b, 0x16, 0x03 \
        }                                                  \
    }

OE_SET_ENCLAVE_OPTEE(
    TA_UUID,
    1 * 1024 * 1024,
    12 * 1024,
    0,
    "1.0.0",
    "SecretCalc")

