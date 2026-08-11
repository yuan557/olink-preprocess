import json
import os

cfg = snakemake.config

counts_base = os.path.abspath(cfg["counts_base_dir"])

plate_layouts = [
    {"path": os.path.abspath(path), "plateId": plate_id}
    for plate_id, path in cfg["plate_layouts"].items()
]

runs = []
for run in cfg["runs"]:
    run_counts_dir = os.path.join(counts_base, run["run_id"])
    run_units = [
        {
            "plateLayout":   ru["plate_layout"],
            "libraryNumber": ru["library_number"],
            "indexPlate":    ru["index_plate"],
            "panel":         ru["panel"],
        }
        for ru in run["run_units"]
    ]
    runs.append({"path": run_counts_dir, "runUnits": run_units})

data = {
    "projectName":              cfg["project_name"],
    "productType":              cfg["product_type"],
    "normalization":            cfg["normalization"],
    "selectedDataAnalysisRefIds": cfg["analysis_ref_ids"],
    "plateLayouts":             plate_layouts,
    "runs":                     runs,
}

os.makedirs(os.path.dirname(snakemake.output[0]), exist_ok=True)
with open(snakemake.output[0], "w") as fh:
    json.dump(data, fh, indent=2)
