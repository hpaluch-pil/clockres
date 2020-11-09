#
# Makefile - for Linux
#

CFLAGS  += -g -Wall
LDLIBS  += -lm
LDFLAGS += -g

ifeq ($(os),qnx)
 CC=qcc
 CFLAGS += -DUSE_CLOCK_CYCLES
endif

ifeq ($(os),qnx_x86_64)
 CC=qcc -Vgcc_ntox86_64
 CFLAGS += -DUSE_CLOCK_CYCLES
endif


ifeq ($(os),scratchbox)
 LDLIBS += -lrt
endif 

APP := clockres
all : $(APP)
$(APP) : $(APP).o
$(APP).o : $(APP).c

rebuild: clean $(APP)

run : $(APP)
	./$(APP)	

clean:
	rm -f -- $(APP) $(APP).o

.PHONY: all rebuild run clean

