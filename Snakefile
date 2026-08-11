from dotenv import load_dotenv
import os

load_dotenv()

configfile: "config/config.yaml"
configfile: "config/project.yaml"

config["project_name"] = os.environ["PROJECT_NAME"]
config["dar_id"] = os.environ["DAR_ID"]

include: "workflow/rules/ngs2counts.smk"
include: "workflow/rules/npx_create.smk"
include: "workflow/rules/npx_export.smk"

RUN_IDS = [run["run_id"] for run in config["runs"]]


rule all:
    input:
        config["npx_output_dir"] + "/.done"
