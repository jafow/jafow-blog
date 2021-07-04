---
title: "Scraping All Written Correspondance With My Wife"
date: 2018-07-22T23:38:36-07:00
draft: false
type: post
tags: ["programming", "python"]
summary: Scraping all the chats and emails with my 💖 better half 💖.
---

# An Anniversary gift
[Here's an anniversary gift I made for my wife:
https://very-good-website.xyz/inbox-all/](https://very-good-website.xyz/inbox-all/) and some scattered notes I
took building it.

The source code for this is on github:
[https://github.com/jafow/inbox-all](https://github.com/jafow/inbox-all)

## v0.0.1 too narrow
- iterate over messages, check if they are from me to A or vice versa;
- `walk()` when message is multipart
- checking only for Content-Type text/html (didn't know about
  `.get_payload(decode=True)`
- only used check for `msg['From']` property, but `msg.get_from()` catches more


## why are so many messages being skipped?
- is it content type "multipart/alternative" not getting picked up?
- **Discovery?!**: if a message is multipart, `get_pyaload()` returns a
    list of all parts of the message. calling `get_payload()` on each of
    _those_ returns the body of the part

### found a bug
when finding an multipart message, I was walking the message, but not iterating
over its parts, instead just calling `m.get_paylaod()` from with in the 

```python
# etc ...
for part in msg.walk()
    # should call part.get_payload()
    # etc ...
```
