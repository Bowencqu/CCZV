#! /bin/bash
#SBATCH -J dvf
#SBATCH --partition=frontier
#SBATCH --output=./%x_%a.out
#SBATCH --error=./%x_%a.err
#SBATCH --get-user-env
#SBATCH --ntasks=60
#SBATCH --cpus-per-task=2
#SBATCH --mail-type=ALL

##
source activate dvf

##
run_dvf() {
    local i=$1
    dvf.py -i "${i}" -c 2
}


while read -r i; do
    {
    run_dvf "$i"
    } &
done < contigs.list

##
wait