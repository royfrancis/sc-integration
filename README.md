# sc-integration

Comparison of single-cell integration methods

[https://royfrancis.github.io/sc-integration/](https://royfrancis.github.io/sc-integration/)

## Usage

Computations were run on Uppmax Rackham cluster. A docker container with all necessary R/Python packages and quarto was initially prepared.

:warning: 17GB image!

```bash
docker pull ghcr.io/royfrancis/r44q15s5:1.0.3
```

The docker image was converted to singularity sif file locally.

```bash
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v $(pwd):/work kaczmarj/apptainer build r44q15s5-1.0.3.sif docker://ghcr.io/royfrancis/r44q15s5:1.0.3
```

The sif file was upload to Uppmax. The quarto document `index1.qmd` is run inside the container. The script used to run integration looks as shown below. This can be submitted as an SLURM job.

```bash
#!/bin/sh

#SBATCH -A naiss2024-XX-XXX
#SBATCH -p node
#SBATCH -n 1
#SBATCH -t 10:00:00
#SBATCH -J pan

SIF="/crex/proj/snic2022-XX-XXX/nobackup/roy/integration/r44q15s5-1.0.3.sif"
WD="/crex/proj/snic2022-XX-XXX/nobackup/roy/integration"
workdir=$(python -c 'import tempfile; print(tempfile.mkdtemp())')
echo "container workdir: ${workdir}"
mkdir -p -m 700 ${workdir}/run ${workdir}/tmp ${workdir}/home
export APPTAINER_BIND="${workdir}/run:/run, ${workdir}/tmp:/tmp, ${workdir}/home:/home/$(id -un), /home/$(id -un):/userhome, ${WD}"

cd ${WD}/integration
ln -sf index1.qmd pan.qmd
apptainer run --cleanenv ${SIF} quarto render "pan.qmd" -o pan.html --to html --execute-dir ./pan -P label:pan -P batch:tech -P grp:celltype -P metrics_ilp:21 -P title:Panc8 -P subtitle:"Single-Cell Integration" -P description:"Comparison of different integration methods. Integration of 13 pancreatic celltypes from 5 different technologies."
```

A seurat v5 object named `obj.rds` must be made available inside execution directory (`--execute-dir ./pan` above).

## Reticulate & Python

Inside the container, in an R script, to use python module, set `PYTHONPATH` before loading reticulate.

```r
Sys.setenv(PYTHONPATH="/home/rstudio/.local/lib/python3.10/site-packages")
library(reticulate)
import("scanpy")
```

---

2024 Roy Francis
