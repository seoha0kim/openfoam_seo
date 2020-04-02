#!/bin/sh

#
# docker
#



#
# source
#

cd /home/sbkim/Work/git
mkdir openfoam_seo
cd /home/sbkim
ln -s ~/Work/git/openfoam_seo OpenFOAM
cd ~/OpenFOAM

wget https://sourceforge.net/projects/openfoam/files/v1912/OpenFOAM-v1912.tgz
wget https://sourceforge.net/projects/openfoam/files/v1912/ThirdParty-v1912.tgz
tar xzf OpenFOAM-v1912.tgz
tar xzf ThirdParty-v1912.tgz
# rm OpenFOAM-v1912.tgz ThirdParty-v1912.tgz

# module load buildenv-intel/2018a-eb;
# export MPI_ROOT=$I_MPI_ROOT;
export FOAM_INST_DIR=/home/sbkim/OpenFOAM;
# echo $FOAM_INST_DIR

. $FOAM_INST_DIR/OpenFOAM-v1912/etc/bashrc

# WM_COMPILER=Icc
# WM_MPLIB=INTELMPI

# WM_COMPILER=Gcc

# cp ~/OpenFOAM/addToBashrc ~/OpenFOAM/addToBashrc_old
# echo "
#     alias OFv1912='export MPI_ROOT=/software/sse/easybuild/prefix/software/impi/2018.1.163-iccifort-2018.1.163-GCC-6.4.0-2.28;
#     module load ParaView/5.4.1-nsc1-gcc-2018a-eb;
#     export FOAM_INST_DIR=~/OpenFOAM;
#     . $FOAM_INST_DIR/OpenFOAM-v1912/etc/bashrc
#     WM_COMPILER=Icc
#     WM_MPLIB=INTELMPI'
# " >> ~/OpenFOAM/addToBashrc
foam

echo $WM_NCOMPPROCS

# ./Allwmake >& log.make&
./Allwmake -j -s -q -l >& log.make&
