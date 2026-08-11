# olink_preprocess

Snakemake workflow for Olink NGS proteomics preprocessing.

Converts raw Illumina BCL/CBCL sequencing data to NPX values via two steps:
1. `ngs2counts` - barcode counting per run
2. `npx-map-cli` - project creation and NPX export

## Prerequisites

- Snakemake >= 8 with `snakemake-executor-plugin-slurm`
- `python-dotenv` (for `.env` loading)
- Access to `ngs2counts` binary and `npx-map-cli.sif` (Olink software, not included)
- Apptainer module on the cluster

Install Python dependencies into your environment:
```
pip install snakemake snakemake-executor-plugin-slurm python-dotenv
```

## Setup

1. Copy and fill in the secret/path files:
   ```
   cp .env.example .env
   cp config/project.yaml.example config/project.yaml
   ```
   Edit `.env` with your project name and DAR ID.
   Edit `config/project.yaml` with your tool paths, plate layouts, and run directories.

2. Adjust workflow parameters in `config/config.yaml` if needed (product type, normalization, etc.).

## Running

Dry run to check the workflow DAG:
```
snakemake --profile profiles/slurm -n
```

Full run on SLURM:
```
snakemake --profile profiles/slurm
```

## Outputs

| Path | Description |
|---|---|
| `data/counts/{run_id}/` | Olink barcode counts + run metadata |
| `data/tmp/input.json` | Auto-generated npx-map-cli project input |
| `data/project/` | NPX project bundle (`.oep`) |
| `results/npx/` | NPX CSV, extended NPX CSV, analysis report PDF |

## Note on Olink software

`ngs2counts` and `npx-map-cli` are proprietary Olink tools. They are not included in this repository and must not be redistributed. Point `config/project.yaml` at your local copies.
