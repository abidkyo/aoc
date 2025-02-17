/*------------------------------------------------------------------------------
 * @file day04.c
 *
 * @brief AOC 2015 Day 04: MD5 Hash
 *
 *----------------------------------------------------------------------------*/


#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include <string.h>

#include <openssl/evp.h>


#define MAX_DIGIT (1 << 24)
#define LEN_DIGIT (16)


/*----------------------------------------------------------------------------*/


static void md5_compute(char* buf, size_t bufsize, uint8_t* md5_values) {
    uint32_t md5_len = 0;

    // MD5_Init
    EVP_MD_CTX* mdctx = EVP_MD_CTX_new();
    EVP_DigestInit_ex(mdctx, EVP_md5(), NULL);

    // MD5_Update
    EVP_DigestUpdate(mdctx, buf, bufsize);

    // MD5_Final
    EVP_DigestFinal_ex(mdctx, md5_values, &md5_len);
    EVP_MD_CTX_free(mdctx);
}


int main(int argc, char* argv[]) {
    char* secret = argv[1];
    size_t secret_len = strlen(secret);

    char* chars = malloc(sizeof(char[secret_len + LEN_DIGIT]));
    assert(chars != NULL);

    uint32_t p1 = 0, p2 = 0;
    uint8_t md5_values[EVP_MAX_MD_SIZE] = {0};

    for (uint32_t i = 0; i < MAX_DIGIT; i++) {
        int len = snprintf(chars, secret_len + LEN_DIGIT, "%s%u", secret, i);
        assert(len > 0);

        md5_compute(chars, len, md5_values);

        if ((p1 == 0) &&
            (md5_values[0] == 0) &&
            (md5_values[1] == 0) &&
            (md5_values[2] < 16)) {
            p1 = i;
        }

        if ((p2 == 0) &&
            (md5_values[0] == 0) &&
            (md5_values[1] == 0) &&
            (md5_values[2] == 0)) {
            p2 = i;
        }

        if ((p1 != 0) && (p2 != 0)) {
            break;
        }
    }
    free(chars);

    printf("p1 = %u, p2 = %u", p1, p2);
    assert(p1 == 346386);
    assert(p2 == 9958218);

    return 0;
}


/*----------------------------------------------------------------------------*/
