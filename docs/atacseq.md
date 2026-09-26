# ATAC-seq command guide

Inputs: confirmed paired-end FASTQ, an hg38 Bowtie2 index, chromosome sizes, and available ATAC samples. GD765 remains in the manifest for provenance but is excluded by default.

## Step 1: Chipseq-pipeline -> BAM/BED files

```bash
# Goal: assess read quality, align reads to hg38, remove low-quality/duplicate reads, and create tracks.
# FastQC: assess read quality, adapter content, and sequence-level artifacts.
fastqc data/fastq/SAMPLE_R1.fastq.gz data/fastq/SAMPLE_R2.fastq.gz --outdir results/atac/fastqc
# MultiQC: combine per-sample QC reports.
multiqc results/atac/fastqc -o results/atac/multiqc
# bowtie2: align paired-end ATAC reads to hg38.
bowtie2 -x /path/to/hg38/bowtie2 -1 data/fastq/SAMPLE_R1.fastq.gz -2 data/fastq/SAMPLE_R2.fastq.gz -p 16 | samtools view -b -q 30 -f 2 -F 1804 | samtools sort -@ 8 -o work/atac/SAMPLE.sorted.bam
# samtools markdup: remove duplicate fragments.
samtools markdup -r work/atac/SAMPLE.sorted.bam work/atac/SAMPLE.nodup.bam
# samtools index: enable random access to the filtered BAM.
samtools index work/atac/SAMPLE.nodup.bam
# bamCoverage: create a normalized BigWig track for IGV.
bamCoverage -b work/atac/SAMPLE.nodup.bam -o results/atac/bigwig/SAMPLE.bw --normalizeUsing CPM
```

Documented command path:

```bash
# chipseq_pipline_PE_v2: run the documented paired-end alignment and filtering pipeline.
/path_to_scripts/chipseq_pipline_PE_v2 SAMPLE_R1.fastq.gz SAMPLE_R2.fastq.gz results/atac/SAMPLE 32 500 hg38norand
```

## Step 2: Call peaks: steps to get count matrix

```bash
# Goal: call accessible regions and build a shared peak count matrix.
# MACS3: call accessible chromatin peaks from aligned ATAC fragments.
macs3 callpeak -t work/atac/SAMPLE.nodup.bam -f BAMPE -g hs -n SAMPLE --outdir results/atac/peaks --qvalue 0.05
# bedtools multiinter: combine sample peaks into a shared consensus region set.
bedtools multiinter -i results/atac/peaks/*.narrowPeak | awk 'BEGIN{OFS="\t"} {print $1,$2,$3,"peak_"NR,$4}' > results/atac/peaks/consensus.bed
# featureCounts: count ATAC fragments over consensus peaks.
featureCounts -T 8 -p -a results/atac/peaks/consensus.saf -o results/atac/counts/peak_counts.txt work/atac/*.nodup.bam
# edgeR wrapper: test differential accessibility.
Rscript scripts/edger_atac.R results/atac/counts/peak_counts.txt config/samples.tsv results/atac/differential
# MDS_atac.R: visualize peak-level sample distances.
Rscript MDS_atac.R results/atac/counts/peak_counts.txt results/atac/plots/mds.pdf
# maplot_updated.R: create an MA plot for differential peaks.
Rscript maplot_updated.R results/atac/differential/CB6644_vs_DMSO.txt
```

Documented command path:

```bash
# CreateRefPeaks: merge individual peak calls into a reference peak set.
/path_to_scripts/CreateRefPeaks treatment_peaks.broadPeak control_peaks.broadPeak reference_peaks.bed 2
# tagcountCalculator_v1.1: count reads from each sample in each reference peak.
/path_to_scripts/tagcountCalculator_v1.1 reference_peaks.bed SAMPLE_A.bed SAMPLE_B.bed CB6644_A CB6644_B peakcounts.txt
# edger_example_group.R: test treatment-associated peak changes.
Rscript edger_example_group.R
```

## Step 3: MDS/PCA plot

```bash
# Goal: check sample-level separation and replicate consistency.
Rscript MDS_atac.R peakcounts.txt CB6644_A CB6644_B DMSO_A DMSO_B
```

## Step 4: edgeR differential accessible regions

```bash
# Goal: test treatment-associated changes in peak accessibility.
Rscript edger_example_group.R
```

## Step 5: MA plot

```bash
# Goal: visualize average accessibility versus differential accessibility.
Rscript maplot_updated.R expressed_peak_q005_ma.txt
```

## Step 6: GREAT/CistromeGO and IGV

```bash
# Goal: interpret significant hg38 regions and inspect representative loci.
sort -k1,1 -k2,2n results/enrichment/CB6644_up.bed > results/enrichment/CB6644_up.sorted.bed
igv.sh -g hg38 results/atac/bigwig/*.bw results/enrichment/CB6644_up.sorted.bed
```

Export hg38 BED3/BED6 up/down regions before GREAT.
