#!/bin/bash
set -x #echo on

sh '01 install_softwares.sh'
sh '02 install_packages.sh'
sh '03 set_up_bash_profile.sh'