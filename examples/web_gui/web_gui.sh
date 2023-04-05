#!/bin/bash

#*******************************************************************************************#
#*----- AUTHOR :        Aubertin Emmanuel               |  FOR: LLAMA Web GUI           ****#
#*----- CONTACT :       https://athomisos.fr                                            ****#
#*----- DESCRIPTION :   Launcher of the web GUI                                         ****#
#*******************************************************************************************#

PROGNAME="LLAMA Web GUI"
RELEASE="Revision 1.0"
AUTHOR="(c) 2021 Aubertin Emmanuel"
DEBUG=0

# Functions plugin usage
print_release() {
    echo "$RELEASE $AUTHOR"
}

print_usage() {
        echo ""
        echo "$PROGNAME"
        echo ""
        echo "Usage: $PROGNAME | [-h | --help] | [-v | --version] | [-d | --debug]"
        echo ""
        echo "          -h  Aide"
        echo "          -v  Version"
        echo ""
        echo "This project is a web ui for llama.cpp"
}

print_help() {
        print_release $PROGNAME $RELEASE
        echo ""
        print_usage
        echo ""
        echo ""
                exit 0
}

build_model_7B(){
    cd ../..
    python3 convert-pth-to-ggml.py models/7B/ 1
    ./quantize ./models/7B/ggml-model-f16.bin ./models/7B/ggml-model-q4_0.bin 2
    ./main -m ./models/7B/ggml-model-q4_0.bin -n 128

}

while [ $# -gt 0 ]; do
    case "$1" in
        -h | --help)
            print_help
            exit 
            ;;
        -v | --version)
            print_release
            exit 
            ;;
        -b | --build)
            build_model_7B
            ;;                           
        *)  echo "Unkown argument: $1"
            print_usage
            ;;
        esac
shift
done

echo "#### CHECKING FOR DEP"
echo "## LLAMA DEP"
python3 -m pip install torch numpy sentencepiece

echo "LLAMA DEP OK"
echo "## WEB GUI DEP"
# dep of react to put here

echo "#### CHECKING LLAMA ENV"
result=$(find "../../models" -type d -name "*B")
if [[ ! -n $result ]]
then 
    echo "No models detected in models/, you may have at least one model."
    exit -1
fi

