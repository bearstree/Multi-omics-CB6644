# Figure-to-workflow map

| Source figure | Workflow stage | Showcase section |
|---|---|---|
| `fig301_rnapipeline.png` | FASTQ QC -> genome alignment -> BAM -> transcript counts -> RPKM/edgeR -> DEGs -> GSEA | `docs/rnaseq.md`, `docs/enrichment.md` |
| `fig302_atacpipeline.png` | FASTQ QC -> Bowtie2/samtools -> BAM/BigWig -> MACS3 peaks -> peak counts -> differential accessible regions -> GREAT/CistromeGO | `docs/atacseq.md`, `docs/enrichment.md` |
| `fig303_mutipeakpipeline.png` | ATAC differential regions + RNA differential genes -> genes mapped to regions -> gene groups -> downstream enrichment | `docs/integration.md` |
| Deck p53 | Multi-peak analysis: differential peaks, expressed genes, region-to-gene mapping, gene groups, GREAT, TFEA, and DAVID | `docs/advanced_atac.md` |
| Deck p69-p76 | Motif analysis: summit extraction, hg38 sequence extraction, MEME, MEME-ChIP, and TOMTOM | `docs/advanced_atac.md` |
| Deck p86-p87 | TOBIAS-Snakemake ATAC-seq footprint analysis | `docs/advanced_atac.md` |

The figures are source references, not computed outputs from this repository.
