## Introduction

No doubt I have ham-fisted a lot of erlang-isms in here, as this is the first time I've used erlang and I completed this assignment in about 2 hours. So please don't judge me on style items, though I'd love to learn if this is something that Illumio uses all the time! Looking at some of your existing code would help a lot. I mean, I'm not sure about variable (well, constant) naming conventions, indentation style, whether or not my main function is too long, etc. I'll certainly take hints.

But I used the functional programming style I'm familiar with for the most part, and definitely embraced the "let it fail" mantra that I believe is part of erlang. Certainly a lot more error handling could be done here though it's unclear to me if that's the way it's normally done in "real" erlang-based products or if we really would follow the "let it fail" guidelines. Interestingly, "let if fail" is completely the opposite of the other major functional language I've used a lot, Scala. In Scala, the best-practivec is that you try to handle pretty much EVERYTHING, always, and only allow exceptions to occur that would really be unforeseeable.

I'm also not claiming that this will work for all valid inputs. I wouldn't be too surprised if URL encoding or alternate character encodings break something. If we need to take this to the next level, let me know that!

## Assumptions
1. This only NEEDS to work on the provided input, not necessarily any example of valid HTTP.
2. Any reviewer will already have erlang and escript installed locally in order to run this (though my local output is present in `OUTPUT.md`)
3. It's okay to output the modified HTTP request in human-readable form rather than convert it back to hex. The prompt implies that there's an expectation of hex when explaining the one example, but I'm assuming that in reality the hex input is there to make sure that the user understands that the input is not just hostname strings but rather an full HTTP request.
4. It's okay to handle the happy-path here and "let it fail" as I keep reading about erlang. There is no error handling here at all!

Obviously if any of these assumptions are wrong, please let me know ASAP so I can correct them!

## How-To
To run this, simply make the program `urls.erl` executable and run it on the command-line, passing the original hex string as a parameter. I cribbed the hex-to-string code from Stack Overflow, though all of the rest of it I wrote from scratch. 

I used `escript` as a shortcut for a command-line tool. I'm assuming that you all will have this and the rest of the erlang toolset installed locally.

For example, run
```
./urls.erl 474554202f20485454502f312e310d0a486f73743a207777772e696c6c756d696f2e636f6d0d0a557365722d4167656e743a206375726c2f372e38312e300d0a4163636570743a202a2f2a0d0a0d0a
```

