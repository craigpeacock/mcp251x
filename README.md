# mcp251x.c
mcp251x CAN driver with hardware filtering for the Raspberry Pi

Based on patch from:
https://support.criticallink.com/redmine/attachments/download/14913/0001-can-mcp251x-Add-ability-to-use-CAN-ID-hw-filter.patch

# Compiling driver
First download the kernel headers:
```
$ sudo apt-get install raspberrypi-kernel-headers
```
Now download this repo
```
$ git clone https://github.com/craigpeacock/mcp251x.git 
```
Make the kernel module:
```
$ cd mcp251x
$ make
```
If successful it should display something similar to below and create you a mcp251x.ko file. 
```
make -C /lib/modules/4.19.75+/build M=/home/pi/mcp251x modules
make[1]: Entering directory '/usr/src/linux-headers-4.19.75+'
  CC [M]  /home/pi/mcp251x/mcp251x.o
  Building modules, stage 2.
  MODPOST 1 modules
  CC      /home/pi/mcp251x/mcp251x.mod.o
  LD [M]  /home/pi/mcp251x/mcp251x.ko
make[1]: Leaving directory '/usr/src/linux-headers-4.19.75+'
```

# Testing
To test the driver, remove the old one (if loaded) and insert your new module into the kernel using:
```
$ sudo rmmod mcp251x
$ sudo insmod mcp251x.ko
```
and check your kernel messages:
```
$ dmesg | grep -i mcp251x
[ 1396.047462] mcp251x: loading out-of-tree module taints kernel.
[ 1582.644169] mcp251x spi0.0 can0: MCP2515 successfully initialized.
```
Parameters to specify CAN filters and masks can be sent to the kernel using insmod:
```
$ sudo insmod mcp251x.ko rxbn_op_mode=1,1 rxbn_filters=0x7E8,0x762 rxbn_mask=0xFFF,0xFFF
```
Modinfo can be used to determine parameters:
```
$ modinfo mcp251x.ko
filename:       /home/pi/mcp251x/mcp251x.ko
license:        GPL v2
description:    Microchip 251x/25625 CAN driver
author:         Chris Elston <celston@katalix.com>, Christian Pellegrin <chripell@evolware.org>
srcversion:     7145C9ABA90EF89DCFA2A61
alias:          of:N*T*Cmicrochip,mcp25625C*
alias:          of:N*T*Cmicrochip,mcp25625
alias:          of:N*T*Cmicrochip,mcp2515C*
alias:          of:N*T*Cmicrochip,mcp2515
alias:          of:N*T*Cmicrochip,mcp2510C*
alias:          of:N*T*Cmicrochip,mcp2510
alias:          spi:mcp25625
alias:          spi:mcp2515
alias:          spi:mcp2510
depends:        can-dev
name:           mcp251x
vermagic:       4.19.75+ mod_unload modversions ARMv6 p2v8
parm:           mcp251x_enable_dma:Enable SPI DMA. Default: 0 (Off) (int)
parm:           rxbn_op_mode:0 = (default) MCP2515 hardware filtering will be disabled for receive buffer n (0 or 1). rxb0 controls filters 0 and 1, rxb1 controls filters 2-5 Note there is kernel level filtering, but for high traffic scenarios kernel may not be able to keep up. 1 = use rxbn_mask and rxbn filters, but only accept std CAN ids. 2 = use rxbn_mask and rxbn filters, but only accept ext CAN ids. 3 = use rxbn_mask and rxbn filters, and accept ext or std CAN ids. (array of int)
parm:           rxbn_mask:Mask used for receive buffer n if rxbn_op_mode  is 1, 2 or 3. Bits 10-0 for std ids. Bits 29-11 for ext ids. (array of int)
parm:           rxbn_filters:Filter used for receive buffer n if rxbn_op_mode is 1, 2 or 3. Bits 10-0 for std ids. Bits 29-11 for ext ids (also need to set bit 30 for ext id filtering). Note that filters 0 and 1 correspond to rxbn_op_mode[0] and rxbn_mask[0], while filters 2-5 corresponds to rxbn_op_mode[1] and rxbn_mask[1] (array of int)
```
When the driver is loaded, you may check the current parameters via the sysfs. e.g.
```
$ cat /sys/module/mcp251x/parameters/rxbn_op_mode
1,1
$ cat /sys/module/mcp251x/parameters/rxbn_filters
2024,1890,0,0,0,0
$ cat /sys/module/mcp251x/parameters/rxbn_mask
4095,4095
```
# Installation
To install the driver:
```
sudo cp mcp251x.ko /lib/modules/$(uname -r)/kernel/drivers/net/can/spi/
```
Parameters can be passed to the driver using the modprobe daemon. Create a new file /etc/modprobe.d/mcp251x.conf and add the following:
```
options mcp251x rxbn_op_mode=1,1 rxbn_filters=0x7E8,0x762 rxbn_mask=0xFFF,0xFFF
```





