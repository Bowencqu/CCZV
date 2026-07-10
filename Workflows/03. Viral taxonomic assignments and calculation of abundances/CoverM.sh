#! /bin/bash
#SBATCH -J coverm
#SBATCH --partition=frontier
#SBATCH --output=./%x_%a.out
#SBATCH --error=./%x_%a.err
#SBATCH --get-user-env
#SBATCH --ntasks=60
#SBATCH --cpus-per-task=7
#SBATCH --mail-type=ALL

##bwa
run_bwa() {
    local h=$1
    local i=$2
    local j=$3
    bwa mem -t 7 03.index/vOTU "${i}" "${j}"  >14.sam/"${h}".sam
}


while read -r h i j; do
    {
    run_bwa "$h" "$i" "$j"
    } &
done < site_cleanreads.list

wait

##samTobam
cd 14.sam

ls * >site_sam.list

##
run_bam() {
    local i=$1
    samtools sort -@ 7 -m 50G -O bam -o ../15.bam/"${i}".bam "${i}" 
    

}

while read -r i ; do
    {
    run_bwa "$i"
    } &
done < site_sam.list

wait

#coverm

source activate coverm

cd 15.bam

for i in * ;do coverm contig -t 7 -b $i -m rpkm ---min-covered-fraction 70 --trim-min 0.10 --trim-max 0.90 --min-read-percent-identity 0.95 --min-read-aligned-percent 0.90  >../16.coverm/${i}.quant.txt ;done