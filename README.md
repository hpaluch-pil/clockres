# CLOKRES C program

Simple program to query OS clock resolution using `clock_getres(2)` call.
Such information can be useful if you plan to use `clock_gettime(2)` in your programs.

WARNING! Since [cfcd454][cfcd454] Debian specific files
(the `debian/` directory) was moved from branch [master][master] to [debs/master][debs-master].
Similarly since [0d5c1cb][0d5c1cb] RPM specific files
(`clockres.spec` and `.tito/*`) were moved from [master][master] branch to
[rpms/master][rpms-master].  So now there are these branches:

* [master][master] - primary development branch. Only native source here (no package
   specific files allowed here)
* [debs/master][debs-master] - this branch contains `debian/` directory necessary to build
  Debian packages.
* [rpms/master][rpms-master] - this branch contains `clockres.spec` and `.tito/` used
  to build RPM packages

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

WARNING! Since [cfcd454][cfcd454] the `debian/` directory was moved
from [master][master] branch to [debs/master][debs-master]. You therefore need
to switch to [debs/master][debs-master] branch before building Debian packages using:

```bash
git checkout debs/master
```

### Building with plain "debuild"

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

#### Adding distribution tag

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

### Building with plain "git buildpackage"

It is experimental.

At first install required packages:

```bash
sudo apt-get install git-buildpackage pristine-tar
```

Then I can build Debian package using:
```bash
gbp buildpackage
# packages are build into ../build-area/
```
WARNING! It will not work for you so far! It requires my GPG key to sign all files.

## Building CentOS 7 package

WARNING! Since [0d5c1cb][0d5c1cb] the RPM specific files
were moved from [master][master] branch to [rpms/master][rpms-master]. You therefore need to switch
to [rpms/master][rpms-master] branch before building RPM packages using:

```bash
git checkout rpms/master
```

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

[cfcd454]:  https://github.com/hpaluch-pil/clockres/commit/cfcd454502ff5815e8bf675ae8db11e331de1664
[0d5c1cb]:  https://github.com/hpaluch-pil/clockres/commit/0d5c1cb6cd7ebde9fec958dd28ef7de6577f4314
[debs-master]: https://github.com/hpaluch-pil/clockres/tree/debs/master
[rpms-master]: https://github.com/hpaluch-pil/clockres/tree/rpms/master
[master]: https://github.com/hpaluch-pil/clockres/tree/master

