---
title: "Kernel Debugging"
date: 2021-06-07T00:11:23+05:30
draft: true
---

## Basic idea behind debugging an oops

The basic idea behind debugging an remains the same:
* Use the stack trace to find out which function caused the crash.
* Use the offset from the stack trace to find the address for the instruction in the function that caused the crash.
* Investigate the instruction by using a disassembler or a debugger.
* Upon finding the instruction, find out what caused the bug.
* Find the C code corresponding to the faulty instruction.
* Fix the code.
