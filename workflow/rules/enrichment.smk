rule enrichment_documented_outputs:
    input:
        "config/config.yaml"
    output:
        touch("results/enrichment/README.txt")
    shell:
        "touch {output}"
