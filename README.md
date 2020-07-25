# Merging scaffolds from MaSuRCA (Illumina data) and wtdbg2 (PacBio data) using quickmerge

## Working directory

`dmachado@hpc.uncc.edu:/nobackup/echinotol/dmachado/20190821_phylobates/20190926_quickmerge`

## Path to the best PacBio assembly

`export SCF_PAC="/nobackup/echinotol/dmachado/20190821_phylobates/20190828_wtdbg2/output.ctg.fa"`

### Stats
- N50 = 17588
- sum = 1956265664
- N50/sum = 0.000008990598937
- sum/expected = 0.2173628516

## Path to the polished (arrow) PacBio assembly

`export POL_PAC="/nobackup/echinotol/dmachado/20190821_phylobates/20191003_arrow/pacbio_arrow.fasta"`

### Stats
- N50 = 17661
- sum = 1964601440 
- N50/sum = 0.000008989609618
- sum/expected = 0.2182890489

# Path to the best Illumina assembly

`export SCF_ILU="/projects/echinotol/pterribal1/genome.scf.fasta"`

### Stats

- N50 = 10552
- sum = 4217720247
- N50/sum = 0.000002501825484
- sum/expected = 0.468635583

## Quickmerge

### ip = Illumina + polished (arrow) PacBio

`nohup /users/dmachado/software/QUICKMERGE_3be7287/quickmerge/merge_wrapper.py -pre ip ${SCF_ILU} {$POL_PAC} > ip.o 2> ip.e &`

### ip + pi

```
sum = 4421339943, n = 1338766, ave = 3302.55, largest = 5752821
N50 = 11003, n = 132255
N60 = 9241, n = 176454
N70 = 8278, n = 227144
N80 = 5754, n = 291228
N90 = 1362, n = 409945
N100 = 64, n = 1338766
N_count = 2094671241
Gaps = 1561429
```

### pi + ip (best so far)

```
sum = 1964673591, n = 138106, ave = 14225.84, largest = 156059
N50 = 17661, n = 34756
N60 = 14596, n = 46996
N70 = 11989, n = 61846
N80 = 9565, n = 80195
N90 = 7080, n = 103959
N100 = 1495, n = 138106
N_count = 47992
Gaps = 28
```

# Final

Scaffolds (polished with Arrow) produced with WTDBG2 (using PacBio reads) and MaSuRCA (using Illumina reads) were merged using quickmerge (specifically with the helper script `merge_wrapper.py`) in a number of iterations.

After the final merging iteration, the best-merged scaffold file was selected based on the highest N50. We used a homemade Python script (`poolAfterQuickmerge.py`) to re-read and extract all scaffolds from the reference assembly (second FASTA file fed to `merge_wrapper.py`) that were not aligned to the query assembly (first FASTA file fed to `merge_wrapper.py`). These scaffolds were concatenated with the selected merged scaffolds to produce a final scaffolds FASTA file.

The general assembly statistics of the final scaffolds files are as follows:

```
stats for final_merge.fasta
sum = 6030018660, n = 1457551, ave = 4137.09, largest = 492848
N50 = 11998, n = 160092
N60 = 10057, n = 214735
N70 = 8638, n = 279857
N80 = 6601, n = 357246
N90 = 3732, n = 469966
N100 = 64, n = 1457551
N_count = 2032820625
Gaps = 1478340
```

The N50/sum is 1.989711919e-6. The sum/size is 0.6700020733 (using the expected genome size of 9e9).
