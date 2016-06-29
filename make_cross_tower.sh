#!/bin/bash

BASEDIR=`pwd`

mkdir go
cd go

export GOPATH=`pwd`

mkdir -p $GOPATH/src
mkdir -p $GOPATH/pkg
mkdir -p $GOPATH/bin


go get -d github.com/supcik-go/ws2811
cd $GOPATH/src/github.com/supcik-go/ws2811

git clone https://github.com/jgarff/rpi_ws281x.git

cd rpi_ws281x
patch -i $BASEDIR/01_cross.patch

export CC=arm-linux-gnueabihf-gcc
export CXX=arm-linux-gnueabihf-g++
export LD=arm-linux-gnueabihf-g++
export AR=arm-linux-gnueabihf-ar
export STRIP=arm-linux-gnueabihf-strip

scons

cd ..
export CGO_ENABLED=1
export GOOS=linux
export GOARCH=arm
export CC_FOR_TARGET=arm-linux-gnueabihf-gcc
export CXX_FOR_TARGET=arm-linux-gnueabihf-g++

export CPATH=$GOPATH/src/github.com/supcik-go/ws2811/rpi_ws281x
export LIBRARY_PATH=$GOPATH/src/github.com/supcik-go/ws2811/rpi_ws281x

# sudo -E go install std
patch -i $BASEDIR/02_go.patch
# go build

cd $GOPATH
go get -d github.com/heia-fr/telecom-tower-server

cd $GOPATH/src/github.com/heia-fr/telecom-tower-server
go build --tags physical
# go install --tags physical

file $GOPATH/src/github.com/heia-fr/telecom-tower-server/telecom-tower-server
