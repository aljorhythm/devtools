#!/bin/bash
set -x #echo on

sh '01_install_softwares.sh'
sh '02_install_packages.sh'
sh '03_set_up_bash_profile.sh'