# Update: 9 April 2014
At the [suggestion](https://github.com/joelanders/r6502/issues/1) of Ed Spittles,
I've pulled in [some tests from Klaus Dormann](https://github.com/Klaus2m5/6502_65C02_functional_tests).
Specifically, I've copied his `6502_functional_test`
binary and listing to my `bin/` directory here.

To run this test, there's a loader, `klaus_dormann_test.rb`,
which loads the binary into memory and runs it until it
detects a `jmp *` loop (jump to the current PC).

At this time, it's stopping at location 0x5eb, which,
after referencing the code listing, tells me the stack
pointer is not the correct value at that point. Todo:
figure out why...

# Update: 14 November 2012
It works. [See my blog post](http://0xfffc.tumblr.com/post/35751220092/6502-assembler-and-simulator-in-ruby)

It probably bears no resemblance to the JS code
which inspired the project, so don't get confused
by that.

Also, the code (and especially the specs) need
cleanup and refactoring, so don't judge. :)

# Original intro:
Work-in-progress assembler and simulator of the 6502,
written in Ruby.

Originally, I was going to fork Nick Morgan's JS simulation
(github.com/skilldrick/6502js), but I decided to do a
rewrite in Ruby. (He's got a very nice interactive "book"
on 6502 assembly programming.)

Nick's version is a modification of the excellent original,
by Stian Soreng (6502asm.com), so probably the most thanks
for the code goes to him.

I'm using the JS code as reference, but probably most of
the internal structure will be quite different.

MIT Licensed
