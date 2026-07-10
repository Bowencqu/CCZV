#! /bin/bash
#SBATCH -J virsorter2
#SBATCH --partition=frontier
#SBATCH --output=./%x_%a.out
#SBATCH --error=./%x_%a.err
#SBATCH --get-user-env
#SBATCH --ntasks=60
#SBATCH --cpus-per-task=5
#SBATCH --mail-type=ALL

##
run_virsorter() {
    local h=$1
    local i=$2
    virsorter run --keep-original-seq -w "${h}" -i "${i}" --include-groups "dsDNAphage,ssDNA" --min-score 0.5 -j 5
}


while read -r h i; do
    {
    run_virsorter "$h" "$i"
    } &
done < site_contigs.list

wait