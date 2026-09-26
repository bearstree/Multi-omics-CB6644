# RNA-seq command guide

Inputs: confirmed GSM/SRR accessions, FASTQ, an hg38 index, and a GENCODE hg38 GTF. Outputs go under `results/rnaseq/`.

## Step 1: GSM/SRR to FASTQ

```bash
# Goal: retrieve accession data and verify file integrity before analysis.
# Confirm the GSM -> SRR mapping before running.
# prefetch: download the accession container from SRA.
prefetch SRR_ACCESSION --output-directory data/sra
# fasterq-dump: convert the SRA container into FASTQ reads.
fasterq-dump data/sra/SRR_ACCESSION/SRR_ACCESSION.sra --split-files --threads 8 --outdir data/fastq
# gzip: compress FASTQ files for storage and downstream tools.
gzip data/fastq/SRR_ACCESSION*.fastq
# sha256sum: create checksums for file-integrity checks.
sha256sum data/fastq/SRR_ACCESSION*.fastq.gz > data/fastq/SRR_ACCESSION.sha256
```

Documented command path:

```bash
# Goal: retrieve and prepare the source reads with the documented wrapper.
bash download_SRRs_from_GSM.sh GSM_ACCESSION
```

## Step 2: QC and alignment

```bash
# Goal: inspect read quality, trim adapters, align reads, and create sorted/indexed BAM files.
# FastQC: assess per-read quality, base-quality decay, and adapter/overrepresented-sequence signals.
fastqc data/fastq/SAMPLE_R1.fastq.gz data/fastq/SAMPLE_R2.fastq.gz --outdir results/rnaseq/fastqc
# MultiQC: combine per-sample QC reports for comparison.
multiqc results/rnaseq/fastqc -o results/rnaseq/multiqc
# fastp: trim adapters and low-quality bases and summarize read filtering.
fastp -i data/fastq/SAMPLE_R1.fastq.gz -I data/fastq/SAMPLE_R2.fastq.gz -o work/rnaseq/SAMPLE_R1.trim.fastq.gz -O work/rnaseq/SAMPLE_R2.trim.fastq.gz --html results/rnaseq/fastp/SAMPLE.html
# STAR: align cleaned reads to the hg38 genome.
STAR --genomeDir /path/to/hg38/star --readFilesIn work/rnaseq/SAMPLE_R1.trim.fastq.gz work/rnaseq/SAMPLE_R2.trim.fastq.gz --readFilesCommand zcat --runThreadN 16 --outFileNamePrefix work/rnaseq/SAMPLE.
# samtools sort: coordinate-sort the alignment file for indexing and counting.
samtools sort -@ 8 -o results/rnaseq/bam/SAMPLE.bam work/rnaseq/SAMPLE.Aligned.out.sam
# samtools index: create random-access BAM indexes for visualization and tools.
samtools index results/rnaseq/bam/SAMPLE.bam
```

Documented command path:

```bash
# fastq2bam.R: run the documented alignment-to-BAM wrapper.
Rscript fastq2bam.R SAMPLE_R1.fastq.gz SAMPLE_R2.fastq.gz hg38
```

## Step 3: Counts, DEGs, and plots

```bash
# featureCounts: summarize aligned reads over annotated genes.
featureCounts -T 8 -p -a /path/to/gencode.vXX.annotation.gtf -o results/rnaseq/counts/gene_counts.txt results/rnaseq/bam/*.bam
# featurecounts.R: run the documented count-table wrapper.
Rscript featurecounts.R results/rnaseq/bam results/rnaseq/counts/gene_counts.txt
# filterIDS.R: remove unusable identifiers and retain analyzable genes.
Rscript filterIDS.R results/rnaseq/counts/gene_counts.txt results/rnaseq/counts/gene_counts.filtered.txt
# edgeR wrapper: normalize counts and test CB6644 versus DMSO.
Rscript scripts/edger_rnaseq.R results/rnaseq/counts/gene_counts.filtered.txt config/samples.tsv results/rnaseq/deg
# MDS.R: visualize sample distances and replicate structure.
Rscript MDS.R results/rnaseq/counts/gene_counts.filtered.txt results/rnaseq/plots/mds.pdf
```

Use raw counts, exclude unavailable samples, define `CB6644 - DMSO`, and export `results/rnaseq/deg/CB6644_vs_DMSO.rnk` for GSEA. Thresholds come from `config/config.yaml`.
