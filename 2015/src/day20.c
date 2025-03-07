/*------------------------------------------------------------------------------
 * @file day20.c
 *
 * @brief AOC 2015 Day 20: Sum of Divisors
 *
 *----------------------------------------------------------------------------*/


#include <assert.h>
#include <stdio.h>
#include <stdint.h>
#include <stdlib.h>


/*----------------------------------------------------------------------------*/


int main(int argc, char* argv[]) {
    if (argc < 2) {
        printf("missing arg");
        return 1;
    }

    const uint32_t N = strtoul(argv[1], NULL, 10);
    const uint32_t M = N / 40;
    printf("N = %u, M = %u\n", N, M);

    uint32_t* b1 = malloc(sizeof(uint32_t[M]));
    uint32_t* b2 = malloc(sizeof(uint32_t[M]));

    for (uint32_t i = 1; i < M; i++) {
        uint32_t lim = i * 50 + i;
        if (M < lim) {
            lim = M;
        }

        for (uint32_t j = i; j < lim; j += i) {
            b1[j] += i * 10;
            b2[j] += i * 11;
        }
        for (uint32_t j = lim; j < M; j += i) {
            b1[j] += i * 10;
        }
    }

    uint32_t p1 = 0, p2 = 0;
    for (uint32_t i = 0; i < M; i++) {
        if ((p1 == 0) && (b1[i] >= N)) {
            p1 = i;
        }
        if ((p2 == 0) && (b2[i] >= N)) {
            p2 = i;
        }

        if ((p1 != 0) && (p2 != 0)) {
            break;
        }
    }

    printf("p1 = %u, p2 = %u\n", p1, p2);
    assert(p1 == 665280);
    assert(p2 == 705600);

    return 0;
}


/*----------------------------------------------------------------------------*/
