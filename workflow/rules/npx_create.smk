rule generate_input_json:
    input:
        counts_done   = expand(
            config["counts_base_dir"] + "/{run_id}/.ngs2counts.done",
            run_id=[run["run_id"] for run in config["runs"]],
        ),
        plate_layouts = list(config["plate_layouts"].values()),
    output:
        "data/tmp/input.json",
    script:
        "../scripts/generate_input_json.py"


rule npx_project_create:
    input:
        input_json    = "data/tmp/input.json",
        panel_archive = config["panel_data_archive"],
    output:
        config["project_dir"] + "/project.oep",
    params:
        sif         = config["npx_map_sif"],
        project_dir = config["project_dir"],
        name        = config["project_name"],
        dar_id      = config["dar_id"],
    resources:
        mem_mb        = 32768,
        runtime       = 60,
        cpus_per_task = 4,
    log:
        "logs/npx_project_create.log",
    envmodules:
        config["apptainer_module"],
    shell:
        """
        set -euo pipefail
        mkdir -p {params.project_dir}
        apptainer run {params.sif} project create \
            -i {input.input_json} \
            -o {params.project_dir} \
            --name {params.name} \
            --dar-id {params.dar_id} \
            --panel-data-archive {input.panel_archive} \
            > {log} 2>&1
        """
