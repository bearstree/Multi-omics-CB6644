# CB6644 Multi-omics Showcase

Command-first RNA-seq and ATAC-seq analysis for RPMI8226/MM.1S multiple-myeloma cells treated with CB6644 versus DMSO.

## Dataset

- RNA-seq: GD830-GD835; CB6644 40 nM, 72 hours versus DMSO.
- ATAC-seq: treatment GD773/GD774/GD762; DMSO GD763/GD764; GD765 unavailable and excluded by default.
- Genome build: hg38.

## Workflow

1. [RNA-seq](docs/rnaseq.md): GSM/SRR -> FASTQ -> QC -> alignment -> counts -> DEGs -> ranked GSEA file.
2. [ATAC-seq](docs/atacseq.md): FASTQ -> QC -> BAM/BED -> peaks -> peak counts -> differential accessibility.
3. [GREAT and GSEA](docs/enrichment.md): differential peaks and ranked genes -> functional enrichment.
4. [RNA/ATAC integration](docs/integration.md): differential peaks -> genes -> concordance groups.
5. [Multi-peak, motif, and TOBIAS](docs/advanced_atac.md): p53, p69-p76, and p86-p87 analyses from the source deck.

## Configuration

Confirm accessions in [config/samples.tsv](config/samples.tsv), then set genome paths and thresholds in [config/config.yaml](config/config.yaml).

## Scope

Commands are documented but not executed here. Do not commit sequencing files, alignments, generated results, or genome references.

## Related Publication

Molecular Signatures of CB-6644 Inhibition of the RUVBL1/2 Complex in Multiple Myeloma (https://www.mdpi.com/1422-0067/25/16/9022)
