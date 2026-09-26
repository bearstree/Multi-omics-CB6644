# RNA/ATAC integration command guide

## Step 1: Peak-to-gene links

```bash
# Goal: associate significant peaks with nearby or promoter-overlapping genes.
# bedtools closest: assign each peak to the nearest hg38 gene.
bedtools closest -a results/atac/differential/CB6644_up.bed -b references/hg38_genes.bed -d > results/integration/up_peak_gene.tsv
# bedtools intersect: link peaks overlapping hg38 promoter intervals.
bedtools intersect -wa -wb -a results/atac/differential/CB6644_up.bed -b references/hg38_promoters.bed > results/integration/up_promoter_links.tsv
```

## Step 2: Merge RNA and ATAC evidence

```bash
# integrate_rna_atac.R: merge RNA differential expression with ATAC-linked genes.
Rscript scripts/integrate_rna_atac.R \
  results/rnaseq/deg/CB6644_vs_DMSO.tsv \
  results/atac/differential/peaks.tsv \
  results/integration/up_peak_gene.tsv \
  results/integration/rna_atac_concordance.tsv
```

The output should retain gene, peak, RNA log2FC/FDR, ATAC log2FC/FDR, link method, and direction class. Proximity links are hypotheses, not causal assignments.

## Step 3: Downstream groups

```bash
# Export groups for GSEA/TFEA/DAVID after identifier normalization.
# awk: export genes with concordant down regulation/accessibility.
awk -F'\t' 'NR>1 && $NF=="concordant_down" {print toupper($1)}' results/integration/rna_atac_concordance.tsv > results/integration/concordant_down.grp
```
