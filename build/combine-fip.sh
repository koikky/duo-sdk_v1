#!/bin/bash
set -e

PROJECT_PATH=$1
IMAGE_PATH=$2

if [ -z "$PROJECT_PATH" ] || [ -z "$IMAGE_PATH" ]; then
	echo "Usage: $0 <PROJECT_DIR> <IMAGE_PATH>"
	exit 1
fi

CURRENT_PATH=$(pwd)
export OUT_PATH="$CURRENT_PATH/../../output"
TOOLS="$CURRENT_PATH/../tools"
echo ${OUT_PATH}

. function.sh

get_board_type
echo "board_type: ${BOARD_TYPE}"

export PREBUILT_PATH="$CURRENT_PATH/../prebuilt/${BOARD_TYPE}_${STORAGE_TYPE}"
echo "prebuilt_dir: ${PREBUILT_PATH}"

export BLCP_2ND_PATH=${IMAGE_PATH}
echo "BLCP_2ND_PATH: ${IMAGE_PATH}"

echo "Build already done, skip build"

if [ -e "$OUT_PATH/rtthread_score.bin" ] && [ -f "$OUT_PATH/rtthread_score.bin" ]; then
	do_combine
	if [ $? -ne 0 ]; then
		echo "Please check the prebuilt of duo, and try again!"
	fi
else 
	echo "Please check the output of small core, and try again!"
fi

if [ ! -d "${OUT_PATH}/${BOARD_TYPE}" ]; then
	mkdir -p ${OUT_PATH}/${BOARD_TYPE}
fi

if [ -e "${OUT_PATH}/rtthread_score.bin" ] && [ -f "${OUT_PATH}/rtthread_score.bin" ]; then
	mv "${OUT_PATH}/rtthread_score.bin" "${OUT_PATH}/${BOARD_TYPE}/rtthread_score.bin"
fi

mv ${OUT_PATH}/fip.bin ${OUT_PATH}/${BOARD_TYPE}/fip.bin
