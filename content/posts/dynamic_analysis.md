---
title: "Code analysis"
date: 2021-06-06T13:43:09+05:30
tags: 
  - linux
  - debugging
draft: false
---

Let's start with code debugging, we all know what code debugging is. We write
some code, and then we check for errors (or bugs) in the code and try to fix
them or remove them. We want to find and fix these bugs as early in the
development process as posssible, because of a well known principle that states
that fixing bugs later in the stages of development/release costs more than what
it would in the earlier stages. (For eg, IBM estimates the cost of fix
during testing is rougly 2.5x more than fixing bugs during implementation.)
And leaving bugs around in your code can lead to lots of troubles. Crashing
applications, corrupting user data, lots of security issues, etc. are all
outcomes of these bugs.

So now that we've established that debugging is important, and that it is more
efficient to fix bugs as early as possible, it's important to know how can we
accomplish this. As I said, debugging is the process of _finding_ and fixing
bugs. It all starts with identifying these bugs when we write our code, and
trying to fix them before they hit the next stages of development. Although it
sounds simple, finding bugs might not be an easy task, and this is were code
analysis tools come in.

## Code analysis tools

Code analysis tools are tools that help you by finding bugs in your code. They
report anything that they _think_ could be a bug, and it's later the job of the
programmer to fix them. Emphasis on the word think as these tools aren't 100%
accurate. They could report a perfectly fine line of code as a bug (false
positives), or could miss reporting an actual bug (false negatives).

So now we have two ends of a spectrum for tools, on one end of the spectrum, we
have a tool that doesn't miss any bugs, but ends up reporting a lot of false
positives, (eg, a tool that reports every line of code as a potiential bug,) and
on the other end of the spectrum, we have tools that won't report any false
positives, but they will also miss every bug in the code (eg, a tool that does
nothing, reports nothing regardless of whatever the input is).

We generally have to choose for a tool that lies in between those two extremes.
Some tools prefer false negatives over false positives, and some are the other
way around.

We can also classify these tools on the basis of when/how they perform these
error checks. Some tools do this before the runtime, (static code analysis,) and
some do it during runtime (dynamic code analysis). What follows is a breif
introduction of what these tools are and what can/can't they do.

## Static code analysis

Static code analysis tools try to find errors in the source code of a program.
Hence, the errors that they report are true for all the executions of a give
program, as opposed to dynamic code analysis tools (which we will discuss
later.) They can be helpful for finding simple bugs like:

```
  char buf[10];
  buf[20] = '\0';
```

The above code would result in memory corruption everytime it is executed, as we
are trying to access an out of bounds memory address. A static code analysis
tool can easily catch and report this bug during code compilation and raise an
exception/error. But what do we do about something like:

```
  char buf[len];
  buf[idx] = '\0';
```

We can't say for certain if this is an error. Static code analysis might help if
these variables were set to or calculated from constants. But what if they were
derived from user inputs? In that case, we'd have to know the values of these
variables to know if this is an out of bounds memory access. This is where
dynamic code analysis tools help.

## Dynamic code analysis

Dynamic code analysis tools test the code during the runtime of a program, and
report any errors that they find. They mostly use compiler instrumentation, but
could also be supplimented by software memory tagging, or instead use hardware
memory tagging. (More on this in an upcoming post.)

Since they report errors during the runtime, they can only prove errors for a
single execution of the program, as opposed to static code analysis tools. Also
these tools prefer false negatives over false positives, and hence, they could
miss an actual bug in the code if the current execution of the program doesn't
trigger it. What this also implies is that to find as many bugs as possible, we
should make test cases with different inputs for a program and try to run them
with these tools.

## Dynamic code analysis in the Linux Kernel

Linux kernel uses a lot of code dynamic code analysis tools. They can be enabled
by compiling the kernel with various config options. Some of these tools are
KASAN, KMSAN, KCSAN and LOCKDEP. You can find out about these tools by looking
at the config file for your kernel, (usually in the /boot directory,) and then
searching for the various config options that you find in there.

I will further discuss about KASAN, or Kernel Address SANitizator, in an
upcoming blogpost.
