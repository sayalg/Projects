#!/usr/bin/bash

##
# PREAMBLE
##

export WD="path/to/file"
cd ${WD}
printf "Working directory: ${WD}\n"
printf "Start date: `date`\n"

##
# LOAD MOLDULES
##

module load pacbio samtools
module list

##
# VARIABLES
##

export RAW_PACBIO="path/to/file"
export RAW_PACBIO_BAM="path/to/file"
export SCAFFOLDS="path/to/file"
export THREADS=24

##
# DEF FUNCTIONS
##

function run_align {
printf "Running pbalign... [ `date` ]\n"
pbalign --nproc=${THREADS} ${RAW_PACBIO_BAM} ${SCAFFOLDS} ${WD}/pacbio_mapped.bam
wait
}

function make_index {
printf "Running samtools... [ `date`]\n"
samtools faidx ${SCAFFOLDS}
wait
}

function run_arrow {
printf "Running arrow... [ `date` ]\n"
arrow ${WD}/pacbio_mapped.bam -j ${THREADS} -r ${SCAFFOLDS} -o pacbio_arrow.fasta -o pacbio_arrow.gff -o pacbio_arrow.fastq
wait
}

##
# EXEC FUNCTIONS
##

printf ">>> run_align: `date`\n\n"
run_align
printf ">>> make_index: `date`\n\n"
# make_index
printf ">>> run_arrow: `date`\n\n"
# run_arrow

##
# QUIT
##

printf "End date: `date`\n"

exit
