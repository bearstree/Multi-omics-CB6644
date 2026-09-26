rule integration_documented_outputs:
    input:
        "config/samples.tsv"
    output:
        touch("results/integration/README.txt")
    shell:
        "touch {output}"
