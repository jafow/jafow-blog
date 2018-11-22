---
title: "Rust: Slice and Bytes"
date: 2018-11-22T11:31:35-08:00
draft: false
tags: rust
---
# vectors, arrays, slices, and bytes
Here are some examples of comparing vectors, arrays, slices, and bytes that I've confused more than once.

## hex
Using the [hex crate](https://docs.rs/hex/0.3.2/hex/) we can 
get back `Result` of vector of `u8`s or `FromHexError`.

```rust
extern crate hex;

fn main() {
    let res = hex::decode("48656c6c6f20776f726c6421");
    println!("res: {}", res);
}
```

Running outputs:

```sh
$ cargo run --example main
   Compiling pals v0.1.0 (/home/verygoodwebsite/posts/example1)
    Finished dev [unoptimized + debuginfo] target(s) in 0.38s        
     Running `target/debug/examples/main`
res: Ok([72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33])
```

`hex::decode` returns a `Result` around a vector of `u8`s or an error.

## vectors equal arrays(?!)
Surprisingly to me this compiles:
```rust
extern crate hex;

fn main() {
    let x = hex::decode("48656c6c6f20776f726c6421");
    let y: [u8; 12] = [72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33];

    assert_eq!(x.unwrap(), y);
}
```

I suppose it shouldn't be too much of a surprise; the values within the
two _are_ equal.

## byte string equal arrays(?!)
a byte string is an array of chars; how does that compare with the array? 
```rust
fn main() {
    let y: [u8; 12] = [72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33];
    let z = b"Hello world!";
    assert_eq!(y, z);
}
```

Running outputs:
```sh
$ cargo run --example main
   Compiling pals v0.1.0 (/home/verygoodwebsite/post/example2)
error[E0277]: can't compare `[u8; 12]` with `&[u8; 12]`
  --> examples/main.rs:12:5
   |
12 |     assert_eq!(y, z);
   |     ^^^^^^^^^^^^^^^^^ no implementation for `[u8; 12] == &[u8; 12]`
   |
   = help: the trait `std::cmp::PartialEq<&[u8; 12]>` is not implemented for `[u8; 12]`
   = note: this error originates in a macro outside of the current crate (in Nightly builds, run with -Z external-macro-backtrace for more info)

error: aborting due to previous error

For more information about this error, try `rustc --explain E0277`.
```
This doesn't compile. A byte string, e.g. `b"my byte string"`, is a reference to an array of unsigned 8-bit `ints`. The _values_ are equal, but we can't compare a reference to an actual block of data. 

**what happens if we compare `z` with a pointer to `y`?**
```rust
fn main() {
    let y: [u8; 12] = [72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33];
    let z = b"Hello world!";
    assert_eq!(&y, z);
}
```

yep! It compiles.

Same is true if we dereference the `z`:
```rust
fn main() {
    let y: [u8; 12] = [72, 101, 108, 108, 111, 32, 119, 111, 114, 108, 100, 33];
    let z = b"Hello world!";
    assert_eq!(y, *z);
}
```

# slice and bytes
Using same example, here's how a `&str` slice and bytes compare:
```rust
fn main() {
    let z: &[u8; 12] = b"Hello world!";
    let aa: &str = "Hello world!";
    assert_eq!(aa.as_bytes(), z);
}
```

Use the `.as_bytes` (or mutable version `.as_bytes_mut`) method to convert to bytes.
