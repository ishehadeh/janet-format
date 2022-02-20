// extensions to the janet int core module, necessary for formatting decimals
#include <janet.h>

// (int-ext/unwrap-u64 num)
static Janet cfun_unwrap_u64(int32_t argc, Janet *argv) {
    janet_fixarity(argc, 1);

    int64_t x = janet_unwrap_u64(argv[0]);
    if (x > INT32_MAX) {
        janet_panicf("cannot convert %q to an int32, exceededs int32 max", argv[0]);
    }

    return janet_wrap_integer(x);
}


static const JanetReg cfuns[] = {
    {"unwrap-u64", cfun_unwrap_u64, "(int-ext/unwrap-u64 num)\n\nConvert an int/u64 value to a number"},
    {NULL, NULL, NULL}
};

JANET_MODULE_ENTRY(JanetTable *env) {
    janet_cfuns(env, "int-ext", cfuns);
}