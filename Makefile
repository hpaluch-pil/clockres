#
# Makefile - for Linux
#

CFLAGS  += -g -Wall
LDLIBS  += -lm
LDFLAGS += -g

# LINK -lrt if it exists (neede on some ARM platforms)
# NOTE: scratchbox make has no $(.SHELLSTATUS) yet (since make 4.2)
RT_STATUS := $(shell test -r /usr/lib/librt.a; echo $$?)
#$(info RT_STATUS is: $(RT_STATUS) )
ifeq ($(RT_STATUS),0)
 LDLIBS += -lrt
endif 

APP := clockres
all : $(APP)
$(APP) : $(APP).o
$(APP).o : $(APP).c

.PHONY: run
run : $(APP)
	./$(APP)	

.PHONY: clean
clean:
	rm -f -- $(APP) $(APP).o

