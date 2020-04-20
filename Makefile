#
# Makefile - for Linux
#

CFLAGS += -g -Wall
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

