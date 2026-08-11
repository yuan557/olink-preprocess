rule npx_project_export:
    input:
        project_oep   = config["project_dir"] + "/project.oep",
        panel_archive = config["panel_data_archive"],
    output:
        done = config["npx_output_dir"] + "/.done",
    params:
        sif         = config["npx_map_sif"],
        project_dir = config["project_dir"],
        output_dir  = config["npx_output_dir"],
    resources:
        mem_mb        = 32768,
        runtime       = 60,
        cpus_per_task = 4,
    log:
        "logs/npx_export.log",
    envmodules:
        config["apptainer_module"],
    shell:
        """
        set -euo pipefail
        mkdir -p {params.output_dir}
        apptainer run {params.sif} project export \
            -i {params.project_dir} \
            -o {params.output_dir} \
            --panel-data-archive {input.panel_archive} \
            --extended-npx-csv \
            --npx-csv \
            --analysis-report \
            > {log} 2>&1
        touch {output.done}
        """
