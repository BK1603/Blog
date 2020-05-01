---
title: "Cryptopals Set 1 Problem 1"
date: 2020-05-01T16:58:26+05:30
draft: false
tags:
  - cryptography
  - cryptopals
  - writeups
---

Umm right before we start I'd like to say that I might make some very 
stupid mistakes in the process of solving these problems, I hope that's not
going to be a problem, I've already written about it [here](https://bk1603.github.io/blog/cryptopals).

Now then, off we go!

## The question
The problem heading states: **Convert hex to base64**. I am expecting
a bit (pun not inteded) of binary arithematic for this one. According to
the problem statement, we will have to convert a hexadecimal string 
given to us into its base64 equivalent. I think that's it for the question.
Let's start solving this!

## Solution

### Convert the string to hex
Well the first problem that we have is that the input given to us is in 
the form of a string. We need to convert it to the equivalent hex values
before we can work on it. I am thinking of storing these values in an
integer array. But before deciding about how we store it, I think we should
first look up about how does the base64 algorithm actually works.

### The algorithm
Here is what the algorithm states (as stated [here](http://www.herongyang.com/Encoding/Base64-Encoding-Algorithm.html)):

3. Divide the input byte stream into blocks of 3 bytes.
4. Divide 24 bits of each 3-byte block into 4 groups of 6 bits. *(1 byte = 8 bits, so 3 bytes = 24 bits, so far they are right about the maths prerequisite.)*
5. Map each group of 6 bits to 1 printable character, based on the 6-bit 
   value using the Base64 character set map. *(Will mention in the example.)*
6. If the last 3-byte block is not completely full, padd the incomplete 
  part with 0 bytes. So you would be padding it with either 2 bytes of zeroes (\x00\x00) or maybe a 1 byte (\x00) depending upon how much of the last block is full.
7. Ignore carriage return ('\r') and new line ('\n') characters for the 
  purpose of decoding. Simply append it at the end of the output string.
  
Okay now let's see what the "Base64 character set map" looks like and then
follow it up with an example of how the algorithm works in principle:

```
Value Encoding  Value Encoding  Value Encoding  Value Encoding
    0 A            17 R            34 i            51 z
    1 B            18 S            35 j            52 0
    2 C            19 T            36 k            53 1
    3 D            20 U            37 l            54 2
    4 E            21 V            38 m            55 3
    5 F            22 W            39 n            56 4
    6 G            23 X            40 o            57 5
    7 H            24 Y            41 p            58 6
    8 I            25 Z            42 q            59 7
    9 J            26 a            43 r            60 8
   10 K            27 b            44 s            61 9
   11 L            28 c            45 t            62 +
   12 M            29 d            46 u            63 /
   13 N            30 e            47 v
   14 O            31 f            48 w         (pad) =
   15 P            32 g            49 x
   16 Q            33 h            50 y
```

That's the character map, with the encodign for each value in the decimal
number system. You can think of these 64 characters as digits of another
number system, a "base 64" number system. I guess that's how the name 
came into existence? Don't take my word for it. Also instead of the usual
way of converting between number systems, we are going to play with the 
arrangement of bits for this one. So that's probably wrong anyways. 

Enough rambling, here's an example:
```
  Hex:  A4
  Binary: 10100100 
  
  Breaking it into blocks of three bytes
  Hex:       A   4  padding   padding
  Binary: 10100100  00000000  00000000 
  
  Breaking it down into 6 bit groups:
  101001 | 000000 | 000000 | 000000
      41 |      0 |      0 |      0
  
  Now then for the last part, we map the characters from the table as
  per the numbers we got after the division, appending 2 '=' for the 
  2 padded 0 bytes. And we get the following base64 output:
  
  Base64: pA==
```

And there we have it, we now know exactly how base64 works, and you are free to do whatever you feel like with this knowledge. Let us continue with 
the solution for now though.

### Representing the hex
Well, after reading the algorithm, I am thinking of storing 24 bits in an
integer and maintaining an array of such integers, so that we can easily break it into groups of 6 without worrying
about any remainders. (Since 6 neatly divides 24, don't know about you 
guys but the people who made the site knew their stuff. The thing that
they said about the maths preqrequisite still holds true. Oh you're asking
about the base conversion? Well, I think that's taught in grade 9, if it 
isn't then go ahead and contact them. They can't lie like that.)

So storing 24 bits would mean that we can store 6 hexadecimal digits in 
a single integer. (Each hex digit being 4 bits, and, you guessed it, 4x6=24
). I will be using C programming language for this, and I
think the left shift (`>>`) and the right shift(`<<`) operators are gonna
come in handy for this.

So what we can do is something like the following:
```
  unsigned int *hex = (int *)malloc(sizeof(int) * len);
  memset(hex, 0, sizeof(hex));
  int i, j;
  for(i = 0, j = 0; i < strlen(buffer); i++) {
    int k;
    for(k = 0; k < 5; k++) {        // only 5 times because we don't want to shift the last value.
      if(i < strlen(buffer))
        hex[j] |= ctox(buffer[i]);  // or the values if we havent already consumed them all.
      hex[j] <<= 4;                 // right shift by 4, to make room for the upcoming characters, or for the padding.
      i++;
    }
    // assign the last value without shifting.
    hex[j] |= (i >= strlen(buffer)) ? 0 : ctox(buffer[i]);
    j++;
  }
  int total_bytes = strlen(input)/2; // each hex character is 4 bits = 1/2 bytes.
  int pad = 3 - (total_bytes%3);  // the extra bytes that we insert when we don't have 3 full bytes at the end. 
```

Also here is the definition for `ctox`, it returns the hexadecimal value 
equivalent of the characters.
```
int ctox(char ch) {
  if(ch >= '0' && ch <= '9')
    return (int)(ch - '0');
  if(ch >= 'a' && ch <= 'f')
    return (int)(ch - 87);      // as 'a'=97, and in hex a means 10
```
That sorts the representation, and the problem itself. Yep that's it. We're done.

### Final steps
Now that we have the binary broken up in gropus of 6 bits, we simply
need to print these bits according the Base64 character map. Here is an
idea for that:
```
char base64[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
```

Now we can simply and 6 bits from the integer array, and use whatever
we get as an index to print the value from the array above. It would
look something like this:

```
  int written = 0;                    // keep track of bytes written
  for(i = 0, j = 0; j < len; j++) {
    int mask = 0xfc0000               // 1111 1100 0000 0000 0000 0000
    for(int k = 0; k < 4; k++) {
      written = i/8;
      if(total_bytes - written > 0)
        // get the first 6 bits by & fc0000 (since we stored
        // 24 bits, so the highest bit is in the 24th pos.)
        // then shift right and repeat.
        printf("%c", base64[(hex[j] & mask) >> (18 - k * 6)]);
      else
        printf("=", pad);
      mask >>= 6;
      i += 6;
    }
  }
  printf("\n");
```

## A final word
As must be evident by the code, I am not writing very clean code right now.
Right now, I am focusing entirely on learning the concepts for basic 
cryptography, maybe the code quality gets better as we progress. I will
break things into functions and just clean things up a bit. Also the part
for handling the padding is a bit hacky, and any suggestions for improving
it are welcome. You can comment here once I enable comments, till then make an issue in the github repo.
