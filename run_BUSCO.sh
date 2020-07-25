#!/usr/bin/bash

# BUSCO's default configuration file is available at
# /apps/pkg/busco-3.0.2/rhel7_u2-x86_64/gnu/config/config.ini.
# You can set the BUSCO_CONFIG_FILE environment variable to define a
# custom path (including the filename) to the config.ini file, useful
# for switching between configurations or in a multi-users environment.

##
# Load necessary modules
##
module load augustus/3.3
module load blast/2.3.0+
module load busco/3.0.2
module list

##
# Variables
##

export AUGUSTUS_CONFIG_PATH="path/to/file"
export BUSCO_CONFIG_FILE="path/to/file"
export ILLUMINA="path/to/file"
export PACBIO="path/to/file"
export NCORES=16
export DB="path/to/file"
export MT="path/to/file"
export MERGED="path/to/file"

##
# Define functions
##

function main {
run_BUSCO.py -i ${ILLUMINA} -c ${NCORES} -e 1e-05 -m genome --limit 3 -sp human -l ${DB} -o busco_illumina
wait
run_BUSCO.py -i ${PACBIO}   -c ${NCORES} -e 1e-05 -m genome --limit 3 -sp human -l ${DB} -o busco_pacbio
wait
}

function merged {
run_BUSCO.py -i ${MERGED}   -c ${NCORES} -e 1e-05 -m genome --limit 3 -sp human -l ${DB} -o busco_merged
wait
}


function sensitivity {
run_BUSCO.py -i ${MERGED} -c 4 -e 1e-3 -m genome --limit 3 --long -sp human      -l ${DB} -o busco_human_tetrapoda   &
run_BUSCO.py -i ${MERGED} -c 4 -e 1e-3 -m genome --limit 3 --long -sp human      -l ${MT} -o busco_human_metazoa     &
run_BUSCO.py -i ${MERGED} -c 4 -e 1e-3 -m genome --limit 3 --long -sp fly        -l ${DB} -o busco_fly_tetrapoda     &
run_BUSCO.py -i ${MERGED} -c 4 -e 1e-3 -m genome --limit 3 --long -sp fly        -l ${MT} -o busco_fly_metazoa       &
run_BUSCO.py -i ${MERGED} -c 4 -e 1e-3 -m genome --limit 3 --long -sp sealamprey -l ${DB} -o busco_sealamprey_tetrapoda &
run_BUSCO.py -i ${MERGED} -c 4 -e 1e-3 -m genome --limit 3 --long -sp sealamprey -l ${MT} -o busco_sealamprey_metazoa
wait
}

##
# Define functions
##

# main
# merged
sensitivity
exit
