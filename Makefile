#
# Makefile - for Linux
#

prefix = /usr/local

CFLAGS  += -g -Wall
LDLIBS  += -lm
LDFLAGS += -g

# NOTE: Even hash (#) must be escaped to (\#) and obviously also ($) to ($$)
CLOCKRES_VER := $(strip $(shell awk '/^\#define CLOCKRES_VER_STR/{print $$3}' clockres.c | tr -d '"' ))
ifeq ($(CLOCKRES_VER),)
$(error Unable to extract Version string from clockres.c )
endif

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

install: $(APP)
	install -D -m 755 $(APP) $(DESTDIR)$(prefix)/bin/$(APP)

uninstall:
	-rm -f $(DESTDIR)$(prefix)/bin/$(APP)

PDIR := clockres-$(CLOCKRES_VER)
ARCHIVE := $(PDIR).tar.gz
dist: $(APP)
	rm -f  build/*.tar.gz
	rm -rf build/tree
	mkdir -p build/tree/$(PDIR)
	cp clockres.c Makefile LICENSE README.md build/tree/$(PDIR)
	( cd build/tree && tar -cz --numeric-owner --owner=0 --group=0 -f ../$(ARCHIVE) $(PDIR)/  )

.PHONY: all rebuild run clean install uninstall dist

