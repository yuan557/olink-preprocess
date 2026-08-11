import os


def _run_dir(wildcards):
    for run in config["runs"]:
        if run["run_id"] == wildcards.run_id:
            return run["run_dir"]
    raise ValueError(f"run_id '{wildcards.run_id}' not found in config")


rule ngs2counts:
    output:
        metadata = config["counts_base_dir"] + "/{run_id}/run_metadata.json",
        done     = config["counts_base_dir"] + "/{run_id}/.ngs2counts.done",
    params:
        bin        = config["ngs2counts_bin"],
        run_dir    = _run_dir,
        out_dir    = lambda wc: os.path.join(config["counts_base_dir"], wc.run_id),
        run_units  = config["run_units_flag"],
        split_flag = lambda wc: "--split-by-library" if config.get("split_by_library") else "",
    resources:
        mem_mb        = 65536,
        runtime       = 30,
        cpus_per_task = 1,
    log:
        "logs/ngs2counts/{run_id}.log",
    shell:
        """
        set -euo pipefail
        export OLINK_LOG_LEVEL=debug
        mkdir -p {params.out_dir}
        {params.bin} {params.run_dir} \
            --output-dir {params.out_dir} \
            --run-units {params.run_units} \
            {params.split_flag} \
            > {log} 2>&1
        touch {output.done}
        """
