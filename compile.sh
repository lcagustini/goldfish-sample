#!/bin/bash

PROJECT=goldfish-sample

mkdir -p build

if [[ $* == *--build* ]]; then
    cd build && cmake .. && cmake --build . && cd ..
fi

# OS specific variables
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    echo "[OS] Linux"
    TARGET="./build/${PROJECT}"
    DLLS=""
elif [[ "$OSTYPE" == "cygwin" ]] || [[ "$OSTYPE" == "msys" ]]; then
    echo "[OS] Windows"
    TARGET="./build/${PROJECT}.exe"
    DLLS=`ldd ${TARGET} | grep ucrt64 | cut -d " " -f 3`
else
    echo "[OS] Unsupported"
    exit 1
fi

if [[ $* == *--dll* ]]; then
    if [ -z "$DLLS" ]; then
        echo "No DLL to copy"
    else
        echo "Copying DLLs..."
        cp $DLLS build/
    fi
fi

if [[ $* == *--zip* ]]; then
    zip -j ./build/standalone.zip $DLLS $TARGET
    zip -r ./build/standalone.zip assets/
fi

if [[ $* == *--run* ]]; then
    $TARGET
elif [[ $* == *--debug* ]]; then
    gdb $TARGET
fi
