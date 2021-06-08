---
title: "Linux Kernel Development: CONFIG KASAN"
date: 2021-05-31T11:21:00+05:30
draft: true
---

# Introduction

I recently got selected as a mentee for the linux kernel bug fixing program. The
first task for the program asks us to write a writeup on a few things about the
kernel development. Hence, there will be a series of posts for these writeups.

# Notes

- Dynamic memory safety error detector -> finds out of bounds and use after free
  bugs.
- Three types:
  * Generic
  * software tag-based 
  * hardware tag-based 
- Shadow memory stores information about 8 bytes of actual memory. Various codes
  signify if the adress is available, freed or is causing an overflow.

## Generic (`CONFIG_KASAN_GENERIC`)

- Used for debugging, large memory head.
- Similar to userspace ASAN.
- Use compile time instrumentation.
- Shadow memory
- static inline function calls inserted during compile time.

## Software tag-based KASAN (`CONFIG_KASAN_SW_TAGS`)

- Uses software memory tagging. Only implemented for arm64.
- Top Byte Ignore. Compile time construct check tags in lower 4 bits of the top
  byte.

## Hardware tag-based KASAN (`CONFIG_KASAN_HW_TAGS`)

- Only in arm64.
- To Byte Ignored. Lower 4 bits for tags.
- Hardware checks the tags and generates faults.
- Only reports the first found bug.
