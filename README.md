# CLOKRES C program

Simple program to query OS clock resolution using `clock_getres(2)` call.
Such information can be useful if you plan to use `clock_gettime(2)` in your programs.

WARNING! This project is in transition from
plain `make(1)` to `cmake(1)`

WARNING #2 ! Now we can even (cross)build with 
Google's [Bazel](https://bazel.build/start) - see sections below.

WARNING! Since [cfcd454][cfcd454] Debian specific files
(the `debian/` directory) were moved from branch [master][master] to [debs/master][debs-master].
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
sudo apt-get install build-essential cmake
```

### On CentOS 7

```bash
sudo yum install gcc make cmake
```

## On Linux (continued)

To build, run cmake wrapper script:

```bash
./rebuild_cmake_linux.sh
```

This also apply for `armel` build under Nokia's scratchbox.

However you need to download build and install cmake-3.0.2 by
yourself first.

## On QNX 6.5.0SP1
Tested on Linux Host (CentOS 5.4).

For cmake build you need to:
* download build and install cmake-3.0.2
* and then just run:

```bash
./rebuild_cmake_qnx.sh
```

## On QNX7 `x86_64`

Tested on Linux Host (Ubuntu 16.04.6 LTS). For build use:
```
source ~/qnx700/qnxsdp-env.sh
./rebuild_cmake_qnx.sh
```

## Build with Bazel

Now we can build with  [Bazel](https://bazel.build/) - Google's building
tool.

For openSUSE LEAP 15.3 Install these packages:

```bash
sudo zypper in git-core bazel gcc-c++ glibc-devel
sudo zypper in bazel python-devel python-xml
```

For Fedora 35 install these **unofficial** COPR packages (COPR is
like SUSE's OBS - public package build service),
see https://bazel.build/install/redhat
```bash
dnf install dnf-plugins-core
dnf copr enable vbatts/bazel
dnf install bazel4
dnf install git-core gcc gcc-c++ glibc-devel
```

For Debian 11 follow: https://bazel.build/install/ubuntu,
approximately:
- install GPG key
  ```bash
  sudo apt-get install apt-transport-https curl gnupg
  curl -fsSLO https://bazel.build/bazel-release.pub.gpg
  gpg --dearmor bazel-release.pub.gpg 
  sudo cp bazel-release.pub.gpg.gpg /usr/share/keyrings/bazel-archive-keyring.gpg
  ```
- now create file `/etc/apt/sources.list.d/bazel.list`
  with contents:
  ```
  deb [arch=amd64 signed-by=/usr/share/keyrings/bazel-archive-keyring.gpg] https://storage.googleapis.com/bazel-apt stable jdk1.8
  ```
- and finally
  ```bash
  sudo apt-get update
  sudo apt-get install bazel
  sudo apt-get install git-core g++ libc-dev libstdc++-10-dev
  ```

Run build:
```bash
# this shows available targets
bazel query ...
# run only target
bazel build //:clockres
```

The resulting binary is (symlinked) can be run as:

```bash
bazel-bin/clockres
```

Once you are done, shutdown server (automatically run by first
invocation of bazel):

```bash
bazel shutdown
```

## Cross-building for aarch64 with Bazel:

Prepare Linaro toolchain (the target path is hardcoded):
```bash
cd
curl -fLO https://releases.linaro.org/components/toolchain/binaries/7.2-2017.11/aarch64-linux-gnu/gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu.tar.xz
tar xvf gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu.tar.xz
# WARNING! Symbolic link will not work - must be absolute canonical path
sudo mv gcc-linaro-7.2.1-2017.11-x86_64_aarch64-linux-gnu /opt/aarch64-linux-gnu
sudo chown root:root -R /opt/aarch64-linux-gnu/
# quick test
/opt/aarch64-linux-gnu/bin/aarch64-linux-gnu-gcc -dumpmachine
# should print: aarch64-linux-gnu
```

To cross-build for `aarch64` using above Linaro cross-gcc in `/opt/aarch64-linux-gnu/`
run this command:

```bash
bazel build --config=aarch64 '//:clockres'
```

To verify binary architecture try:
```bash
$ readelf -h bazel-bin/clockres | fgrep 'Machine:'

  Machine:                           AArch64
```

Done!

Bugs:
- Bazel always builds C++ binary (even when source is `*.c`)
  - see https://github.com/bazelbuild/bazel/issues/2954
  - you can verify it with command:
    ```bash
    ldd bazel-bin/clockres

        linux-vdso.so.1 (0x00007ffed2f91000)
        libstdc++.so.6 => /usr/lib64/libstdc++.so.6 (0x00007ff493bcb000)
        libm.so.6 => /lib64/libm.so.6 (0x00007ff493880000)
        libc.so.6 => /lib64/libc.so.6 (0x00007ff49348b000)
        /lib64/ld-linux-x86-64.so.2 (0x00007ff493fde000)
        libgcc_s.so.1 => /lib64/libgcc_s.so.1 (0x00007ff493272000)
    ```
   - notice the `libstdc++.so.6` - should not be there...


# Run

Obviously can be used for self-hosted builds (but cross-builds).
Look for binary `clockres` under `~/tmp/build/clockres-*/`

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

