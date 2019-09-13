---
title: "Unifi Ap Controlled by Remote Linode"
date: 2019-09-13T09:54:21-07:00
draft: false
---

Previously posted notes from [installing a Unifi AP and EdgeMax router](https://very-good-website.xyz/post/edgerouter-and-unifi-ac-home-networking/).

I originally ran the unifi controller locally from my laptop. This is easiest to
get up and running. Eventually I wanted to clear space on my laptop -- the unifi
controller writes to a local mongodb instance and that shit was getting huge!
-- so I moved the controller to a remote server. 

![unifi access point](/images/unifi-ap.jpg)

# installing on a VPS 
I like [Linode](https://www.linode.com/) a lot. I decided to use a
nanonode to run this controller. There's a debian package for the
unifi controller so we can use `apt` to download and install. 

I followed most of the steps [in this
script](https://www.linode.com/stackscripts/view/348247) with cross-referencing on the [Unifi
official
help](https://help.ubnt.com/hc/en-us/articles/209376117-UniFi-Install-a-UniFi-Cloud-Controller-on-Amazon-Web-Services#7).

# some things I wish I knew ahead of time
this was considerably easier to do because I had several things setup, but there
were a few steps along the way that I had to stop and figure out.

**what is the access point IP address?**

this wasn't obvious to me at first how to obtain. I wanted to `ssh` onto the AP
in order to "inform" the access point the IP address of its controller, which
was now the location of my linode. 

I got the access point IP address by logging into the EdgeMax router and finding the AP listed:

![dhcp-leases](/images/dhcp-lease.png).

In hindsight of course this makes sense. The router knows IP addresses of every
device on the LAN.

**how to remove the AP from the wall bracket**

This wasn't trivial! I had to remove the AP in order to physically reset it.
Why was it necessary to physically reset? I couldn't successfully ssh into the AP because I lost
the ssh password. :-(

I remembered from installing the AP that the wall mount had a
click/lock mechanism. But I had to jam a zip tie into the unlock it and twist
much harder than I expected. Was certain I was gonna break it. 
[The docs recommend a zip tie, too.](https://help.ubnt.com/hc/en-us/articles/115012530767-UniFi-Removing-a-UAP-from-the-Wall-Mount)



## STUN server error
After associating the AP to the remote controller running on linode I 
got [this error](https://help.ubnt.com/hc/en-us/articles/115015457668-UniFi-Troubleshooting-STUN-Communication-Errors#whyhasthiserror)
This was suprising. Why is there a STUN server running and why is it breaking my
ability to install firmware?!

**the answer?**

`ufw` again -- had to allow UDP on port 3478.
The controller expects ports `8443`, `8080`, and `3478` open.
