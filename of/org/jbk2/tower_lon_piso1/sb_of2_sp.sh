#!/bin/sh
# nohup nice -n -20 potentialFoam > log.potentialFoam
nohup nice -n -19 simpleFoam >& log.simpleFoam &