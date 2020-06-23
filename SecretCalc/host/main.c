#include <errno.h>
#include <stdio.h>
#include <stdlib.h>

#include "host.h"

int main(int argc, const char *argv[])
{
    int result = create_enclave(argc, argv);
    if (result != 0)
    {
        fprintf(stderr, "Failed to create enclave with result = %i.\n", result);
        return result;
    }

    result = call_enclave_calc_sum(123, 456);
    if (result != 0)
    {
        fprintf(stderr, "Failed to call enclave with result = %i.\n", result);
        terminate_enclave();
        return result;
    }

    result = terminate_enclave();
    if (result != 0)
    {
        fprintf(
            stderr, "Failed to terminate enclave with result = %i.\n", result);
    }

    return result;
}
