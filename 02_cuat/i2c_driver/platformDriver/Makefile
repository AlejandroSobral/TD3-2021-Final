

KERNEL_SOURCE = /lib/modules/$(shell uname -r)/build
MOD_NAME = my_i2c_driver
PWD := $(shell pwd)

# Converts a module object in LKM
obj-m += src/$(MOD_NAME).o

all: objclean build insmod

build:
	make -C ${KERNEL_SOURCE} M=${PWD} modules

#Clean objects
objclean:
	make -C ${KERNEL_SOURCE} M=${PWD} clean

clean: rmmod softclean

rebuild: rmmod all

#Check whether the module is installed or not
cat:
	cat /proc/modules | grep $(MOD_NAME)

#Install module
insmod:
	sudo insmod src/$(MOD_NAME).ko

#Remove module
rmmod:
	sudo rmmod src/$(MOD_NAME).ko 

tail:
	tail -f /var/log/syslog


