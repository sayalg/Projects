#!/usr/bin/bash

# Running quickmerge

export POL_PAC="path/to/file"
export SCF_ILU="path/to/file"
export PATH="path/to/file"

function preliminary {
merge_wrapper.py -pre ip ${SCF_ILU} ${POL_PAC}
wait
merge_wrapper.py -pre pi ${POL_PAC} ${SCF_ILU}
wait
}

function merging_merges {
merge_wrapper.py -pre ippi merged_ip.fasta merged_pi.fasta
wait
merge_wrapper.py -pre piip merged_pi.fasta merged_ip.fasta
wait
}

# preliminary
merging_merges

exit
