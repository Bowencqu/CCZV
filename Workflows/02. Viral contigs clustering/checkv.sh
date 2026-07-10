#! /bin/bash
#SBATCH -J checkv
#SBATCH --partition=frontier
#SBATCH --output=./%x_%a.out
#SBATCH --error=./%x_%a.err
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=30
#SBATCH --get-user-env
#SBATCH --mail-type=ALL
source activate checkv
#full pipeline
checkv end_to_end /home/Bowen/14.FN_7988/03.taxonomy/01.identified/06.putative_viruses/putative_virues.fa . -t 30