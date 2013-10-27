#ifndef __FRAND_H
#define __FRAND_H

static struct drand48_data buffer;


static inline int
frand_seed(const long int s)
{
  return srand48_r(s, &buffer);
}


static inline long int
frand_rand()
{
  long int r;

  lrand48_r(&buffer, &r);

  return r;
}

#endif /* __FRAND_H */
