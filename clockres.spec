# clockres.spec for RedHat tito builder
Name:           clockres
Version:        0.2
Release:        1
Summary:        Dump various clock resolutions for clock_gettime(2) calls

Group:          Development Tools
License:        MIT
URL:            https://github.com/hpaluch-pil/clockres
# NOTE: Must have .tar.gz suffix to work properly with Tito builder
Source0:        %{name}-%{version}.tar.gz
#BuildArch:      x86_64

BuildRequires:  gcc make
#BuildRequires:  cmake >= 3.0
# on CentOS7 we have to use:
BuildRequires:  cmake3 cmake3-data
%description
Provides simple utility 'clockres' that dumps clock resolutions
for clock_gettime(2) calls. The resolution is gathered using
clock_getres(2) calls.

%prep
%setup -q 

%build
%cmake3
%cmake3_build

%install
rm -rf %{buildroot}
mkdir -p %{buildroot}/%{_bindir}

%cmake3_install

%files
%license LICENSE
%{_bindir}/%{name}

# use  date  '+%a %b %d %Y' to get date in format:
%changelog
* Wed Feb 16 2022 Henryk Paluch <henryk.paluch@pickering.cz> 0.2-1
- Build rpm with cmake (was make) (henryk.paluch@pickering.cz)

* Thu Nov 26 2020 Henryk Paluch <henryk.paluch@pickering.cz> 0.1-1
- 1st RPM package build with Tito

* Thu Nov 26 2020 Henryk Paluch <henryk.paluch@pickering.cz> 0.1-1
- 1st RPM release using Tito


