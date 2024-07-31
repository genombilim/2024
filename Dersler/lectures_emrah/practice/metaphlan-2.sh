#!/bin/bash

#SBATCH --job-name=metaphlan
#SBATCH --partition=barbun
#SBATCH --ntasks-per-node=4
#SBATCH --output=slurm-%j.out
#SBATCH --error=slurm-%j.err

SAMPLE=$1

metaphlan data/${SAMPLE}.fasta.gz \
    --input_type fasta \
    --bowtie2db /truba/home/egitim/Workshop_emrah/databases/metaphlan_3.0/ \
    -x mpa_v30_CHOCOPhlAn_201901 \
    --bowtie2out results/metaphlan/${SAMPLE}.bowtie2 \
    -s results/metaphlan/${SAMPLE}.sam > results/metaphlan/${SAMPLE}.txt