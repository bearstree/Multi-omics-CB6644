rule rnaseq_documented_outputs:
    input:
        "config/samples.tsv"
    output:
        touch("results/rnaseq/README.txt")
    shell:
        "touch {output}"
