# sc-integration

Comparison of single-cell integration methods

[https://royfrancis.github.io/sc-integration/](https://royfrancis.github.io/sc-integration/)

## Usage

Computations were run on Uppmax Dardel cluster. A docker container with all necessary R/Python packages and quarto was initially prepared.

:warning: 17GB image!

```bash
docker pull ghcr.io/royfrancis/r44q15s5:1.0.4
```

The docker image is converted to a sif file locally on Dardel using `apptainer.def` definition file.

```bash
sbatch build.sh
```

The quarto document `index1.qmd` is run inside the container. The script used to run integration looks as shown below. This can be submitted as an SLURM job.

```bash
#!/bin/sh

#SBATCH -A naiss2024-XX-XXX
#SBATCH -p main
#SBATCH -n 1
#SBATCH -t 10:00:00
#SBATCH -J pan

module load PDC
module load apptainer

SIF="/cfs/klemming/projects/supr/naissxxxx-xx-xxx/roy/integration/r44q15s5-1.0.4.sif"
WD="/cfs/klemming/projects/supr/naissxxxx-xx-xxx/roy/integration"
workdir=$(python -c 'import tempfile; print(tempfile.mkdtemp())')
echo "container workdir: ${workdir}"
mkdir -p -m 700 ${workdir}/run ${workdir}/tmp ${workdir}/home
export APPTAINER_BIND="${workdir}/run:/run, ${workdir}/tmp:/tmp, ${workdir}/home:/cfs/klemming/home/r/$(id -un), /home/$(id -un):/userhome, ${WD}"

cd ${WD}/integration
ln -sf index1.qmd pan.qmd
apptainer run --cleanenv ${SIF} quarto render "pan.qmd" -o pan.html --to html --execute-dir ./pan -P label:pan -P batch:tech -P grp:celltype -P metrics_ilp:21 -P title:Panc8 -P subtitle:"Single-Cell Integration" -P description:"Comparison of different integration methods. Integration of 13 pancreatic celltypes from 5 different technologies."
```

A seurat v5 object named `obj.rds` must be made available inside execution directory (`--execute-dir ./pan` above).

## Reticulate & Python

Inside the container, in an R script, to use python module, set `PYTHONPATH` before loading reticulate.

```r
Sys.setenv(PYTHONPATH="/usr/lib/python3.10/site-packages")
library(reticulate)
import("scanpy")
```

---

2024 Roy Francis
