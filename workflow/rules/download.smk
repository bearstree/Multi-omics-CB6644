rule fetch_sra:
    output:
        touch("results/download/README.txt")
    shell:
        "touch {output}"
