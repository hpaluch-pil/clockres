# clockres.spec for RedHat tito builder
Name:           clockres
Version:        0.1
Release:        1
Summary:        Dump various clock resolutions for clock_gettime(2) calls

Group:          Development Tools
License:        MIT
URL:            https://github.com/hpaluch-pil/clockres
# NOTE: Must have .tar.gz suffix to work properly with Tito builder
Source0:        %{name}-%{version}.tar.gz
#BuildArch:      x86_64

BuildRequires:  gcc make
%description
Provides simple utility 'clockres' that dumps clock resolutions
for clock_gettime(2) calls. The resolution is gathered using
clock_getres(2) calls.

%prep
%setup -q 

%build
make

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/%{_bindir}

make install DESTDIR="%{buildroot}" prefix="%{_prefix}"

%files
%license LICENSE
%{_bindir}/%{name}

# use  date  '+%a %b %d %Y' to get date in format:
%changelog
* Thu Nov 26 2020 Henryk Paluch <henryk.paluch@pickering.cz> 0.1-1
- 1st RPM package build with Tito

* Thu Nov 26 2020 Henryk Paluch <henryk.paluch@pickering.cz> 0.1-1
- 1st RPM release using Tito


