---
title: "Rust Visibility and Fuzzing"
date: 2020-07-25T11:14:45-07:00
draft: false
summary: Looking at rust's visibility from fuzzing
---

Trying to fuzz a type that is defined with `pub(crate)` visibility using
[cargo-fuzz](https://github.com/rust-fuzz/cargo-fuzz)

## visibility

Found this nice tip from
[@CecileTonglet](https://twitter.com/CecileTonglet/status/1286294359953088512?s=20)

and later in the thread:

> The difference between the tests/ directory outside the src/ and the tests
> modules inside the src/ is that in the latter your tests are inside the crate
> and can access everything. While if you make a tests/ directory it is like a
> separate crate

This helped me to understand better how & why to use `pub(crate)`.

For a directory tree like:

```bash
.
├── Cargo.toml
└─ src
   ├── config.rs
   └── snacks
      ├── mod.rs
      ├── pizza.rs
      └── tacos.rs
```

a `type` within `tacos.rs` can be marked like:

**tacos.rs**
```rust
pub(crate) struct Tacos {}
impl Tacos {}
```

and be reachable or visible to its crate but kept private from the external use
via its use in `mod.rs` 

**mod.rs**
```rust
mod tacos;
use tacos::Tacos;
```

## fuzzing
My goal is to target a private type that is exposed with `pub(crate)` for fuzzing. However fuzzing internal types isn't supported natively. Here's an issue I found asking
about the same thing:
[https://github.com/rust-fuzz/cargo-fuzz/issues/156](https://github.com/rust-fuzz/cargo-fuzz/issues/156)

> The only way I know of would be to have cfg blocks on the visibility keywords
> so they're conditionally public or private

This seems to be the best option available to me for this specific case. Another
approach is simply exposing internal modules like
[rustls](https://github.com/ctz/rustls) which exposes "private" fuzzing targets
under an `internal` module. The downsides are that it loses the benefit of
rust's privacy/visibility features.
