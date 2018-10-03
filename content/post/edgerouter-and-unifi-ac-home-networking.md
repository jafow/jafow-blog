---
title: "Installing EdgeRouterX and Unifi AC Access Point"
date: 2018-07-20T13:35:38-08:00
draft: false
tag: diy, networking, knowledge
---

# Installing a cool home WLAN
Here are some things I learned installing a [Edgerouter
X](https://www.ubnt.com/edgemax/edgerouter-x/) and [Unifi AC Access
Point](https://www.ubnt.com/unifi/unifi-ap-ac-lite/)

## ufw
dead simple firewall program. have to open ports for Unifi controller, and it's
easy as 
```sh
ufw enable 443
```
to open port 443 for traffic.

## setting a static ip for my machine
- ubuntu network manager (meh)
- (buggy GUI) things would be selected sometimes, sometimes not clickable for
  unknown reasons
- where the conf file is located but not really how to edit it

## running unifi controller in the cloud
- to setup and configure the AP gotta run a java service
- ran local to get things going and then transferred to a Linode box
- don't need to use it all that often, but it's convenient to just have
  available and bookmarked

## cable managment
My place is not very big and 1 AP is just enough. But I wanted to
mount it in a central spot, and had to run about 60ft of CAT5 cable around the
perimeter of 2 rooms. Mounted on the ceiling in the living room it looks pretty
sweet.
