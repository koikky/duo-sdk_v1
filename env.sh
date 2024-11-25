#!/bin/bash

function print_usage()
{
  printf "  -------------------------------------------------------------------------------------------------------\n"
  printf "  \033[31m Hello, this is Duo_sdk.\033[94m We can help you build RT-Threads.\033[93m Here's how to use\033[0m \n"
  printf "    Usage:\n"
  printf "    (1)\33[94m Menuconfig \33[0m- Use menu to configure\033[31m kernel and components\33[0m of RT-Threads.\n"
  printf "        ### There are two kinds of commands.\033[93m 1.-->for the big one of cores\33[0m ;\033[31m 2.-->for the small one of cores\33[0m \n"
  printf "        1. bone_menuconfig \n"
  printf "        2. sone_menuconfig \n\n"
  printf "    (2)\33[96m Build \33[0m- Build RT-Thread includes the kernel and components.\n"
  printf "        ### There are two kinds of commands.\033[93m 1.-->for the big one of cores\33[0m ;\033[31m 2.-->for the small one of cores\33[0m \n"
  printf "        1. make_bcore \n"
  printf "        2. make_score \n\n"
  printf "    (3)\33[92m Pack \33[0m- Pack all into a image.\n"
  printf "        1. pack_image \n\n"
  printf "   ## You can type\033[95m help\033[0m into the terminal to get more information:D \n"
  printf "   ## ex: $ help \n\n"
  printf "   \033[91m Tips: the board's hardware configuration is default !!\033[0m \n"
  printf "  -------------------------------------------------------------------------------------------------------\n"
}

function print_err_choice()
{
  printf "  ------------------------------------------------------------------------------\n"
  printf "  \033[31m Input error:\033[0m \n"
  printf "  	###The first parameter is\033[94m the model of Duo\033[0m, and the second parameter is\033[94m the version of the RT-Thread !\033[0m \n"
  printf "  	###Models of duo can be \033[93mduo\033[0m,\033[93m duo256m\033[0m,\033[93m duos\033[0m ; Versions of RT-Thread can be\033[93m std\033[0m,\033[93m smart\033[0m.\n"
  printf "  	ex: source duo-sdk/env.sh duo256m std \n\n"
  printf "  ------------------------------------------------------------------------------\n"
}

function help()
{
  printf "  -------------------------------------------------------------------------------------------------------\n"
  printf "  \033[31m Hello, this is Duo_sdk.\033[94m We can help you build RT-Threads.\033[93m Here's how to use\033[0m \n"
  printf "    Usage:\n"
  printf "    (1)\33[94m Menuconfig \33[0m- Use menu to configure\033[31m kernel and components\33[0m of RT-Threads.\n"
  printf "        ### There are two kinds of commands.\033[93m 1.-->for the big one of cores\33[0m ;\033[31m 2.-->for the small one of cores\33[0m \n"
  printf "        1. bone_menuconfig \n"
  printf "        2. sone_menuconfig \n\n"
  printf "    (2)\33[96m Build \33[0m- Build RT-Thread includes the kernel and components.\n"
  printf "        ### There are two kinds of commands.\033[93m 1.-->for the big one of cores\33[0m ;\033[31m 2.-->for the small one of cores\33[0m \n"
  printf "        1. make_bcore \n"
  printf "        2. make_score \n\n"
  printf "    (3)\33[92m Pack \33[0m- Pack all into a image.\n"
  printf "        1. pack_image \n\n"
  printf "   \033[91m Tips: the board's hardware configuration is default !!\033[0m \n\n"
  printf "   \033[93m In addition, you also need to pay attention to the following content.\033[0m \n"
  printf "    (1) # To execute these commands, you need to go to the previous directory in the duo-sdk directory.\n"
  printf "    (2) # The RT-Thread directory needs to be in the peer directory of duo-sdk.\n"
  printf "    (3) # Note that when you first build RT-Thread using the duo-sdk, you will need to connect to the network, as some tools will be downloaded.\n"
  printf "    (4) # When using the duo-sdk, you need to select the model of duo, which needs to be same with model you selected when menuconfig RT-thread.\n"
  printf "    (5) # Similarly, versions of RT-Thread need to be consistent.\n"
  printf "  -------------------------------------------------------------------------------------------------------\n"
}


BOARD_NAME=("duo" "duo256m" "duos")
RT_EXTEND=("std" "smart")

PARAM1=$1
PARAM2=$2

check_first_param=false
for element in "${BOARD_NAME[@]}"; do
    if [[ "$PARAM1" == "$element" ]]; then
        check_first_param=true
        break
    fi
done

check_second_param=false
for element in "${RT_EXTEND[@]}"; do
    if [[ "$PARAM2" == "$element" ]]; then
        check_second_param=true
        break
    fi
done

if [[ "$check_first_param" == false ]] || [[ "$check_second_param" == false ]]; then
    print_err_choice
    return 1
fi

BOARD_MODEL="${PARAM1}"
RT_TYPE="${RT_EXTEND}"

CURRENT_DIR=$(dirname $(readlink -f "$0")）
export ROOT_DIR="${CURRENT_DIR}/.."

TMP_DIR="$CURRENT_DIR/build"

source "$TMP_DIR/device/${BOARD_MODEL}_sd/boardconfig.sh"
source "$TMP_DIR/build.sh" $RT_TYPE

