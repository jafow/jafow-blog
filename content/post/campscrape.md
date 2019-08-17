---
title: "Campscrape"
date: 2019-07-14T20:50:18-07:00
draft: false
tag: pi, raspberry-pi, python, programming
---

# camping with computers
I hacked together a script that checks for open camping reservations at state campgrounds in California.
These sites are limited and demand is high. Last year
[the state parks reservation service underwent a reboot]
(https://www.sfchronicle.com/travel/article/Parks-declare-war-on-bots-over-camp-reservations-13484794.php)
in an effort to discourage this kind of thing. 

It worked! The re-captcha was too much for me to try to hack against in a weekend, so I left it to
just scan for open dates and send a slack notification to me.

# campscrape
[here's the repo](https://github.com/jafow/campscrape)

The request data looks like this:
```python
req_params_template = {
    "RegionId": 0,
    "PlaceId": 680,
    "FacilityId": 0,
    "StartDate": "12/29/2019",
    "Nights": "1",
    "CategoryId": "0",
    "UnitTypeIds": [],
    "UnitTypesCategory": [],
    "ShowOnlyAdaUnits": False,
    "ShowOnlyTentSiteUnits": False,
    "ShowOnlyRvSiteUnits": False,
    "MinimumVehicleLength": "0",
    "FacilityTypes_new": 0,
    "AccessTypes": [],
    "ShowIsPremiumUnits": False,
    "ParkFinder": [],
    "UnitTypeCategoryId": "0",
    "ShowSiteUnitsName": "0",
    "AmenitySearchParameters": []
}
```

Given a list of dates to search--say all the Fridays in August--and a list of campsite ids, the script
requests each combination of site and date and sends off a message over slack webhook.

The campsite ids you have know, and I haven't added a way of fetching those. For now you just gotta look up 
the desired site and find it's id by peering into the browser dev tools network tab or something. I don't remember.
