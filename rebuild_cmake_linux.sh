#!/bin/bash

# WARNING!
# scratchbox's bash (3.00) does NOT support +=
set -e
cd `dirname $0`
src="`pwd`"

build_type=''
WORKSPACE=''
tools_prefix=''
args=''

usage ()
{
	[ -z "$1" ] || echo "$1" >&2
	echo "Usage: $0 [ --ws WORKSPACE ] [ --build-type Debug | Release | MinSizeRel | RelWithDebInfo ]" >&2
	exit 1
}

while [ $# -gt 0 ]
do
	case "$1" in
		-h|--help)
			usage
			;;
		--ws)
			# WS is jenkins WORKSPACE for build
			WORKSPACE="$2"
			shift
			;;
		--build-type)
			case "$2" in
				Debug|Release|MinSizeRel|RelWithDebInfo)
					build_type="$2"
					shift
					;;
				*)
					usage "Invalid build type '$2'"
					;;
			esac
			;;
		*)
			usage "Invalid option \"$1\""
			;;
	esac
	shift
done


if [ -r /etc/os-release ];then
	source /etc/os-release
else
	ID=Linux
	VERSION_ID=tk71
fi

if [ -d ".git" ]; then
	GIT_TAG_ID="clockres-$(git describe --always --dirty --long | sed 's/.*-g/g/')"
	args="$args -DGIT_ID=$GIT_TAG_ID"
fi


p=clockres-$ID-$VERSION_ID
[ -z "$build_type" ] || p="$p-$build_type"

[ -n "$WORKSPACE" ] || {
	# emulate jenkins workspace...
	WORKSPACE=~/tmp
}

[ -n "$WORKSPACE" -a -d "$WORKSPACE" ] || {
	echo "Internal error - $WORKSPACE is invalid" >&2
	exit 1
}

# always use hardcoded prefix to avoid disaster (rm -rf /) when variablei sempty
set -x
rm -rf $WORKSPACE/build/$p
mkdir -p $WORKSPACE/build/$p
cd $WORKSPACE/build/$p

[ -z "$build_type" ] || args="$args -DCMAKE_BUILD_TYPE=$build_type"

# generate Makefile under WORKSPACE
cmake $args $src
# build 
make VERBOSE=1

${tools_prefix}readelf -d clockres | grep -e '\(NEEDED\|RUNPATH\)'
# creates package
make package
tar tvzf *.tar.gz 
exit 0

