# Problem 1: Smart Home Energy Consumption Analysis

## Setup

```bash
python3 -m venv .venv
.venv/bin/pip install -r requirements.txt
```

## Run

```bash
.venv/bin/python smart_home_bayesian_network.py
```

The program uses seed **2026**, generates all three datasets, performs expert and learned inference, creates screenshots/plots, and writes a complete markdown report plus machine-readable CSV files in the `outputs` folder.

## Expected outputs

- `outputs/analysis_report.md`
- `outputs/network_expert.png`
- `outputs/query_comparison.csv`
- `outputs/dataset_summary.csv`
- `outputs/ac_cpt_comparison.csv`
- Three generated CSV datasets under `outputs/datasets/`
- One dataset and CPT summary text file per estimation method and sample size
