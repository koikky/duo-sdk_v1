#/bin/sh
set -e

PROJECT_PATH=$1
IMAGE_NAME=$2

if [ -z "$PROJECT_PATH" ] || [ -z "$IMAGE_NAME" ]; then
	echo "Usage: $0 <PROJECT_DIR> <IMAGE_NAME>"
	exit 1
fi

CURRENT_PATH=$(pwd)
OUT_PATH="$CURRENT_PATH/../../output"
TOOLS="$CURRENT_PATH/../tools"
echo ${OUT_PATH}

. function.sh

get_board_type

echo "start compress kernel..."

lzma -c -9 -f -k ${IMAGE_NAME} > ${PROJECT_PATH}/dtb/${BOARD_TYPE}/Image.lzma

if [ ! -d "${OUT_PATH}/${BOARD_TYPE}" ]; then
	mkdir -p ${OUT_PATH}/${BOARD_TYPE}
fi

if [ -e "${OUT_PATH}/rtthread_bcore.bin" ] && [ -f "${OUT_PATH}/rtthread_bcore.bin" ]; then
	mv "${OUT_PATH}/rtthread_bcore.bin" "${OUT_PATH}/${BOARD_TYPE}/rtthread_bcore.bin"
fi

pushd $TOOLS
./mkimage -f ${PROJECT_PATH}/dtb/${BOARD_TYPE}/multi.its -r ${OUT_PATH}/${BOARD_TYPE}/boot.${STORAGE_TYPE}
popd

#if [ "${STORAGE_TYPE}" == "spinor" ] || [ "${STORAGE_TYPE}" == "spinand" ]; then
#	
#	check_bootloader || exit 0
#
#	pushd cvitek_bootloader
#	
#	. env.sh
#	get_build_board ${BOARD_TYPE}
#	
#	CHIP_ARCH_L=$(echo $CHIP_ARCH | tr '[:upper:]' '[:lower:]')
#
#	echo "board: ${MV_BOARD_LINK}"
#	
#	IMGTOOL_PATH=build/tools/common/image_tool
#	FLASH_PARTITION_XML=build/boards/"${CHIP_ARCH_L}"/"${MV_BOARD_LINK}"/partition/partition_"${STORAGE_TYPE}".xml
#	python3 "$IMGTOOL_PATH"/raw2cimg.py "${ROOT_PATH}"/output/"${BOARD_TYPE}"/boot."$STORAGE_TYPE" "${ROOT_PATH}/output/${BOARD_TYPE}" "$FLASH_PARTITION_XML"
#
#	popd
#fi
