# Kleborate WDL Workflow for Local Cromwell

This repository contains a WDL workflow for running Kleborate on a list of  *Klebsiella species*  & *Escherichia coli* genome assemblies. The workflow supports both local execution using Cromwell & cloud execution in Terra, with optional data table integration on Terra.

## Overview

Kleborate is a genomic profiling tool for *Klebsiella pneumoniae* & related species plus now also *E. coli* genomes. This WDL implementation wraps the Kleborate command-line tool in a reproducible & portable format using Docker.

The workflow:

- Accepts multiple `.fasta` assemblies & associated sample names.
- Runs Kleborate using a Docker container.
- Outputs all module-specific result files into per-sample output folders.

## Files

- `kleborate_wf.wdl` — Main WDL script containing the workflow & `run_kleborate` task.
- `kleborate_local_input.json` — Example JSON input for running locally with Cromwell.
- (Optional) Terra Data Table structure & documentation to support execution via Terra.

## Inputs

| Name                    | Type          | Description                                   |
|-------------------------|---------------|-----------------------------------------------|
| `assemblies`            | Array[File]   | List of bacterrial genome assemblies (.fasta) |
| `samplenames`           | Array[String] | Matching list of sample IDs                   |
| `kleborate_docker_image`| String        | Docker image for Kleborate                    |

## Example run (Locally)

Make sure Cromwell & Docker are installed.

```bash

java -jar ~/cromwell-88.jar run kleborate_wf.wdl --inputs kleborate_local_input.json

```

Example `kleborate_local_input.json` with Klebsiella assemblies:

```json
{
  "kleborate_wf.assemblies": [
    "~/A55766.fasta",
    "~/SRR28334394.fasta",
    "~/A55727.fasta"
  ],
  "kleborate_wf.samplenames": [
    "A55766",
    "SRR28334394"
    "A55727"

  ],
  "kleborate_wf.kleborate_docker_image": "myebenn/kleborate:3.2.1"
}
```
## And now also *E. coli* genomes

```bash
docker run -v ~/test:/input -it myebenn/kleborate:3.2.1 \
  -a /input/Ecoli.fasta \
  -o ~/output_Ecoli \
  --modules enterobacterales__species,\
escherichia__amr,\
escherichia__ectyper,\
escherichia__ezclermont,\
escherichia__mlst_achtman,\
escherichia__mlst_lee,\
escherichia__mlst_pasteur,\
escherichia__pathovar,\
escherichia__stxtyper,\
general__contig_stats

```

```bash

java -jar ~/cromwell-88.jar run kleborate_wf.wdl --inputs kleborate_local_input.json

```

## Batch runs


```bash

bash kleborate_wf_wdl_batch.sh

```

```bash

bash kleborate_wf_wdl_batch_ecoli.sh

```


## Kleborate results summary

| Strain      | Species                                             | N50     | ST           | Resistance classes | Resistance genes | Resistance score | Virulence score |
|-------------|-----------------------------------------------------|---------|--------------|--------------------|------------------|------------------|-----------------|
| A55727      | *Klebsiella quasipneumoniae* subsp. similipneumoniae| 24,320  | ST489        | 4                  | 4                | 1                | 0               |
| SRR28334394 | *Klebsiella pneumoniae*                             | 229,347 | ST1927       | 6                  | 10               | 1                | 1               |
| A55766      | *Klebsiella pneumoniae*                             | 39,092  | ST567-1LV    | 9                  | 17               | 1                | 0               |

## Kleborate results summary (*Escherichia coli*)

| Strain    | Species             | ST (Allelic) | ST (MLST) | N50     |
|-----------|---------------------|--------------|-----------|---------|
| 056EL61   | *Escherichia coli*  | ST93         | ST83      | 104,040 |
| CHS36530  | *Escherichia coli*  | ST4981       | ST741     | 91,014  |
| CHS36541  | *Escherichia coli*  | ST5229       | ST88      | 171,126 |


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

- Module-specific metrics & predictions

These are available in the `result_files` array output from the task.

## Docker Image

The default Docker image used is:

```bash

myebenn/kleborate:3.2.1

```


## References

- [Kleborate GitHub](https://github.com/katholt/Kleborate)  
- [Kleborate paper](https://www.nature.com/articles/s41467-021-24448-3)



