---
title: "Scraping All Written Correspondance With My Wife"
date: 2018-07-22T23:38:36-07:00
draft: true
---

# An Anniversary gift

## v0.0.1 too narrow
- iterate over messages, check if they are from me to A or vice versa;
- `walk()` when message is multipart
- checking only for Content-Type text/html (didn't know about
  `.get_payload(decode=True)`
- only used check for `msg['From']` property, but `msg.get_from()` catches more



## why are so many messages being skipped?
- is it content type "multipart/alternative" not getting picked up?
- is my sample wrong?
    - malformed and therefor not running
        - **Discovery?**: if a message is multipart, `get_pyaload()` returns a
          list of all parts of the message. calling `get_payload()` on each of
          _those_ returns the body of the part

### found a bug
when finding an multipart message, I was walking teh message, but not iterating
over its parts, instead just calling `m.get_paylaod()` from with in the 
```python
# etc ...
for part in msg.walk()
    # should call part.get_payload()
    # etc ...
```
