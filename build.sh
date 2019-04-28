#!/bin/bash
# IDU MIHAI - April.2019
# This is a automation way to build the software


function build_soft {
	echo "###############################"
	echo "The compile process has started"
	REPOPATH=$PWD
	mkdir build
	cd $PWD/build
	sudo cmake .. > ../logs/cmake.log 2>&1
	sudo make > ../logs/make.log 2>1&
	echo "###############################"
	echo "The process has finished"
	echo "###############################"
}
build_soft
