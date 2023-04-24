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

#OPTIONS = -Os -Wall -Wstrict-prototypes -Wno-format-security -fno-builtin -ffreestanding -mthumb -mthumb-interwork -mabi=aapcs-linux -mword-relocations  -fno-pic  -mno-unaligned-access -mno-unaligned-access -ffunction-sections -fdata-sections -fno-common -ffixed-r9 -msoft-float -march=armv7-a -P -c 
OPTIONS = -c -fmessage-length=0 -mfloat-abi=softfp -mtune=cortex-a9 -mcpu=cortex-a9 -march=armv7-a -mfpu=neon -std=c99 -fdata-sections -ffunction-sections -g3 -DALT_INT_PROVISION_VECTOR_SUPPORT=0

SdRamStart.o:				SdRamStart.S
							$(CC) -x assembler-with-cpp SdRamStart.S -o SdRamStart.o -c
							$(OD) -d SdRamStart.o >SdRamStart.lst
							
main.o:						main.c
							$(CC) $(OPTIONS) $^ -o $@
							$(OD) -d $@ >$@.lst
			
main_blinky.o:				main_blinky.c
							$(CC) $(OPTIONS) $^ -o $@
							$(OD) -d $@ >$@.lst

FreeRTOS-Kernel/portable/memmang/heap_4.o:	FreeRTOS-Kernel/portable/memmang/heap_4.c
							$(CC) $(OPTIONS) $^ -o $@
							$(OD) -d $@ >$@.lst

FreeRTOS-Kernel/tasks.o:	FreeRTOS-Kernel/tasks.c
							$(CC) $(OPTIONS) $^ -o $@
							$(OD) -d $@ >$@.lst

FreeRTOS-Kernel/list.o:		FreeRTOS-Kernel/list.c
							$(CC) $(OPTIONS) $^ -o $@
							$(OD) -d $@ >$@.lst

FreeRTOS-Kernel/queue.o:	FreeRTOS-Kernel/queue.c
							$(CC) $(OPTIONS) $^ -o $@
							$(OD) -d $@ >$@.lst

FreeRTOS-Kernel/portable/GCC/ARM_CA9/port.o:	FreeRTOS-Kernel/portable/GCC/ARM_CA9/port.c
							$(CC) $(OPTIONS) $^ -o $@
							$(OD) -d $@ >$@.lst


freeRTOSdemo.o:				SdRamStart.o 									\
							main.o 											\
							main_blinky.o									\
							FreeRTOS-Kernel/tasks.o							\
							FreeRTOS-Kernel/list.o							\
							FreeRTOS-Kernel/queue.o							\
							FreeRTOS-Kernel/portable/memmang/heap_4.o		\
							FreeRTOS-Kernel/portable/GCC/ARM_CA9/port.o
							$(LD) -T freeRTOSdemo.lds freeRTOSdemo.o 		\
							SdRamStart.o 									\
							FreeRTOS-Kernel/tasks.o							\
							FreeRTOS-Kernel/list.o							\
							FreeRTOS-Kernel/queue.o							\
							FreeRTOS-Kernel/portable/memmang/heap_4.o		\
							FreeRTOS-Kernel/portable/GCC/ARM_CA9/port.o		\
							libc.a											\
							libm.a											\
							crt0.o 											\
							main.o 											\
							main_blinky.o									\
							-o freeRTOSdemo.o
							$(CP) -O binary freeRTOSdemo.o freeRTOSdemo.bin
							$(CP) --srec-forceS3 -O srec freeRTOSdemo.o freeRTOSdemo.txt	
							$(OD) -d freeRTOSdemo.o >freeRTOSdemo.lst
							$(OD) -x freeRTOSdemo.o >freeRTOSdemo.map
							./bin2raw freeRTOSdemo.bin freeRTOSdemo.raw


