---
title: "How to connect to JIIT Study Material"
date: 2020-08-14T13:31:20+05:30
draft: false
tags:
  - how_to
  - JIIT
  - openvpn
  - samba
---

I recently received a call from my room mate. He was asking about how he could access the "Study Material"
shared folder from our college. He mentioned that the college had sent us a file with directions for setting
it up, (which I was blissfully unaware of, honestly I couldn't care less about the classes starting right now
:/)

Well upon opening the file I did find some instructions, BUT they are only for windows, I don't know
what to say. I really don't. For all the good peeps running linux, here's my guide on how to set it up.

PS: Of course I could have just called my room mate up and told him the entire thing. Heck I could
even have logged in on his laptop via ssh and done it all by myself, but this blog desparately needs posts
right now and I am running behind on my write ups, since I got bit busy for the past three months or so. So
I thought to myself, "Why not?"

## Who is this guide for?

Anyone using linux who hasn't been able to accesss the "Study Material" shared folder on their sytsems
because of the absence of instructions and the cryptic nature of the files downloaded. (The configuration
file ends with a `.ovpn`, and when I first looked at such a file a year ago, it made absolutely no sense
to me whatsoever.) I'll try and explain why we are doing what we are doing too so if you're interested in
that do read it to the end.

Lastly I hope this works with Macbooks too. Honestly I am too poor to be able to afford one and test it
out. Do let me know if it doesn't work though, I'll try and help to the best of my abilities.

## TL;DR

- Install openvpn on your distribution. For most of you it should be:
```
sudo apt install openvpn
```
  (Others can refer to the documentation of their distributions on how to use their package managers.)
- Go to [the link mentioned in the pdf](https://14.139.238.98:8180/userportal/webpages/myaccount/login.jsp) and login using the Sophos
  password. (Yes that Sophos password. Took me 7 tries.)
- Download the configuration files for other OS. You should get a file with the folowing name format:
```
<enrollment_number>@pdc.jiit__ssl_vpn_config.ovpn
```
- Open the downloaded file with your favorite editor. For me it'll be like this on the terminal:
```
edit ~/Downloads/18103150@pdc.jiit__ssl_vpn_config
```
- Search for the line `comp-lzo no` and replace it with `compress lzo`
- Run the following command:
```
sudo openvpn --config ~/Downloads/<enrollment_number>@pdc.jiit__ssl_vpn_config.ovpn
```
  (You'll have to leave this running for the entire time you need to access the server. Quit it via `<Ctrl-c>`
  when you're done, and run it again everytime you need to access the folder.)
- It will ask you for the root password. Enter that.
- It will then ask you for the Sophos username and password. Type that in.
- Open your file manager.
- Most have a connect to server/remote network in the left side tray at the very bottom.
- Enter this ip adress in the server field: `172.16.68.30`. (From the pdf given to us by our college.)
- Set the port to `8443`.
- Add the username and passwords in there respective feilds, and leave everything else as is.

And voila! You should be up and running! If this is all that you came for then there you go. If you faced
any problems in the above steps, try and follow along, I'll try and explain why we are doing what we
are doing. Maybe that helps? If that didn't try and reach out and I'll try my best to help you.

## Cool but, why?

Here's an explanation for the steps for anyone curious about it. (Or people who don't want to do crap
to their systems without having a solid reason why. Eg: The minimalists, the security freaks and what not.)
I'll try and keep this concise so that I only describe absolutely what's necessary for this to work. You
can read the man pages of the tools used for more info.

**!!!Disclaimer!!!**: I am no expert on networks and I won't be explaining any network related stuff here.
I'll explain only the things that are needed to understand the steps we took.

### The downloaded file

The file we downloaded is a config file for `openvpn`. What is OpenVPN? I'll leave that to you guys. A simple
google search would help you with that. You can checkout the `man` page for `openvpn` too. What the config
file does is tells the openvpn client, (running on our machine,) about where the request made to a specific
address are supposed to go. In our case, it decides where does a request made on `172.16.68.30` actually
goes. It does that by adding routes to the route table, and some other stuff that I am not gonna go into
since I am no expert on networks as I just said, and also because I don't think that those details
are relevant here.

When we run `openvpn` with the config file, whenever a packet is to be sent to the IP adress `172.16.68.30`
it is sent to the openvpn client, which compresses, encrypts and looks up the route table and sends
the file to where it's supposed to be sent via a secure tunnel. Detailed explanation [here](https://openvpn.net/vpn-server-resources/site-to-site-routing-explained-in-detail/).

### The "comp-lzo" voodoo

The OpenVPN client needs to know wether the server will be expecting compressed packets. If the server
is infact accepting compressed packets, the client would then require the compression algorithm that
the server is expecting. In our case it is the `lzo` algorithm. In the config file we have `comp-lzo` set
to `no`.

Now two things, first, we need the lzo compression. If we run it as is, we get the following error:
```
Bad compression stub decompression header byte: 102
```
Which I am guessing means that the decompression resulted in an unknown header byte that caused this error,
or simply we are using the wrong compression algorithm.

Second, `comp-lzo` is a deprecated flag. It will soon be removed from OpenVPN. It has been replaced by
the `compress` flag. You simply write the name of the algorithm after the `compress` flag for it to work
like `comp-lzo`. In our case it would be `compress lzo`.

### The rest of it

The rest of it us just us basically whatever the prompt asks us to. One question that remains unanswered
is how was the port number found. Well it's there among the last lines of the `ovpn` file that we downloaded.

## Conclusion

Well there you go. That should be it. If there are any problems, you can try reaching out via email or gitter. My gitter userhandle is BK1603. I'll try and help you out as much as possible. Also I hope
that all you are staying safe and doing well!

(I'll try and add a comments section soon enough, I've been partly busy and partly lazy about it.)
