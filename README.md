# CLOKRES C program

Simple program to query OS clock resolution using `clock_getres(3)` call.

# Setup

## On Linux

Tested on: Debian 10/amd64

Just install:

```bash
sudo apt-get install build-essential
```

To build, just issue command:

```bash
make
```

## On scratchbox

To cross-build for ARM using scratchbox append `os=scratchbox` argument to `make` command,
for example:

```bash
make os=scratchbox
```

## On  QNX 6.5.0SP1

Tested on Linux Host (CentOS 5.4). For build just use:
```
/opt/qnx650/host/linux/x86/usr/bin/make os=qnx
```
## On  QNX7 `x86_64`

Tested on Linux Host (Ubuntu 16.04.6 LTS). For build use:
```
source ~/qnx700/qnxsdp-env.sh
make os=qnx_x86_64
```


# Run

Obviously can be used for self-hosted builds (but cross-builds).

```bash
make run
```

