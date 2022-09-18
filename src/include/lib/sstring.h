#pragma once

#include <stdarg.h>
#include <lib/types.h>
#define MAX_SSTRING 64

typedef struct 
{
    char data[MAX_SSTRING];
} SString;


size_t ss_len(SString a);
SString ss_from_cstr(const char *a);
SString ss_cat(SString a, SString b);

SString ss_vprintf(const char *fmt, va_list args);
__attribute__((format(printf, 1, 2))) SString ss_printf(const char *fmt, ...);
