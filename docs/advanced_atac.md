# Multi-peak, motif, and TOBIAS analysis

These steps correspond to p53, p69-p76, and p86-p87 of `Friday_weekly_meeting_07072022_CB_DMSO_RPMI8226.pptx`.

## Step 1: Multi-peak analysis: regions mapped to genes

```bash
# Goal: map differential ATAC peaks to nearby hg38 genes.
bedtools closest -a results/atac/differential/CB6644_up.bed -b references/hg38_genes.bed -d > results/multipeak/up_peak_genes.tsv
# Goal: count mapped differential regions per gene.
awk -F'\t' '{count[$NF]++} END {for (gene in count) print gene,count[gene]}' results/multipeak/up_peak_genes.tsv > results/multipeak/up_gene_peak_counts.tsv
# Goal: create the group with at least three mapped regions.
awk '$2>=3 {print $1}' results/multipeak/up_gene_peak_counts.tsv > results/multipeak/group1_regions_ge3.grp
# Goal: create the group with one or two mapped regions.
awk '$2>=1 && $2<3 {print $1}' results/multipeak/up_gene_peak_counts.tsv > results/multipeak/group2_regions_1_2.grp
```

## Step 2: Multi-peak downstream enrichment

```bash
# Goal: test functional enrichment using multi-peak genes as foreground and expressed genes as background.
Rscript /path_to_scripts/DAVID_query_test.R results/multipeak/group1_regions_ge3.grp results/rnaseq/expressed_genes.grp
# Goal: test transcription-factor enrichment for multi-peak genes.
Rscript /path_to_scripts/TFEA.R results/multipeak/group1_regions_ge3.grp results/rnaseq/expressed_genes.grp
```

## Step 3: Motif analysis: summit sequences

```bash
# Goal: extract summit regions from differential ATAC peaks.
/path_to_scripts/extractSummits_v2 results/atac/differential/CB6644_up.bed results/motif/CB6644_up_summits.bed
# Goal: extract hg38 DNA sequence for each summit.
bedtools getfasta -fi /path/to/hg38.fa -bed results/motif/CB6644_up_summits.bed -fo results/motif/CB6644_up_summits.fa
# Goal: discover enriched motifs in summit sequences.
meme-chip -oc results/motif/meme_chip results/motif/CB6644_up_summits.fa
# Goal: compare discovered motifs with known transcription-factor motifs.
tomtom -oc results/motif/tomtom results/motif/meme_chip/meme.txt /path/to/motif_database.meme
```

## Step 4: TOBIAS-Snakemake footprint analysis

```bash
# Goal: create the TOBIAS-Snakemake environment.
conda env create -f /path_to_scripts/TOBIAS_snakemake/environment.yml
# Goal: correct ATAC signal for Tn5 insertion bias.
TOBIAS ATACorrect --bam work/atac/SAMPLE.nodup.bam --genome /path/to/hg38.fa --peaks results/atac/peaks/consensus.bed --outdir results/tobias/ATACorrect
# Goal: calculate transcription-factor footprint scores.
TOBIAS FootprintScores --signal results/tobias/ATACorrect/SAMPLE_corrected.bw --regions references/tfbs.bed --output results/tobias/footprints/SAMPLE_footprints.bw
# Goal: compare motif-associated footprint signals across samples.
TOBIAS BINDetect --motifs /path/to/motifs.jaspar --signals results/tobias/ATACorrect/*.bw --peaks results/atac/peaks/consensus.bed --outdir results/tobias/BINDetect
# Goal: preview the Snakemake workflow without running jobs.
snakemake --snakefile /path_to_scripts/TOBIAS_snakemake/Snakefile --configfile config/config.yaml --cores 16 --dry-run
```
