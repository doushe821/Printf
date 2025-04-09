# Mini printf

## About

This is a short project with implementation of printf() function from stdlib.h, written in x86-64 nasm. 

## Functionality 
miniprintf() can display a string of any length and currently supports following specifiers:

- %s - displays a string.
- %c - displays an 8-bit char.
- %d - displays an 32-bit integer number.
- %o - displays an 32-bit integer number in octal system.
- %% - displays % symbol.
- %x - displays an 32-bit integer number in hexademical system.
- %b - displays number of charachters written.

## Implementation details
Function uses partial bufferization which means it saves output string in buffer. The buffer is dumped when it is full. In order to track buffer's size there is a counter that is also used to display %b specifier.




## Usage
One of the ways to use the function is to write a header file and include it to your program: 

```c
#ifndef PRINTH_H_INCLUDED
#define PRINTH_H_INCLUDED

extern "C" int printh(const char* format, ...);

#endif
```

Then you need to compile it with nasm. 

Here's example of a very simple Makefile:

```c
all: main.cpp miniprintf.asm main

main: main.o miniprintf.o
	g++ main.o miniprintf.o -o main -g -z noexecstack -no-pie

main.o: main.cpp
	g++ -c main.cpp

miniprintf.o: miniprintf.asm
	nasm -f elf64 miniprintf.asm -g -l miniprintf.lst
```

Then you can use it exactly like a normal printf().

Here is example of miniprintf() in action:
