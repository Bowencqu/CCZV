#! /bin/bash
#SBATCH -J genomad
#SBATCH --partition=frontier
#SBATCH --output=./%x_%a.out
#SBATCH --error=./%x_%a.err
#SBATCH --get-user-env
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mail-type=ALL

##
source activate geNomad

##
genomad annotate ../08.cluster/vOTU.fa genomad_output /home/Bowen/03.Database/viruses/genomad/genomad_db -t 10