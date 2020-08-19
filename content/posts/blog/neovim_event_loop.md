---
title: "Google Summer Of Code with Neovim"
date: 2020-08-17T13:07:35+05:30
draft: true
toc: false
images:
tags:
  - gsoc
  - neovim
---

- intro
- project
- problem
- solution
- what did I work with/what is this doc for
- topics that I will discuss

If you guys use Neovim, there is something you might have noticed. Let's say you opened a file to edit it in the
editor, you're all happily editing super productively, (as you should with vim I guess? :P,) and then as soon as
you hit `:w`, you're greeted with a warning that looks like this:

```
WARNING: The file has been changed since reading it!!!
Do you really want to write to it (y/n)?
```

If only you could compare the changes that happened, and choose what you wanted to keep and what wasn't worth it.
