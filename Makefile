obj-m+=mcp251x.o

all:
	make -C /lib/modules/$(shell uname -r)/build M=$(shell pwd) modules

clean:
	make -C /lib/modules/$(shell uname -r)/build M=$(shell pwd) clean

modules_install: all
	make -C /lib/modules/$(shell uname -r)/build M=$(shell pwd) modules_install
	$(DEPMOD)