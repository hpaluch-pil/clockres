# CLOKRES C program

Simple program to query OS clock resolution using `clock_getres(3)` call.

# Setup

## On Linux

Tested on: Debian 10/amd64

Just install:

```bash
sudo apt-get install build-essential
```

## On  QNX 6.5.0SP1

Tested on Linux Host (CentOS 5.4). For build just use:
```
/opt/qnx650/host/linux/x86/usr/bin/make
```
instead of plain `make` command.

# Build

```bash
make
```

# Run

```bash
make run
```

