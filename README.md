#Kleborate WDL Workflow for Local Cromwell

This repository contains a WDL workflow for running Kleborate on a list of Klebsiella genome assemblies. The workflow supports both local execution using Cromwell and cloud execution in Terra, with optional data table integration on Terra.

## Overview

Kleborate is a genomic profiling tool for *Klebsiella pneumoniae* and related species. This WDL implementation wraps the Kleborate command-line tool in a reproducible and portable format using Docker.

The workflow:

- Accepts multiple `.fasta` assemblies and associated sample names.
- Runs Kleborate using a Docker container.
- Outputs all module-specific result files into per-sample output folders.

## Files

- `kleborate_wf.wdl` — Main WDL script containing the workflow and `run_kleborate` task.
- `kleborate_local_input.json` — Example JSON input for running locally with Cromwell.
- (Optional) Terra Data Table structure and documentation to support execution via Terra.

## Inputs

| Name                    | Type          | Description                                   |
|-------------------------|---------------|-----------------------------------------------|
| `assemblies`            | Array[File]   | List of genome assemblies (.fasta)            |
| `samplenames`           | Array[String] | Matching list of sample IDs                   |
| `kleborate_docker_image`| String        | Docker image for Kleborate                    |

## Example run (Locally)

Make sure Cromwell & Docker are installed.

```bash

java -jar ~/cromwell-88.jar run kleborate_wf.wdl --inputs kleborate_local_input.json

```

Example `kleborate_local_input.json`:

```json
{
  "kleborate_wf.assemblies": [
    "~/A55766_contigs.fasta",
    "~/SRR28334394_contigs.fasta",
    "~/A55727_contigs.fasta"
  ],
  "kleborate_wf.samplenames": [
    "A55766",
    "SRR28334394"
    "A55727"

  ],
  "kleborate_wf.kleborate_docker_image": "myebenn/kleborate:3.2.1"
}
```

## Running in Terra

1. Upload this WDL to the **Workflows** tab of your Terra workspace.
2. Create a data table with the following columns:
    - `entity:sample_id`
    - `assembly_fasta` (GS path to `.fasta` file)
3. Launch the workflow:
    - Link `assembly` to `this.assembly_fasta`
    - Link `samplename` to `this.sample_id`
    - Provide the Docker image string as `"myebenn/kleborate:3.2.1"`
      
4. (Optional) Map output columns back to the table (e.g., `kleborate_species`, `kleborate_summary`).

## Outputs

Each sample will generate a folder named `output_<sample_id>/` containing Kleborate result files, such as:

- `*_summary.txt`
- `*_species_output.txt`
- 
- Module-specific metrics & predictions

These are available in the `result_files` array output from the task.

## Docker Image

The default Docker image used is:

```bash
myebenn/kleborate:3.2.1

```


## References

- [Kleborate GitHub](https://github.com/katholt/Kleborate)
- Kleborate paper (https://www.nature.com/articles/s41467-021-24448-3)



