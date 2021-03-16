#!/bin/bash

set -e
cd `dirname $0`
src="`pwd`"

build_type=''
args=''
WORKSPACE=''

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


# Crude way to find, which QNX version we use
[ -n "$QNX_HOST" ] || {
	echo "The \$QNX_HOST variable is not se" >&2
	exit 1
}
cross_dir="$QNX_HOST/usr/bin"
[ -d "$cross_dir" ] || {
	echo "The variable QNX_HOST='$QNX_HOST' does not point to QNX SDP kit" >&2
	exit 1
}

qnx_arch='x86_64'
qnx_ver=''
binutils_prefix=''
for p in $cross_dir/x86_64-pc-nto-qnx*-gcc
do
	[ -x "$p" ] || {
		echo "QNX 7.0 Cross gcc '$p' not found/executable" >&2
		break
	}
	b="$(basename "$p")"
	[[ $b =~ ^x86_64-pc-nto-qnx([1-9]\.[0-9]\.[0-9])-gcc$ ]] || {
		echo "Unable to extract QNX version from '$b'" >&2
		exit 1
	}
	qnx_ver="${BASH_REMATCH[1]}"
	binutils_prefix=$qnx_arch-pc-nto-qnx$qnx_ver
	break
done

[ -n "$qnx_ver" ] || {
	echo "QNX7 detection failed - trying QNX 6 as least resort..."
	qc="$QNX_HOST/usr/bin/qconfig"
	[ -x "$qc" ] || {
		echo "Unable to executed '$qc'" >&2
		exit 1
	}
	qnx_ver=$($qc -b | grep 'Version:' | sed 's/.*Version: *//g')
	qnx_arch=x86
	binutils_prefix=nto$qnx_arch
}

[ -n "$qnx_ver" ] || {
	echo "Unable to find valid QNX SDP installation" >&2
	exit 1
}

[[ $qnx_ver =~ ^([1-9])\.([0-9])\.[0-9]$ ]] || {
	echo "Internal error - QNX_VERSION='$qnx_ver' is invalid" >&2
	exit 1
}

[ -x $cross_dir/$binutils_prefix-readelf ] || {
	echo "Unable to find proper readelf: '$binutils_prefix-readelf'" >&2
	exit 1
}

qnx_ver_major_minor="${BASH_REMATCH[1]}${BASH_REMATCH[2]}"
echo "Detected QNX_VERSION='$qnx_ver', majorminor='$qnx_ver_major_minor' arch='$qnx_arch'"

p=clockres-qnx$qnx_ver

[ -n "$WORKSPACE" ] || {
	# emulate jenkins workspace...
	WORKSPACE=~/tmp
}

[ -n "$WORKSPACE" -a -d "$WORKSPACE" ] || {
	echo "Internal error - $WORKSPACE is invalid" >&2
	exit 1
}

tc_file="$src/cmake/toolchain_qnx${qnx_ver_major_minor}_${qnx_arch}.cmake"
[ -r "$tc_file" ] || {
	echo "Unable to read toolchain-file: '$tc_file'" >&2
	exit 1
}

# always use hardcoded prefix to avoid disaster (rm -rf /) when variablei sempty
set -x
rm -rf $WORKSPACE/build/$p
mkdir -p $WORKSPACE/build/$p
cd $WORKSPACE/build/$p

[ -z "$build_type" ] || args="$args -DCMAKE_BUILD_TYPE=$build_type"
cmake -DCMAKE_TOOLCHAIN_FILE:PATH="$tc_file" \
	$args $src

make VERBOSE=1
$cross_dir/$binutils_prefix-readelf -d clockres | grep -e '\(NEEDED\|RUNPATH\)'
# creates package
make package
tar tvzf *.tar.gz
exit 0

