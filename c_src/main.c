#include <stdio.h>
#include "frand.h"

#define MAX 100

int
main(int argc, char **argv)
{
  long int seed;
  int i, number;
  int m, max = 1;

  if (argc < 3) {
  error:
    fprintf(stderr, "usage: %s <seed> <number> <max> [number > 0, max > 0 (default: 1)]\r\n", argv[0]);
    exit(EXIT_FAILURE);
  }

  seed = atol(argv[1]);
  number = atoi(argv[2]);
  if (number <= 0) goto error;

  if (argc == 4) {
    max = atoi(argv[3]);
    if (max <= 0) goto error;
  }

  /* fprintf(stderr, "Seed: %lu Number: %d Max: %d\r\n", seed, number, max); */
  for (m = 0; m < max; m++) {
    frand_seed(seed+m);
    printf("{%lu,[", seed+m);
    for (i = 0; i < number; )
      printf("%lu%s", frand_rand() % MAX, (++i < number ? "," : ""));
    printf("]}.\n");
  }

  exit(EXIT_SUCCESS);
}
