---
title: "b64rs"
date: 2018-10-02T23:15:26-07:00
draft: false
tags: ["rust", "knowledge", "programming"]
summary: "Making a base64 module in rust"
---

# b'aGVsbG8gd29ybGQ='
making a very simple not-at-all-robust base64 encode/decoder
[b64rs](https://github.com/jafow/b64rs).

I started this project on an airplane and got further than I expected given that I couldn't jump on Stackoverflow anytime I hit a bump. 
The rust compiler is so good and messages so helpful, that, along with examples
and references in a local copy of the Rust Book, I could usually get something
working. 

Here are some things I'm learning.

# Lifetimes
The main purpose of lifetimes is to prevent dangling references to data.
This is seems pretty straightforward in the [chapter of The Rust
Book](https://doc.rust-lang.org/book/second-edition/ch10-03-lifetime-syntax.html#preventing-dangling-references-with-lifetimes),
shown here:
```rust
{
    let r;

    {
        let x = 5;
        r = &x;
    }

    println!("r: {}", r);
}
```

The value for `r` at the point `println!` is called isn't in scope, so won't
compile. 

## lifetimes in functions 
These were a little less obvious and I needed to read up some more. 
I hit this implementing a lookup table (`HashMap`) of characters.

```rust

- temporary value dropped here while still borrowed
|
|             temporary value does not live long enough

```

### What I tried
I already had a function that returned a vector of the 64 characters I used to
encode.

```rust
pub fn encode_table() -> Vec<u8> {
    (b'A'..=b'Z')
        .chain(b'a'..=b'z')
        .chain(0..=9)
        .chain(vec![b'+', b'/'].into_iter())
        .collect()
}
```

I wanted to use the return data to create table of chars to ints for decoding.
```rust
pub fn decode_table () {
    let mut h: HashMap<&u8, &u8> = HashMap::new();
    let t = encode_table().iter();

    for (k, v) in t.zip(0..=64) {
        h.insert(k, &v);
    }
    println!("h is {:?}", h);
}
```

Compiling throws a similar lifetime error.

### why doesn't the data live long enough?
