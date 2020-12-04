# CLOKRES C program

Simple program to query OS clock resolution using `clock_getres(2)` call.
Such information can be useful if you plan to use `clock_gettime(2)` in your programs.

# Setup

## On Linux

Common setup:

* install git:
  ```bash
  # on RHEL/CentOS 7,8...
  sudo yum install -y git
  # on Debian
  sudo apt-get install -y git
  # on OpenSUSE 15
  sudo zypper in git-core
  ```

* clone this repository:
  ```bash
  mkdir -p ~/projects
  cd ~/projects
  git clone https://github.com/hpaluch-pil/clockres.git
  cd clockres/
  ```

* follow instructions below...


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

### Adding distribution tag

It is often desirable to have unique name of binary packages for
different Debian distribution - typically in form `+deb10u1` which means
"for Debian 10 Update 1".  Currently there is this clumsy way to do this:

```bash
# use "source" for bash or "." for dash
source /etc/os-release
dch -v "0.1+deb${VERSION_ID}u1" -D $VERSION_CODENAME "Added final distribution tag"
# and rebuild packages as usual
debuild -i -us -uc -S
# rollback modified debian/changelog
git checkout -- debian/changelog
```


## Building CentOS 7 package

This projects uses tool [Tito](https://github.com/rpm-software-management/tito)

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

RPMS are created in folder `/tmp/tito` including `/tmp/tito/x86_64`.



