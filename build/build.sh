#!/bin/bash

if [ "${BUILD_ENV}" != "build.sh" ]; then
	echo "Please source the env and try again"
   	return 1
fi

function bone_menuconfig()
{
 	pushd $BIG_CORE_DIR
 	scons --menuconfig
 	popd
}

function sone_menuconfig()
{
 	pushd $SMALL_CORE_DIR
 	scons --menuconfig
 	popd
}

function make_bcore()
{
 	pushd $BUILD_BCORE_PATH
 	if [ -e "rtconfig.h" ] && [ -f "rtconfig.h" ]; then
    	rm -rf "rtconfig.h"
	fi
	
	if [ -e "$BIG_CORE_DIR/rtconfig.h" ] && [ -f "$BIG_CORE_DIR/rtconfig.h" ]; then
    	cp -rf "$BIG_CORE_DIR/rtconfig.h" .
	fi
	
	if [ -e "link_stacksize.lds" ] && [ -f "link_stacksize.lds" ]; then
    	rm -rf "link_stacksize.lds"
	fi
	
	if [ -e "$BIG_CORE_DIR/link_stacksize.lds" ] && [ -f "$BIG_CORE_DIR/link_stacksize.lds" ]; then
    	cp -rf "$BIG_CORE_DIR/link_stacksize.lds" .
	fi
	
 	scons 
 	popd
}

function make_score()
{
 	pushd $BUILD_SCORE_PATH
 	if [ -e "rtconfig.h" ] && [ -f "rtconfig.h" ]; then
    	rm -rf "rtconfig.h"
	fi
	
	if [ -e "$SMALL_CORE_DIR/rtconfig.h" ] && [ -f "$SMALL_CORE_DIR/rtconfig.h" ]; then
    	cp -rf "$SMALL_CORE_DIR/rtconfig.h" .
	fi
	
 	scons 
 	popd
}

function pack_image()
{
	PACK_IMAGE_PATH="$OUTPUT_DIR/milkv-duo256m"
	if [ ! -d $PACK_IMAGE_PATH ]; then
		echo "please check sdk output, and remember build the target firstly. Then try again"
		return 1
	fi
	
	if [[ "${BOARD_TYPE}" == "sd" ]] && [[ "${PACK_SDIMAGE_TOOL}" == genimage ]] ; then
		if [ -e "$BUILD_TOOLS/$PACK_SDIMAGE_TOOL" ] && [ -f "$BUILD_TOOLS/$PACK_SDIMAGE_TOOL" ]; then
			pushd ${PACK_IMAGE_PATH}
			mkdir -p fs
			if [ $? -ne 0 ]; then
				echo "Error: Failed to create directory '$PACK_IMAGE_PATH/fs'."
				return 1
			fi
			
			pushd ${BUILD_TOOLS}
	 		./$PACK_SDIMAGE_TOOL --config ${PACK_SD_INFO} --rootpath $PACK_IMAGE_PATH/fs/ --inputpath ${PACK_IMAGE_PATH} --outputpath ${PACK_IMAGE_PATH} --tmppath ${PACK_IMAGE_PATH}/tmp
	 		
			if [ $? -ne 0 ]; then
				echo "Please check the dependencies and requirements of pack SDimage tool, and try again!"
			fi
	 		
	 		popd
	 		
	 		if [ -d tmp ]; then
	 			rm -rf tmp
	 		fi
	 		
	 		if [ -d fs ]; then
	 			rm -rf fs
	 		fi
	 		popd
	 	else 
	 		echo "please check the pack SDimage tool, and try again"
			return 1
		fi
	fi
}

TC_RT_TYPE=$1

export DUO_SDK_DIR="$ROOT_DIR/duo-sdk"
export DUO_CMP_DIR="$DUO_SDK_DIR/toolchains/rt-$TC_RT_TYPE"

export BUILD_TOOLS="$DUO_SDK_DIR/tools"

if [[ "$TC_RT_TYPE" == "std" ]]; then
	TOOLCHAIN_TAR_NAME="Xuantie-900-gcc-elf-newlib-x86_64-V2.8.1-20240115.tar.gz"
	TOOLCHAIN_NAME="Xuantie-900-gcc-elf-newlib-x86_64-V2.8.1"
fi

if [ ! -d $DUO_CMP_DIR ]; then
    mkdir -p $DUO_CMP_DIR
	if [ $? -ne 0 ]; then
    	echo "Error: Failed to create directory '$DUO_CMP_DIR'."
    	return 1
	fi
fi

DUO_TOOLCHAIN="$DUO_CMP_DIR/$TOOLCHAIN_TAR_NAME"
DUO_TOOLCHAIN_DIR="$DUO_CMP_DIR/$TOOLCHAIN_NAME"

if [ ! -f $DUO_TOOLCHAIN ]; then
	if [[ "$TC_RT_TYPE" == "std" ]]; then
		wget -O $DUO_TOOLCHAIN "https://occ-oss-prod.oss-cn-hangzhou.aliyuncs.com/resource//1705395512373/$TOOLCHAIN_TAR_NAME"
    	if [ $? -ne 0 ]; then
    		echo "Please check the internet and try again"
    		return 1
		fi
	fi
fi

if [ ! -d $DUO_TOOLCHAIN_DIR ]; then
    tar -xzf $DUO_TOOLCHAIN -C $DUO_CMP_DIR
fi

export RT_ROOT_DIR="$ROOT_DIR/rt-thread"
export BSP_CVITEK_DIR="$RT_ROOT_DIR/bsp/cvitek"
export BIG_CORE_DIR="$BSP_CVITEK_DIR/cv18xx_risc-v"
export SMALL_CORE_DIR="$BSP_CVITEK_DIR/c906_little"

export OUTPUT_DIR="$ROOT_DIR/output"
if [ ! -d $OUTPUT_DIR ]; then
    mkdir -p $OUTPUT_DIR
	if [ $? -ne 0 ]; then
    	echo "Error: Failed to create directory '$OUTPUT_DIR'."
    	return 1
	fi
fi

if [[ "$TC_RT_TYPE" == "std" ]]; then
	export RTT_CC="gcc"
	export RTT_EXEC_PATH="$DUO_TOOLCHAIN_DIR/bin/"
	export RTT_CC_PREFIX="riscv64-unknown-elf-"
	export PATH="$RTT_EXEC_PATH:$PATH"
	export RTT_ROOT=$RT_ROOT_DIR
fi

export BUILD_BCORE_PATH="$DUO_SDK_DIR/build/device/${BOARD}_${BOARD_TYPE}/bkernel"
export BUILD_SCORE_PATH="$DUO_SDK_DIR/build/device/${BOARD}_${BOARD_TYPE}/skernel"

if [[ "${BOARD_TYPE}" == "sd" ]]; then
	export PACK_SD_INFO="$DUO_SDK_DIR/build/device/${BOARD}_${BOARD_TYPE}/genimage.cfg"
fi

print_usage


