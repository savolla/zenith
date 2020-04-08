zenith
======

![](./zenith-logo.png =666x666)

a tiny operating system that runs on x86 processor

why I'm doing this?
-------------------

windows and linux are great operating systems. but neither windows is open source or linux kernel's code is readable anymore. I've tryed to read linux's source code but it's just **pain in the ass**. reading it's code is time consuming process for a new comer. and because of it's complexity it's more like brain damage than an education..

So I decided to write my own from scratch. It's not gonna to be as mature as linux or windows of couse. but at least I will know about  all It's internal workings. I'm highly influenced by Terry Davis who wrote his own TempleOS in 10 years. That OS didn't even support networking. but has its own graphics engine, own dialect of C (Holy C) and even a flight simulator! and it's only 15 megs in size. think about it.. flight simulator + 10 years and 15 megs..

since I know what undocumented or badly documented code is, to make things crystal clear I will document my code as good as posible. I'll do my best to make variable names and comments very clear. so the code will be easier to read/maintain and friendly for people who want to learn how to make a thing like this.

Another thing about why I'm doing this is I like low level stuff so much... maybe it's gonna be an **overkill** project for me because I'm also not really experienced programmer yet.. but it's worth to try isn't it? (died)


installation
------------

- you will need:
	
	1. gcc ( GNU C compiler )
	2. make ( setup.exe )
	3. nasm ( netwide assembler )
	4. qemu ( quick emulator )
  
  install those tools with your package manager. if you are on windows then I'm sorry for you. (in many cases..)

- build it with
```
make zenith
```

run in emulator
------------

if you want to run **zenith** on an emulated environment, do the following:

```
qemu zenith
```

if above command doesn't work try that one:

```
qemu-system-x86_64 zenith
```

running on a real hardware
------------

1. get a flash drive and plug in
2. check the name of your drive with:


```
sudo lsblk
```

it's probably **/dev/sdb**

3. use **dd** command to flash zenith into your drive

```
sudo dd status=progress if=zenith of=/path/to/my/flash/drive
```

4. open your BIOS settings and configure it to boot from a flash drive
5. restart. you should see a black screen with welcome message.







