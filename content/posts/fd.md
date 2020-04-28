---
title: "fd"
date: 2020-04-28T17:31:41+05:30
draft: true
toc: false
images:
tags: 
  - writeups
  - pwnable.kr
---

## A word before we start
Before starting the discussion of the problem, for anyone following these 
blog posts, I'd like to mention that everything required by these 
challenges can be read as and when necessary, but having a very basic 
knowledge of the linux command line, file permission bits on linux and 
tools like `ssh`, `scp` and `nc` would be very helpful. Also try reading 
the `man` pages of any command line tool the use of which you couldn't 
understand.

Also, all the writeups that I do for these problems would always contain a
section named "Hint", it would contain a hint which according to me should 
help in solving the problem. If you want to solve a problem but are stuck 
somewhere, try looking at these hints and see if you get somewhere with 
the problem.

## Hint
The input is through a file descriptor, what file descriptor can you
write to?

## How I solved it
The title of the first problem at [pwnable.kr](https://pwnable.kr) is fd.
If you have even a little experience with linux or have manipulated files in a language like C, you'd think that the problem somehow involves file descriptors. And you wouldn't be wrong. Clicking on the problem you'd find
the following hint:
```
Mommy! what is a file dexriptor in Linux?

* try to play the wargame your self but if you are ABSOLUTE beginner, follow this tutorial link:
https://youtu.be/971eZhMHQQw

ssh fd@pwnable.kr -p2222 (pw:guest)
```

Well, before starting anything, I like to download the files present at
the pwnable server to a local directory, so that I can test out my 
solutions locally. I did that with the following command:
```
scp -r -P2222 fd@pwnable.kr:~/ ./
```
*(You can checkout the `scp` command by running `man scp` on your terminal, always remember: curiosity is your friend here.)*

Opening the directory where the files were copied, I saw that the source 
file for the binary was given to us. I started out by reading the source 
file.

The first thing that I noticed in the source was the following `if` block:
```
if(argc<2){
	printf("pass argv[1] a number\n");
	return 0;
}
```
The program takes at least one argument as an input. (Hence the check 
`argc < 2`.) From the error message, we can assume that the first argument 
that was passed should be a number. Upon reading the code further, I saw that the 
program uses the first argument passed to it (`argv[1]`) in the 
following line:
```
int fd = atoi( argv[1] ) - 0x1234;
```

The code subtracts the hex value `0x1234` from the first input passed, 
and store it in the `fd` variable. It then uses `fd` as a file descriptor
and reads 32 bytes from it and stores the value in the buffer buf:
```
len = read(fd, buf, 32);
if(!strcmp("LETMEWIN\n", buf)) {
  printf("good jon :)\n");
  system("/bin/cat flag");
  exit(0);
}
```

It outputs the flag if the read string is "LETMEWIN". Upon getting here,
I realised that what I can do is, give a value to this program such that
the value of `fd` becomes 0, which is the file descriptor for `STDIN`. Then
the program would try to read from the standard input, and I could type
out the string "LETMEWIN". Converting `0x1234` to the decimal number 
system, we get `4660`.

Typing the following into the terminal displays the success message:
```
./fd 4660
LETMEWIN
good job :)
/bin/cat: flag: No such file or directory
```
We get a cat error as we don't have the flag file on our system, we aren't
allowed to copy the flag file to our systems, as we might change the 
permissions of that file and simply `cat` the flag.

Running this code on the ssh session gives us the flag!

## A question
What happens if we try to cat the `flag` file directly in the `ssh` 
session? Let's try it out:
```
 ____  __    __  ____    ____  ____   _        ___      __  _  ____  
|    \|  |__|  ||    \  /    ||    \ | |      /  _]    |  |/ ]|    \ 
|  o  )  |  |  ||  _  ||  o  ||  o  )| |     /  [_     |  ' / |  D  )
|   _/|  |  |  ||  |  ||     ||     || |___ |    _]    |    \ |    / 
|  |  |  `  '  ||  |  ||  _  ||  O  ||     ||   [_  __ |     \|    \ 
|  |   \      / |  |  ||  |  ||     ||     ||     ||  ||  .  ||  .  \
|__|    \_/\_/  |__|__||__|__||_____||_____||_____||__||__|\_||__|\_|
                                                                     
- Site admin : daehee87@gatech.edu
- IRC : irc.netgarage.org:6667 / #pwnable.kr
- Simply type "irssi" command to join IRC now
- files under /tmp can be erased anytime. make your directory under /tmp
- to use peda, issue `source /usr/share/peda/peda.py` in gdb terminal
You have mail.
Last login: Tue Apr 28 08:58:55 2020 from 213.230.77.85
fd@pwnable:~$ cat flag
cat: flag: Permission denied
```
We get a permission denied error, obviously we shouldn't be allowed to cat
the flag, and using `ls -l` to check the permissions on this file, we
find that it is in fact the case:
```
fd@pwnable:~$ ls -l
total 16
-r-sr-x--- 1 fd_pwn fd   7322 Jun 11  2014 fd
-rw-r--r-- 1 root   root  418 Jun 11  2014 fd.c
-r--r----- 1 fd_pwn root   50 Jun 11  2014 flag
```
We see that the flag file is only readable be the owner `fd_pwn` or by
someone belonging to the `root` group. 

Well if that's the case then how does the `fd` binary `cat`s the file? The
answer to that is the `s` flag. It is called the `setuid` flag. You can
read more about it [here](https://en.wikipedia.org/wiki/Setuid).
