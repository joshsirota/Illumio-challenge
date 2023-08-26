No doubt I have ham-fisted a lot of erlang-isms in here, as this is the first time I've used erlang and I completed this assignment in about 2 hours.

So please don't judge me on style items, though I'd love to learn if this is something that Illumio uses all the time. Looking at some of your existing code would help a lot.

But I used the functional programming style I'm familiar with for the most part, and definitely embraced the "let it fail" mantra that I believe is part of erlang. Certainly a lot more error handling could be done here though it's unclear to me if that's the way it's normally done.

To run this, simply make the program `urls.erl` executable and run it on the command-line, passing the original hex string as a parameter. I cribbed the hex-to-string code from Stack Overflow, though all of the rest of it I wrote from scratch. For example, run
```
./urls.erl 474554202f20485454502f312e310d0a486f73743a207777772e696c6c756d696f2e636f6d0d0a557365722d4167656e743a206375726c2f372e38312e300d0a4163636570743a202a2f2a0d0a0d0a
```

Also -- I've written the output (as in ASCII) straight to the stdout rather than converting it back to hex. Please let me know of this is something you need to see.

