#!/bin/bash

# assemble.sh generated by masurca
CONFIG_PATH="path/to/file"
CMD_PATH="path/to/file"
set -o pipefail

# Test that we support <() redirection
(eval "cat <(echo test) >/dev/null" 2>/dev/null) || {
  echo >&2 "ERROR: The shell used is missing important features."
  echo >&2 "       Run the assembly script directly as './$0'"
  exit 1
}

# Parse command line switches
while getopts ":rc" o; do
  case "${o}" in
    c)
    echo "configuration file is '$CONFIG_PATH'"
    exit 0
    ;;
    r)
    echo "Rerunning configuration"
    exec perl "$CMD_PATH" "$CONFIG_PATH"
    echo "Failed to rerun configuration"
    exit 1
    ;;
    *)
    echo "Usage: $0 [-r] [-c]"
    exit 1
    ;;
  esac
done
set +e
# Set some paths and prime system to save environment variables
save () {
  (echo -n "$1=\""; eval "echo -n \"\$$1\""; echo '"') >> environment.sh
}
GC=
RC=
NC=
if tty -s < /dev/fd/1 2> /dev/null; then
  GC='\e[0;32m'
  RC='\e[0;31m'
  NC='\e[0m'
fi
log () {
  d=$(date)
  echo -e "${GC}[$d]${NC} $@"
}
fail () {
  d=$(date)
  echo -e "${RC}[$d]${NC} $@"
  exit 1
}
signaled () {
  fail Interrupted
}
trap signaled TERM QUIT INT
rm -f environment.sh; touch environment.sh

# To run tasks in parallel
#run_bg () {
#  semaphore -j $NUM_THREADS --id masurca_$$ -- "$@"
#}
#run_wait () {
#  semaphore -j $NUM_THREADS --id masurca_$$ --wait
#}
export PATH="path/to/file"
save PATH
export PERL5LIB=/apps/pkg/masurca/3.3.4/rhel7_u5/gnu/bin/../lib/perl${PERL5LIB:+:$PERL5LIB}
save PERL5LIB
NUM_THREADS=64
save NUM_THREADS
log 'Processing pe library reads'
rm -rf meanAndStdevByPrefix.pe.txt
echo 'pa 300 35' >> meanAndStdevByPrefix.pe.txt
echo 'pb 300 35' >> meanAndStdevByPrefix.pe.txt
echo 'pc 300 35' >> meanAndStdevByPrefix.pe.txt
log 'Processing sj library reads'
rm -rf meanAndStdevByPrefix.sj.txt
echo 'ma 500 100' >> meanAndStdevByPrefix.sj.txt
echo 'mb 500 100' >> meanAndStdevByPrefix.sj.txt
echo 'mc 500 100' >> meanAndStdevByPrefix.sj.txt
echo 'md 500 100' >> meanAndStdevByPrefix.sj.txt

head -q -n 40000  pa.renamed.fastq pb.renamed.fastq pc.renamed.fastq | grep --text -v '^+' | grep --text -v '^@' > pe_data.tmp
export PE_AVG_READ_LENGTH=`awk '{if(length($1)>31){n+=length($1);m++;}}END{print int(n/m)}' pe_data.tmp`
save PE_AVG_READ_LENGTH
log Average PE read length $PE_AVG_READ_LENGTH
KMER=`for f in pa.renamed.fastq pb.renamed.fastq pc.renamed.fastq;do head -n 80000 $f |tail -n 40000;done | perl -e 'while($line=<STDIN>){$line=<STDIN>;chomp($line);push(@lines,$line);for($i=0;$i<6;$i++){$line=<STDIN>;}}$min_len=100000;$base_count=0;foreach $l(@lines){$base_count+=length($l);push(@lengths,length($l));@f=split("",$l);foreach $base(@f){if(uc($base) eq "G" || uc($base) eq "C"){$gc_count++}}} @lengths =sort {$b <=> $a} @lengths; $min_len=$lengths[int($#lengths*.75)];  $gc_ratio=$gc_count/$base_count;$kmer=0;if($gc_ratio>=0.35 && $gc_ratio<=0.6){$kmer=int($min_len*.66);}else{$kmer=int($min_len*.33);} $kmer++ if($kmer%2==0); $kmer=31 if($kmer<31); $kmer=127 if($kmer>127); print $kmer'`
save KMER
log Using kmer size of $KMER for the graph
KMER_J=31
save KMER_J
MIN_Q_CHAR=`cat pa.renamed.fastq pb.renamed.fastq pc.renamed.fastq |head -n 50000 | awk 'BEGIN{flag=0}{if($0 ~ /^\+/){flag=1}else if(flag==1){print $0;flag=0}}'  | perl -ne 'BEGIN{$q0_char="@";}{chomp;@f=split "";foreach $v(@f){if(ord($v)<ord($q0_char)){$q0_char=$v;}}}END{$ans=ord($q0_char);if($ans<64){print "33\n"}else{print "64\n"}}'`
save MIN_Q_CHAR
log MIN_Q_CHAR: $MIN_Q_CHAR
JF_SIZE=`ls -l *.fastq | awk '{n+=$5}END{s=int(n/50); if(s>180000000000)printf "%.0f",s;else print "180000000000";}'`
save JF_SIZE
perl -e '{if(int('$JF_SIZE')>180000000000){print "WARNING: JF_SIZE set too low, increasing JF_SIZE to at least '$JF_SIZE', this automatic increase may be not enough!\n"}}'



if [ -s ESTIMATED_GENOME_SIZE.txt ];then
ESTIMATED_GENOME_SIZE=`head -n 1 ESTIMATED_GENOME_SIZE.txt`
else
log Estimating genome size
export ESTIMATED_GENOME_SIZE=`jellyfish histo -t 64 -h 1 k_u_hash_0 | tail -n 1 |awk '{print $2}'`
echo $ESTIMATED_GENOME_SIZE > ESTIMATED_GENOME_SIZE.txt
fi
save ESTIMATED_GENOME_SIZE
log "Estimated genome size: $ESTIMATED_GENOME_SIZE"



log 'Computing super reads from PE '
CA_DIR="CA";
/apps/pkg/masurca/3.3.4/rhel7_u5/gnu/bin/mega_reads_assemble_cluster.sh  -E SGE  -Pb 300000000 -q all.q -G 0 -C 25 -t 64 -e $ESTIMATED_GENOME_SIZE -m work1 -a /apps/pkg/masurca/3.3.4/rhel7_u5/gnu/bin/../CA8/Linux-amd64/bin -o "  ma.cor.clean.frg mb.cor.clean.frg mc.cor.clean.frg md.cor.clean.frg  cgwErrorRate=0.12"  -B 17 -D 0.029 -p /projects/echinotol/dmachado/190203_pacbiodata/pteriibelis_pacbio_concat.fa 
CA_DIR=`cat CA_dir.txt`
if [ ! -d $CA_DIR ];then
  fail "mega-reads exited before assembly"
fi
TERMINATOR="9-terminator"
if [ -s $CA_DIR/9-terminator/genome.scf.fasta ];then
  NSCF=`grep --text '^>'  $CA_DIR/9-terminator/genome.scf.fasta |wc -l`
  NCTG=`grep --text '^>'  $CA_DIR/9-terminator/genome.ctg.fasta |wc -l`
  if [ $NCTG -eq $NSCF ];then
    log 'No gap closing possible'
  else
    TERMINATOR="10-gapclose"
    if [ -s $CA_DIR/10-gapclose/genome.scf.fasta ];then
      log 'Gap closing done'
    else
      log 'Gap closing'
      closeGapsLocally.perl --max-reads-in-memory 1000000000 -s 180000000000 --Celera-terminator-directory $CA_DIR/9-terminator --reads-file 'pa.renamed.fastq' --reads-file 'pb.renamed.fastq' --reads-file 'pc.renamed.fastq' --reads-file 'ma.renamed.fastq' --reads-file 'mb.renamed.fastq' --reads-file 'mc.renamed.fastq' --reads-file 'md.renamed.fastq' --output-directory $CA_DIR/10-gapclose --min-kmer-len 17 --max-kmer-len $(($PE_AVG_READ_LENGTH-5)) --num-threads 64 --contig-length-for-joining $(($PE_AVG_READ_LENGTH-1)) --contig-length-for-fishing 200 --reduce-read-set-kmer-size 21 1>gapClose.err 2>&1
      if [[ -e "$CA_DIR/10-gapclose/genome.ctg.fasta" ]];then
        log 'Gap close success'
      else
        fail Gap close failed, you can still use pre-gap close files under $CA_DIR/9-terminator/. Check gapClose.err for problems.
      fi
    fi
  fi
else
  fail "Assembly stopped or failed, see $CA_DIR.log"
fi
if [ -s $CA_DIR/$TERMINATOR/genome.scf.fasta ];then
  if [ ! -e $CA_DIR/filter_map.contigs.success ];then
  log 'Removing redundant scaffolds'
    PLOIDY=`cat PLOIDY.txt`
    deduplicate_contigs.sh $CA_DIR genome 64 $PLOIDY $TERMINATOR && log "Assembly complete, final scaffold sequences are in $CA_DIR/final.genome.scf.fasta"
  else
  log "Assembly complete, final scaffold sequences are in $CA_DIR/final.genome.scf.fasta"
  fi
else
  fail "Assembly stopped or failed, see $CA_DIR.log"
fi
log 'All done'
log "Final stats for $CA_DIR/final.genome.scf.fasta"
ufasta n50 -A -S -C -E -N50 $CA_DIR/final.genome.scf.fasta