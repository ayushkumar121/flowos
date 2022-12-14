#pragma once

typedef signed char                int8_t;
typedef short int                  int16_t;
typedef int                        int32_t;
typedef long int                   int64_t;

typedef unsigned char              uint8_t;
typedef unsigned short int         uint16_t;
typedef unsigned int               uint32_t;
typedef unsigned long int          uint64_t;

typedef unsigned long int          size_t;

typedef int bool;

typedef enum
{
    false,
    true
} Bool;

#define NULL (void *)0