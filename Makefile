# Use the 'st-flash' from system PATH, or override it if needed
STLINK ?= st-flash

# Source files
SRCS=main.c system_stm32f4xx.c

# Library source files
SRCS += stm32f4xx_rcc.c stm32f4xx_gpio.c

# Binaries will be generated with this name (.elf, .bin, .hex)
PROJ_NAME=oselector

# Compiler settings. Only edit CFLAGS to include other header files.
CC=arm-none-eabi-gcc
OBJCOPY=arm-none-eabi-objcopy

# Compiler flags
CFLAGS  = -g -O2 -Wall
CFLAGS += -DUSE_STDPERIPH_DRIVER
CFLAGS += -mlittle-endian -mthumb -mcpu=cortex-m4 -mthumb-interwork
CFLAGS += -mfloat-abi=hard -mfpu=fpv4-sp-d16
CFLAGS += -I.

# Include header files
CFLAGS += -I$(CURDIR)/cmsis
CFLAGS += -I$(CURDIR)/cmsis/boot
CFLAGS += -I$(CURDIR)/stm32
CFLAGS += -I$(CURDIR)/stm32/periph/inc
CFLAGS += --specs=nosys.specs

# add startup file to build
SRCS += $(CURDIR)/startup/startup_stm32f4xx.s

# Linker script
LDFLAGS = -T${CURDIR}/startup/stm32_flash.ld

vpath %.c $(CURDIR)/cmsis/boot $(CURDIR)/stm32/periph/src

.PHONY: all proj burn clean

# Commands
all: proj

proj: $(PROJ_NAME).elf

$(PROJ_NAME).elf: $(SRCS)
	$(CC) $(CFLAGS) $(LDFLAGS) $^ -o $@
	$(OBJCOPY) -O ihex $(PROJ_NAME).elf $(PROJ_NAME).hex
	$(OBJCOPY) -O binary $(PROJ_NAME).elf $(PROJ_NAME).bin

clean:
	rm -f *.o $(PROJ_NAME).elf $(PROJ_NAME).hex $(PROJ_NAME).bin

# Flash the STM32F4
burn: proj
	$(STLINK) --reset write $(PROJ_NAME).bin 0x8000000
