TARGET := firmware

CC := arm-none-eabi-gcc

OBJCOPY := arm-none-eabi-objcopy

OBJDUMP := arm-none-eabi-objdump

READELF := arm-none-eabi-readelf

CPUFLAGS := -mcpu=cortex-m3 -mthumb

CFLAGS := $(CPUFLAGS) \
          -ffreestanding \
          -fno-builtin \
          -nostdlib \
          -nostartfiles \
          -nodefaultlibs \
          -g \
          -O0 \
          -Wall \
          -Wextra

LDFLAGS := $(CPUFLAGS) \
           -nostdlib \
           -T linker.ld \
           -Wl,-Map=$(TARGET).map \
           -g

SRCS := startup.S main.c uart.c

OBJS := $(SRCS:.c=.o)

OBJS := $(OBJS:.S=.o)

.PHONY: all clean run debug dump

all: $(TARGET).elf $(TARGET).bin

$(TARGET).elf: $(OBJS) linker.ld
	$(CC) $(LDFLAGS) $(OBJS) -o $@

$(TARGET).bin: $(TARGET).elf
	$(OBJCOPY) -O binary $< $@

startup.o: startup.S
	$(CC) $(CPUFLAGS) \
	      -ffreestanding \
	      -nostdlib \
	      -g \
	      -c $< -o $@

main.o: main.c
	$(CC) $(CFLAGS) -c $< -o $@

uart.o: uart.c
	$(CC) $(CFLAGS) -c $< -o $@

run: $(TARGET).elf
	qemu-system-arm \
		-M lm3s6965evb \
		-nographic \
		-kernel $(TARGET).elf

debug: $(TARGET).elf
	qemu-system-arm \
		-M lm3s6965evb \
		-nographic \
		-kernel $(TARGET).elf \
		-S \
		-gdb tcp::1234

dump: $(TARGET).elf
	$(READELF) -h $(TARGET).elf
	$(READELF) -S $(TARGET).elf
	$(OBJDUMP) -d $(TARGET).elf

clean:
	rm -f *.o *.elf *.bin *.map