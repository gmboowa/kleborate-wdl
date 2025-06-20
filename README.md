#Kleborate WDL Workflow for Local Cromwell

This WDL workflow runs the Kleborate tool on genome assemblies for **Klebsiella pneumoniae** to perform:

- Antimicrobial resistance (AMR) gene detection
- MLST typing
- Serotyping (K and L loci via Kaptive)
- Virulence scoring

## 🔧 Inputs

| Name | Type | Description |
|------|------|-------------|
| `fasta_file` | `File` | The assembled genome in FASTA format |
| `basename` | `String` | Prefix used to name the output file |

### Sample input JSON

```json
{
  "run_kleborate.fasta_file": "*.fasta",
  "run_kleborate.basename": "SRR**"
}

