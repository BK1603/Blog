---
title: "Memory Leaks"
date: 2020-05-01T17:09:20+05:30
draft: true
tags:
  - neovim
  - gsoc
  - bugs
---

Memory leaks, I guess we all have faced them, and the amount of
effort required in fixing them could range from "Oh! Silly me"
to "God I hate my job." Here's a brief description of what
they are, followed by an account of my brawl with one that
I encountered while working on a PR for Neovim.

## What are memory leaks and how to fix them?
You're happily doing your job, programming away in C, working
on a cool new feature. You didn't forget creating a new branch,
just cleared up the commit history, and made sure that all the
tests run locally. You didn't forget running the linter this time
around, and fixing the single line that it said needs to be fixed.
After you've seen all the tests running succesfully, you give
a sigh of releif, and finally decide pushing these commits to
the branch that you were working on, feeling relaxed that it's
finaly done. You come back to check in on the CI tests after
an hour, and are welcomed by... a bunch of failing tests. You
open the logs, scroll down and there you find it. You've
created a memory leak. Welcome to the club my friend.

Memory leaks are, well, memory leaks. So how do we leak memory?
It mostly happens when we allocate some memory on the heap, use
it and then forget freeing it. The memory thus allocated is
"leaked", as in it's no more referred to by anything, hence can't
be used anymore, and isn't exactly marked free either. And even
though most modern operating systems are smart enough to free
such "leaked" memory, it still can cause a lot of harm to a
user's operating system if left unchecked. It would all depend
upon where exactly was the memory leaked. At the very least,
another program could try and read this leaked memory and cause
a security breach. So I'd suggest that we try and fix them as soon as
we encounter one.

How do we fix them? Now that we know what exactly memory leaks are, I think we all
have an idea of how can it be fixed. Unless you're as dumb as I
am, in which case, it's fixed by what did you forget freeing in your
program, and then add a relevant free call for that object.

## How I fixed a memory leak on my PR from neovim

- start by looking at the log
  - found one at what function? ex_set->do_set
- what was the first question
- it wasn't freed
- why not earlier
