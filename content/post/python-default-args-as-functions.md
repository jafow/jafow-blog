---
title: "Python Default Args as Functions"
date: 2019-07-14T21:52:16-07:00
draft: false
tags: programming, python
---

## **are you sure you wanna put a function invocation as a default argument?**

here's a bug I got bit by recently. In hindsight it was a pretty rookie mistake,
and is even kind of mentioned in the very excellent worthy of re-reading
[Hitchhiker's guide to
Python](https://docs.python-guide.org/writing/gotchas/#mutable-default-arguments).

The below example is totally contrived; this isn't actual code, but it
demonstrates the problem in a stripped down way. 

### great idea: use a function call as a default arg
here's the thing I learned: you only want to use an idempotent function as a default arg:

This code is _not_ going to produce the desired outcome.
```python
def set_id(user, id=random_user_id()):
    """ set a user's id and provide a default if none is provided """
    user['id'] = id
    return user
```

if the `random_user_id` function looks something like this:

```python
from random import choice

def random_user_id():
    """ choose a number at random from 100 """
    return choice([x for x in range(0, 100)])
```

then there will be a problem. 

### problem: that only works if the function produces the same output every invocation

```python
from random import choice

def random_user_id():
    """ choose a number at random from 100 """
    return choice([x for x in range(0, 100)])

def set_id(user, id=random_user_id()):
    """ set a user's id and provide a default if none is provided """
    user['id'] = id
    return user

users = [dict(name=n) for n in {'alice', 'bob', 'eve', 'jared'}]

for u in users:
    # set a default "random" id for each user in the list
    # hint: this isn't going to work as expected because python will cache those
    # function objectzzz
    set_id(u)

assert len(set(u['id'] for u in users)) == 1
```

That `assert` could in theory be true for actually randomly generated ids. But
if you run it few times you'd also expect it NOT to eval true. It always will!

Another way to see this is by using some call to `time.time()` as the default
function argument. 

My takeaway from this is to handle with care the use of non-idempotent functions and when
needed, invoke at the point they're _actually_ needed. 
