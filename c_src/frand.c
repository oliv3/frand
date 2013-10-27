#include <stdio.h>
#include <assert.h>
#include "erl_nif.h"
#include "frand.h"


static ERL_NIF_TERM
frand_nif_lrand48(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
  long int ret;

  ret = frand_rand();

  return enif_make_long(env, ret);
}


static ERL_NIF_TERM
frand_nif_srand48(ErlNifEnv* env, int argc, const ERL_NIF_TERM argv[])
{
  long int s;
  int ret;

  if (!enif_get_long(env, argv[0], &s))
    return enif_make_badarg(env);

  ret = frand_seed(s);

  return enif_make_int(env, ret);
}


/* NIF API */
static ErlNifFunc nif_funcs[] = {
  {"lrand48", 0, frand_nif_lrand48},
  {"srand48", 1, frand_nif_srand48}
};


static int
frand_upgrade(ErlNifEnv* env, void** priv_data, void** old_priv_data, ERL_NIF_TERM load_info)
{
  return 0;
}

ERL_NIF_INIT(frand,
	     nif_funcs,
	     NULL,          /* load */
	     NULL,          /* reload */
	     frand_upgrade, /* upgrade */
	     NULL           /* unload */
	     )
