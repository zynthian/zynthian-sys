#!/bin/sh

_git_options=""

if [ -z ${0} ]
then
	PROJECT=`basename ${0} .sh`
	echo "PROJECT: $PROJECT"
fi

zynth_build_request () {
	flag=${1}
	if [ "${flag}" = "clear" ]
	then
		rm -f "${ZYNTHIAN_SW_BUILD_DIR}/${PROJECT}_build"
	elif [ "${flag}" = "ready" ]
	then
		touch "${ZYNTHIAN_SW_BUILD_DIR}/${PROJECT}_build"
	fi
}

if [ "${1}" = "build" ]
then
	shift
	build="build"
	zynth_build_request clear
elif [ "${1}" = "clean" ]
then
	shift
	build="clean"
	zynth_build_request clear
fi

if [ ! -d "${ZYNTHIAN_SW_DIR}/.build" ]
then
	mkdir "${ZYNTHIAN_SW_DIR}/.build"
fi
ZYNTHIAN_SW_BUILD_DIR="${ZYNTHIAN_SW_DIR}/.build"

machine=`uname -m 2>/dev/null || echo unknown`
if [ "${machine}" = "armv7l" ]
then
    model=`cat /sys/firmware/devicetree/base/model | strings` || echo unknown
    if echo "${model}" | egrep -Eq '[3]'
    then
        CPU="-mcpu=cortex-a53"
        FPU="-mfpu=neon-fp-armv8"
    else
        CPU="-mcpu=cortex-a7 -mthumb"
        FPU="-mfpu=neon-vfpv4"
    fi
    CPU="${CPU} -Ofast"
    #FPU="${FPU} -mneon-for-64bits -mfloat-abi=hard -mlittle-endian -munaligned-access"
    FPU="${FPU} -mfloat-abi=hard -mlittle-endian -munaligned-access"
    export RASPI=true
fi
export CFLAGS="${CPU} ${FPU}"
export CXXFLAGS="${CFLAGS}"

zynth_git () {
    ret=0

    tmp=`basename ${1}`
    if [ "${2}" ]
    then
        repo_dir=`/usr/bin/basename $2 .git`
    else
        repo_dir=`/usr/bin/basename $tmp .git`
    fi
    if [ -d "${repo_dir}" ]
    then
        cd "${repo_dir}"
	if [ "`git log --pretty=%H ...refs/heads/master^ | head -n 1`" = "`git ls-remote origin -h refs/heads/master |cut -f1`" ]
	then
		zynth_build_request ready
	else
		git pull 1>&2
		ret=1
		zynth_build_request clear
	fi
        cd ..
    else
	if [ "${_git_options}" ]
	then
        	#git clone "${_git_options}" "${1}"
        	git clone "${_git_options}" ${*}
	else
        	#git clone "${1}"
        	git clone ${*}
	fi
        ret=1
    fi

    return ${ret}
}

zynth_git_recursive () {
   _git_options="--recursive"
   ret=`zynth_git $*`
   return ${ret}
}

zynth_svn () {
    ret=0

    if [ ${2} ]
    then
        tmp=`basename ${2}`
    else
        tmp=`basename ${1}`
    fi
    repo_dir=`basename ${tmp} -code`

    if [ -d "${repo_dir}" ]
    then
        cd "${repo_dir}"
        svn update 2>&1 | grep "At revision"
        if [ ${?} -eq 1 ]
	then
		ret=1
	fi
        cd ..
    else
        svn checkout "${1}" "${repo_dir}"
        ret=1
    fi

    return ${ret}
}

quote_path () {
    echo ${1} | sed 's/\//\\\//g'
}
