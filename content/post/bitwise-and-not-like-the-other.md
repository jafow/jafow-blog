---
title: "Bitwise And Not Like the Other"
date: 2019-10-06T10:33:36-07:00
draft: true
---
![bits](/images/bitwise.jpg)

# one of these is not like the other
in which the hero of this website discovers one mustn't judge a bitwise op by
its cover.


## C
get a load of this:

**bit.c**

```c
#include <stdio.h>

int main(int argc, const char *argv[])
{
    
    int a = 2147483648; 
    int b = 7;

    printf("%d\n", a & b);

    return a & b;
}
```

#### run it

```bash
[jared blog]  (master)
$ gcc -o bit bit.c
[jared blog]  (master)
$ ./bit
0
```

straight forward enough. Nothing suprising here. 

## python

**bit.py**
```python
def bit() -> int:
    a = 2147483648
    b = 7

    print(f'{a & b}')

    return 0


if __name__ == '__main__':
    bit()
```


#### run it


```bash
[jared blog]  (master)
$ python bit.py
0
```
same here. just some everyday run-of-the-mill stuff.


## rust
**src/main.rs**
```rust
fn main() {
    let a: i32 = 2147483647;
    let b: i32 = 7;

    println!("{}", a & b);
}
```

#### run it

```bash
[jared blog]  (master)
$ cargo run
    Finished dev [unoptimized + debuginfo] target(s) in 0.01s
     Running `target/debug/blog`
7
```

O__o wut?

I don't actually get what's going on here yet. 
