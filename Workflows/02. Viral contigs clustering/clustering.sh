#! /bin/bash
#SBATCH -J blastn
#SBATCH --partition=frontier
#SBATCH --output=./%x_%a.out
#SBATCH --error=./%x_%a.err
#SBATCH --get-user-env
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=10
#SBATCH --mail-type=ALL

##
makeblastdb -in ./virus_checkv.fa -dbtype nucl -out ./virus_db

##
blastn -query virus_checkv.fa -db ./virus_db -out blast.tsv -outfmt '6 std qlen slen' -max_target_seqs 25000 -perc_identity 90 -task megablast -num_threads 10

##
python anicalc.py -i ./blast.tsv -o ani.tsv

##
python aniclust.py --fna ./virus_checkv.fa --ani ani.tsv --out clusters.tsv --min_ani 95 --min_qcov 0 --min_tcov 85

##
cat clusters.tsv | awk '{print $1}' > vOTU.list

##
seqkit grep -f ./vOTU.list ./virus_checkv.fa > vOTU.fa