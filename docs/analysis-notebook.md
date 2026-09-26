# Analysis checklist

1. Confirm GSM/SRR mappings and populate `config/samples.tsv`.
2. Confirm hg38 indexes, GTF, chromosome sizes, and thresholds in `config/config.yaml`.
3. Follow `docs/rnaseq.md` for RNA-seq FASTQ, counts, DEGs, PCA/MDS, and `.rnk` output.
4. Follow `docs/atacseq.md` for ATAC-seq alignment, peaks, differential accessibility, and BED output.
5. Follow `docs/enrichment.md` for GREAT and GSEA.
6. Follow `docs/integration.md` for peak-to-gene links and concordance groups.
7. Preview the graph with `snakemake -n -s workflow/Snakefile`; this repository does not execute the jobs.
