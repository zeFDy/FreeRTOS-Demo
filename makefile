TARGET = freeRTOSdemo.o

#CROSS_COMPILE = arm-linux-gnueabihf-
CROSS_COMPILE = "C:/Program Files (x86)/GNU Arm Embedded Toolchain/10 2021.07/bin/arm-none-eabi-"
CC = $(CROSS_COMPILE)gcc
AS = $(CROSS_COMPILE)as
LD = $(CROSS_COMPILE)ld.bfd 
CP = $(CROSS_COMPILE)objcopy 
OD = $(CROSS_COMPILE)objdump
ARCH = arm

CCOPT = -mthumb -mthumb-interwork -mabi=aapcs-linux  -mno-unaligned-access -ffunction-sections -fdata-sections -fno-common -ffixed-r9  -msoft-float -march=armv7-a
LDSCRIPT := myBoot.lds

OPTIONS = -Os -Wall -Wstrict-prototypes -Wno-format-security -fno-builtin -ffreestanding -mthumb -mthumb-interwork -mabi=aapcs-linux -mword-relocations  -fno-pic  -mno-unaligned-access -mno-unaligned-access -ffunction-sections -fdata-sections -fno-common -ffixed-r9 -msoft-float -march=armv7-a -P -c 


SdRamStart.o:	SdRamStart.S
				$(CC) -x assembler-with-cpp SdRamStart.S -o SdRamStart.o -c
				$(OD) -d SdRamStart.o >SdRamStart.lst
				
main.o:			main.c
				$(CC) $(OPTIONS) $^ -o $@
				$(OD) -d $@ >$@.lst

main_blinky.o:	main_blinky.c
				$(CC) $(OPTIONS) $^ -o $@
				$(OD) -d $@ >$@.lst


freeRTOSdemo.o:	SdRamStart.o 								\
				main.o 										\
				main_blinky.o							
				$(LD) -T freeRTOSdemo.lds freeRTOSdemo.o 	\
				SdRamStart.o 								\
				main.o 										\
				main_blinky.o								\
				-o freeRTOSdemo.o
				$(CP) -O binary freeRTOSdemo.o freeRTOSdemo.bin
				$(CP) --srec-forceS3 -O srec freeRTOSdemo.o freeRTOSdemo.txt	
				$(OD) -d freeRTOSdemo.o >freeRTOSdemo.lst
				$(OD) -x freeRTOSdemo.o >freeRTOSdemo.map
				./bin2raw freeRTOSdemo.bin freeRTOSdemo.raw


