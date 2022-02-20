#include <janet.h>
#include "dragonbox.h"

static Janet cfun_to_decimal(int32_t argc, Janet* argv) {
    janet_fixarity(argc, 1);

    double number = janet_getnumber(argv, 0);

    using namespace jkj::dragonbox::policy;
    auto parts = jkj::dragonbox::to_decimal(number, sign::ignore, trailing_zero::remove, decimal_to_binary_rounding::nearest_to_even, binary_to_decimal_rounding::to_even, cache::full);

    Janet* tuple = janet_tuple_begin(2);
    tuple[0] = janet_wrap_u64(parts.significand);
    tuple[1] = janet_wrap_integer(parts.exponent);
    return janet_wrap_tuple(janet_tuple_end(tuple));
}

static const JanetReg cfuns[] = {
    {"to-decimal", cfun_to_decimal, "(dragonbox/to-decimal num)\n\nconverts the floating-point number into a decimal number. Returns a two-element tuple [signficand exponent]."},
    {NULL, NULL, NULL}
};

JANET_MODULE_ENTRY(JanetTable *env) {
    janet_cfuns(env, "dragonbox", cfuns);
}