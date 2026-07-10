
#! /bin/bash
#SBATCH -J VIBRANT
#SBATCH --partition=frontier
#SBATCH --output=./%x_%a.out
#SBATCH --error=./%x_%a.err
#SBATCH --get-user-env
#SBATCH --ntasks=60
#SBATCH --cpus-per-task=2
#SBATCH --mail-type=ALL


##
source activate VIBRANT

##
run_VIBRANT() {
    local i=$1
    /home/Bowen/02.biosoft/VIBRANT/VIBRANT_run.py -i "${i}" -t 2
}


while read -r i; do
    {
    run_VIBRANT "$i"
    } &
done < contigs.list

wait