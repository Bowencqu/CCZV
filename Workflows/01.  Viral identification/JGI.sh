#! /bin/bash
#SBATCH -J JGI
#SBATCH --partition=frontier
#SBATCH --output=./%x_%a.out
#SBATCH --error=./%x_%a.err
#SBATCH --get-user-env
#SBATCH --ntasks=60
#SBATCH --cpus-per-task=2
#SBATCH --mail-type=ALL

##
source activate JGI

##
run_anno() {
    local i=$1
    python annotate_assembled_contigs.py --assembled_contigs $i --pfam_db ../reference_files/Pfam-A.hmm --viral_hmm ../reference_files/viral_reference_model.hmm --out_folder ../annotated_contigs/
}


while read -r i; do
    {
    run_anno "$i"
    } &
done < contigs.list

wait

##
dir1="/home/Bowen/03.Database/viruses/JGI/earth-virome-pipeline/annotated_contigs/"
dir2="/home/Bowen/03.Database/viruses/JGI/earth-virome-pipeline/annotated_contigs/"
dir3="/home/Bowen/14.FN/02.Assembly/03.contig/"
dir4="/home/Bowen/03.Database/viruses/JGI/earth-virome-pipeline/annotated_contigs/"
output="merged_table.txt"

##
> $output

##
for file1 in "$dir1"/*5kb_genes_in_scafs_formatted_hits_to_vHMMs.hmmout; do
    sample=$(basename "$file1" "_5kb_genes_in_scafs_formatted_hits_to_vHMMs.hmmout")
    file2="$dir2/${sample}_5kb_genes_in_scafs_formatted.fa"
    file3="$dir3/${sample}_contigs.fa"
    file4="$dir4/${sample}_5kb_genes_in_scafs.pfam.txt"

    if [[ -f "$file2" && -f "$file3" && -f "$file4" ]]; then
        echo -e "$file1\t$file2\t$file3\t$file4" >> "$output"
    else
        echo "⚠️  Warning: Missing file(s) for sample $sample" >&2
    fi
done

echo "✅ Done. Output saved to $output"

##
run_filter() {
    local h=$1
    local i=$2
    local j=$3
    local k=$4
    filter_viral_contigs_master_table.py --hmmout_file $h --genes_fasta $i --assembly_fasta $j --pfam $k --out ../filter_contigs/
}


while read -r h i j k; do
    {
    run_filter "$h" "$i" "$j" "$k"
    } &
done < merged_table.txt

wait