#!/bin/bash
## Build apptainer sif containers

#SBATCH -A naiss2024-22-345
#SBATCH -p core
#SBATCH -n 6
#SBATCH -t 4:00:00
#SBATCH -J bld-sif

starttime=`date +%s`

# set cache and temp directories to current wd
export APPTAINER_CACHEDIR=${PWD}/APPTAINER_CACHEDIR
export APPTAINER_TMPDIR=${PWD}/APPTAINER_TMPDIR
mkdir -p APPTAINER_CACHEDIR APPTAINER_TMPDIR

apptainer cache clean
apptainer build --force r44q15s5-1.0.4.sif apptainer.def

endtime=`date +%s`
echo "End of Script. Script took $(($endtime-$starttime)) seconds."
exit 0