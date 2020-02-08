# mcp251x.c
mcp251x CAN driver with hardware filtering for the Raspberry Pi

Based on patch from:
https://support.criticallink.com/redmine/attachments/download/14913/0001-can-mcp251x-Add-ability-to-use-CAN-ID-hw-filter.patch

# Compiling driver
First download the kernel headers:
```
sudo apt-get install raspberrypi-kernel-headers
```
Now download this repo
```
git -clone https://github.com/craigpeacock/mcp251x.git 
```
Make kernel module:
```
make
```


