rule atacseq_documented_outputs:
    input:
        "config/samples.tsv"
    output:
        touch("results/atac/README.txt")
    shell:
        "touch {output}"
