#!/bin/sh

#
#
#
https://www.geeksforgeeks.org/c-plus-plus/

#
# docker
#
    1. repository
    sudo apt-get remove docker docker-engine docker.io containerd runc
    sudo apt-get update
    sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        gnupg-agent \
        software-properties-common
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-key fingerprint 0EBFCD88
    sudo add-apt-repository \
       "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
       $(lsb_release -cs) \
       stable"

    2. engine
    sudo apt-get update
    sudo apt-get install docker-ce docker-ce-cli containerd.io

    3. test
    sudo docker run hello-world

    4.
    sudo groupadd docker
    sudo usermod -aG docker $USER
    newgrp docker

    5.
    - containers
        docker ps -a
        docker rn id

    -images
        docker images -a
        docker rmi

    docker system prune
    docker system prune -a

    docker images -f dangling=true
    docker images purge

    docker images -a |  grep "pattern"
    docker images -a | grep "pattern" | awk '{print $3}' | xargs docker rmi

    docker images -a
    docker rmi $(docker images -a -q)


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
