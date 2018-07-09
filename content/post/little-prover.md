---
title: "Reading: Little Prover"
date: 2018-01-16T13:35:38-08:00
draft: true
tag: reading-notes
---

## Ch2:

__Law of Dethm__:
you can swap any part of the arguments to a function with a corresponding expression, and then rewrite the function body
to include those swapped args to uncover a focus:

1. the rewritten function body body<sub>e</sub> must have a _conclusion_
   (equal p q) or (equal q p)

2. the conclusion can't be in an if condition:
example:

```python
# not allowed!

if apple == fruit:
    make_pie = true
else:
    make_compost = true

apple == fruit # QED!?
```

## Focus
>a focus is only pertinent to an if-question if the focus is contained by
>the if-question's answer or if-else

That makes sense -- we can't tell anything about a focus if it's 
not related to the question:
for example, the focus "the ocean is blue", has nothing to do with the question
"if the sky is blue"...
in this form:

    if the sky is blue:
        then birds will sing gaily
        else:
            birds remain quiet
    if the ocean is filled with oxygen:
        then the ocean is blue
        else:
            the fish remain quiet
        
The focus "the ocean is blue"--even if it shares the same idea of "blueness" with the sky--is a total non-sequiter to the if-question
"if the sky is blue".

# Ch3
This book started to click for me at the end of ch3. I'm still settling on a
workflow for working through the proofs; I started writing directly into the
repl to get the quick feedback. I'd build a proof line at a time, enter it and
use the output to guide me onto the next step. Once the proof was complete, I'd
define and save it in Dr Rackets editor window.

*   less intuitive was the notion of declaring the "path" to the focus
    being proved. The best way for me was maybe the most obvious: 
    just reading through the examples in the "recess" chapter MANY TIMES. I read
    through them until I had a feel for it, and then started writing the proofs for ch 3. 
    It took going back to the "Recess" chapter and typing out the last 2
    proofs verbatim to have it really sink in.

*   Syntax and debugging a misplaced parentheses was a little annoying at first, but
    very quickly became intuitive. I did start the habit of, during writing
    lines of the proof, typing out the open & close parens of the "path" and
    then writing the expression. There might be a way to do matching parens in
    Dr Racket, but I haven't looked into it.
    
# Ch4
*Total*
A function is _total_ if it evaluates to an expression that has a value, no
matter what value is passed to it.

## What is (size x)?
This is not intuitive yet:
```scheme
(size '(a b c))
; 3

(size '(a (b c)))
; 4
```

This is even less intuitive, but informative!
```scheme
(size '(a (cons 'b (c))))
; 8

(size '(a (cons 'b '(c))))
; 10
```

So creating a list using `'()` is different from a `cons`.

```scheme
(cons '() (cons '() '()))
; (() ())

(size (cons '() (cons '() '())))
; 2
```

# ch5
Frustrating: things are starting to get interesting, but at the same LESS
practical. So I wrestle with justifying the time and effort of reading,
understanding, typing out and even writing about the experience of reading the
book, versus making something "practical" that will "help advance my career". 
