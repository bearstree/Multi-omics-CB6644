# GREAT and GSEA command guide

## Step 1: GREAT / CistromeGO

```bash
# Goal: convert significant differential peaks into hg38 BED files for region-based annotation.
# BED is hg38, zero-based, half-open; export significant up/down peaks separately.
awk -v OFS='\t' 'NR>1 && $8<0.01 && $7>1 {print $1,$2,$3,"peak_"NR,$8}' results/atac/differential/peaks.tsv > results/enrichment/CB6644_up.bed
# awk: export significant down-accessible hg38 peaks as BED.
awk -v OFS='\t' 'NR>1 && $8<0.01 && $7<-1 {print $1,$2,$3,"peak_"NR,$8}' results/atac/differential/peaks.tsv > results/enrichment/CB6644_down.bed
```

Upload each BED to GREAT with species `Human`, assembly `hg38`, and a stated whole-genome or tested-region background. Record the GREAT job URL and downloaded tables under `results/enrichment/great/`; do not treat region enrichment as proof of gene regulation.

```bash
# Goal: run ranked-list enrichment and collect tabular results.
# Optional CistromeGO/IGV inputs.
sort -k1,1 -k2,2n results/enrichment/CB6644_up.bed > results/enrichment/CB6644_up.sorted.bed
# igv.sh: inspect peak locations against normalized accessibility tracks.
igv.sh -g hg38 results/atac/bigwig/*.bw results/enrichment/CB6644_up.sorted.bed
```

## Step 2: Command-line GSEA

```bash
# gsea4lyfe_with_arguments.sh: run ranked-list enrichment against the selected gene sets.
./gsea4lyfe_with_arguments.sh results/rnaseq/deg/CB6644_vs_DMSO.rnk gene_sets.grp results/gsea/rnaseq
# getTsv.sh: convert GSEA result files into a tabular summary.
getTsv.sh results/gsea/rnaseq results/gsea/rnaseq.tsv
# BigBubblePlot.R: summarize multiple enrichment results visually.
Rscript BigBubblePlot.R results/gsea/rnaseq results/gsea/bubbleplot
```

## Portable R path

```r
# Goal: reproduce ranked-list enrichment with a portable R implementation.
library(fgsea)
library(msigdbr)
ranked <- read.delim("results/rnaseq/deg/CB6644_vs_DMSO.rnk", header=FALSE)
pathways <- split(msigdbr(species="Homo sapiens", category="H")$gene_symbol,
                  msigdbr(species="Homo sapiens", category="H")$gs_name)
fgsea(pathways=pathways, stats=setNames(ranked$V2, toupper(ranked$V1)))
```

Interpret NES direction relative to the ranked phenotype and report nominal P value plus FDR. The source deck uses |NES| >= 1.5 and FDR q <= 0.05 as an interpretation guide; keep those as reporting thresholds, not hidden filters.
