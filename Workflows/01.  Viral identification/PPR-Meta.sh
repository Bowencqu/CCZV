#! /bin/bash
#SBATCH -J ppr-meta
#SBATCH --partition=frontier
#SBATCH --output=./%x_%a.out
#SBATCH --error=./%x_%a.err
#SBATCH --ntasks=60
#SBATCH --cpus-per-task=2
#SBATCH --get-user-env
#SBATCH --mail-type=ALL

##
source activate ppr-meta

##
export LD_LIBRARY_PATH="${LD_LIBRARY_PATH:+${LD_LIBRARY_PATH}:}\
/usr/local/MATLAB/MATLAB_Runtime/v94/runtime/glnxa64:\
/usr/local/MATLAB/MATLAB_Runtime/v94/bin/glnxa64:\
/usr/local/MATLAB/MATLAB_Runtime/v94/sys/os/glnxa64:\
/usr/local/MATLAB/MATLAB_Runtime/v94/extern/bin/glnxa64"

##
run_ppr_meta() {
    local h=$1
    local i=$2
    PPR_Meta "${i}" "${h}".ppr_meta_result.txt
}


while read -r h i; do
    {
    run_ppr_meta "$h" "$i"
    } &
done < site_contigs.list

wait