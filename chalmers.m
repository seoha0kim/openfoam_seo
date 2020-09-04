% -*- coding: utf-8 -*-
% ---
% jupyter:
%   jupytext:
%     formats: ipynb,m:percent
%     text_representation:
%       extension: .m
%       format_name: percent
%       format_version: '1.3'
%       jupytext_version: 1.5.2
%   kernelspec:
%     display_name: Matlab
%     language: matlab
%     name: matlab
% ---

% %% [markdown]
% # source

% %% [markdown]
%     cd /home/sbkim/Work/git
%     mkdir openfoam_seo
%     cd /home/sbkim
%     ln -s ~/Work/git/openfoam_seo OpenFOAM
%     cd ~/OpenFOAM

% %% [markdown]
%     wget https://sourceforge.net/projects/openfoam/files/v1912/OpenFOAM-v1912.tgz
%     wget https://sourceforge.net/projects/openfoam/files/v1912/ThirdParty-v1912.tgz
%     tar xzf OpenFOAM-v1912.tgz
%     tar xzf ThirdParty-v1912.tgz
%     # rm OpenFOAM-v1912.tgz ThirdParty-v1912.tgz
%
%     # module load buildenv-intel/2018a-eb;
%     # export MPI_ROOT=$I_MPI_ROOT;
%     export FOAM_INST_DIR=/home/sbkim/OpenFOAM;
%     # echo $FOAM_INST_DIR
%
%     . $FOAM_INST_DIR/OpenFOAM-v1912/etc/bashrc
%
%     # WM_COMPILER=Icc
%     # WM_MPLIB=INTELMPI
%
%     # WM_COMPILER=Gcc
%
%     # cp ~/OpenFOAM/addToBashrc ~/OpenFOAM/addToBashrc_old
%     # echo "
%     #     alias OFv1912='export MPI_ROOT=/software/sse/easybuild/prefix/software/impi/2018.1.163-iccifort-2018.1.163-GCC-6.4.0-2.28;
%     #     module load ParaView/5.4.1-nsc1-gcc-2018a-eb;
%     #     export FOAM_INST_DIR=~/OpenFOAM;
%     #     . $FOAM_INST_DIR/OpenFOAM-v1912/etc/bashrc
%     #     WM_COMPILER=Icc
%     #     WM_MPLIB=INTELMPI'
%     # " >> ~/OpenFOAM/addToBashrc
%     foam
%
%     echo $WM_NCOMPPROCS
%
%     # ./Allwmake >& log.make&
%     ./Allwmake -j -s -q -l >& log.make&

% %% [markdown]
% # docker

% %% [markdown]
% ## repository

% %% [markdown]
%     sudo apt-get remove docker docker-engine docker.io containerd runc
%     sudo apt-get update
%     sudo apt-get install \
%         apt-transport-https \
%         ca-certificates \
%         curl \
%         gnupg-agent \
%         software-properties-common
%     curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
%     sudo apt-key fingerprint 0EBFCD88
%     sudo add-apt-repository \
%        "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
%        $(lsb_release -cs) \
%        stable"

% %% [markdown]
% ## engine

% %% [markdown]
%     sudo apt-get update
%     sudo apt-get install docker-ce docker-ce-cli containerd.io

% %% [markdown]
% ## test

% %% [markdown]
%     sudo docker run hello-world

% %% [markdown]
% ##

% %% [markdown]
%     sudo groupadd docker
%     sudo usermod -aG docker $USER
% #    su -s ${USER}
%     newgrp docker

% %% [markdown]
%     - containers
%         docker ps -a
%         docker rn id
%
%     -images
%         docker images -a
%         docker rmi
%
%     docker system prune
%     docker system prune -a
%
%     docker images -f dangling=true
%     docker images purge
%
%     docker images -a |  grep "pattern"
%     docker images -a | grep "pattern" | awk '{print $3}' | xargs docker rmi
%
%     docker images -a
%     docker rmi $(docker images -a -q)
%
%     id
%     docker info

% %% [markdown]
% # chalmers

% %% [markdown]
%     chmod +x installOpenFOAM
%     ./installOpenFOAM
%     chmod +x startOpenFOAM
%     ./startOpenFOAM
%     . .bashrc

% %% [markdown]
%     User Guide
%     Tutorials Guide
%     Programmer’s Guide

% %% [markdown]
%     https://www.geeksforgeeks.org/c-plus-plus/

% %% [markdown]
% is first and foremost a C++ library, used primarily to create executables, known asapplications.
% - solvers: solve a specific continuum mechanics problem
% - utilities: data manipulation

% %% [markdown]
%     icoFoam : Transient solver for 
%         incompressible, laminar flow of Newtonian fluids
%         blockMesh
%         checkMesh
%         icoFoam >& log&
%         paraFoam
%

% %% [markdown]
%     0/ : initial condition
%     constant/ 
%         : transportPropertiesdictionary 
%         transportProperties : dictionary for dimensioned scalar nu
%             the kinematic viscosity
%         polyMesh/ : mesh
%             blockMeshDict (old) -> system/ (moved to)
%             boundary : inGroups: patchGroup
%                 - type
%                 - inGroups
%                 - nFaces
%                 - startFace
%             points
%             faces : internal first
%             owner : each faces s owner cell number
%                   : The face area vector is defined 
%                       to point out of the owner cell.
%             neighbour : The face area vector is defined 
%                 to point into the neighbour cell.

% %% [markdown]
%     system/ : run, discretization schemes, and solution procedures
%         blockMeshDict controlDict fvSchemes fvSolution PDRblockMeshDict
%         blockMeshDict
%             : used by blockMesh to generate 
%                 boundary, faces, neighbour, owner, points
%                 in constant/polyMesh
%             - convertToMeters
%             - vertices
%             - blocks
%                 hex : right-hand system
%                 vertices
%                 numer of mesh cells in each direction
%                 simpleGrading
%             - patches: boundary
%                 name: movingWall, fixedWalls, frontAndBack
%                 type: wall, empty
%                 faces: list of boundary faces
%             edges();
%                 - shaps of the edges which are not straight
%                 - polySpline, polyLine, line, simpleSpline, arc
%             mergePatchPairs();
%                 non-conformal meshes
%                 stitchMesh                
%         controlDict
%             - application icoFoam;
%             - deltaT
%             - purgeWrite 0; # in seperate directories
%
%             - writeCompression on;
%             - writeCompression binary: ?
%             - runTimeModifiable true;
%             
%             - adjustTimeStep on;
%                 based on max. Courant number
%                 
%             - writeControl adjustableRunTime;
%             
%             dummy
%             
%         fvSchemes : discretization schemes
%             - time marching scheme: ddtSchemes
%                 the first-order Euler implicit temporal discretization
%             - convection schemes: divSchemes            
%                 the second-order linear (central-difference) scheme
%             default none; means that 
%                 schemes must be explicitly specified.
%
%         fvSolution : solution procedure
%             how to solve each discretized linear equation system
%
%         PISO: pressure velocity coupling
%             $p : copy            

% %% [markdown]
% - p
%     - solver: PCG
%     - preconditioner: DIC
% - pFinal
%     - $p
%     - relTol 0; disable relTol
%         - PISO only solves each equation once per time step

% %% [markdown]
% - U
%     - solver: smoothSolver
%     - smoother: symGaussSeidel
%     - relTol 0; disable relTol
%         - PISO only solves each equation once per time step

% %% [markdown]
% # wtt

% %% [markdown]
%     ODA file converter : dwg -> dxf
%         https://www.opendesign.com/guestfiles/oda_file_converter
%     qt
%     # sudo apt-get install qt5-default
%     wget http://download.qt.io/official_releases/qt/5.14/5.14.2/qt-opensource-linux-x64-5.14.2.run
%     chmod +x qt-opensource-linux-x64-5.14.2.run
%     ./qt-opensource-linux-x64-5.14.2.run
%
%     echo $LD_LIBRARY_PATH
%     LD_LIBRARY_PATH=/home/sbkim/Qt5.14.2/Tools/QtCreator/lib/Qt/lib:$LD_LIBRARY_PATH
%     export LD_LIBRARY_PATH
%     echo $LD_LIBRARY_PATH

% %% [markdown]
% # FINE
