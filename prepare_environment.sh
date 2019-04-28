#!/bin/bash
echo "This will prepare the host machine with all the libraries needed"
echo "to run the UHD Framework"
echo "################################################################"
sudo add-apt-repository ppa:ettusresearch/uhd
sudo apt-get update -y
sudo apt-get install libuhd-dev libuhd003 uhd-host -y
echo "Process has finished. Now is time for you to build the project"
echo "###############################################################"
