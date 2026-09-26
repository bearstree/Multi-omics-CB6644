# Configuration

Fill the `gsm` and `srr` columns only after confirming the GEO/SRA mapping. Do not invent accessions. Set local genome index, annotation, chromosome-size, and output paths in `config.yaml`.

The manifest keeps unavailable samples for provenance. Workflow filters should use `available == true`; for ATAC this excludes GD765 by default.
