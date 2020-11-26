# CLOKRES C program

Simple program to query OS clock resolution using `clock_getres(3)` call.

# Setup

## On Linux

### On Debian 10/amd64
Tested on: Debian 10/amd64

Just install:

```bash
sudo apt-get install build-essential
```

### On CentOS 7

```bash
sudo yum install gcc make
```

## On Linux (continued)

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

## On QNX 6.5.0SP1

Tested on Linux Host (CentOS 5.4). For build just use:
```
/opt/qnx650/host/linux/x86/usr/bin/make os=qnx
```
## On QNX7 `x86_64`

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

# Distribution

## Building Debian 10 package

You can now create native Debian packages thanks to
metadata under `debian/` directory.

To generate just binary `.deb` package in parent directory, issue:
```bash
debuild -i -us -uc -b
```

To generate source deb-src files (useful if you plan to
user `pbuilder` - personal builder for many Debian versions)
under `chroot`:

```bash
debuild -i -us -uc -S
```

## Building CentOS 7 package

This projects uses tool [Tito](https://github.com/rpm-software-management/tito/blob/master/tito.spec)

Tested versions:
- OS: `CentOS 7.9.2009` (see `/etc/redhat-release`)
- Tito tool: `0.6.15` (from `tito --version` command)

To build RPM prepare your system:

* enable [EPEL repository](https://fedoraproject.org/wiki/EPEL) using 
  ```bash
  sudo rpm -ivh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm
  ```

* install required packages
  ```bash
  sudo yum install tito gcc make rpm-build rpmdevtools
  ```

To build latest untagged version from git, use:
```bash
tito build --rpm --test
```

To build latest tagged version from git, use:
```bash
tito build --rpm
```


