#!/bin/bash
set -euo pipefail

# Define base directory and Docker image
BASE_DIR="$(pwd)"
DOCKER_IMAGE="myebenn/kleborate:3.2.1"

# Define input files
SAMPLES=("A55727.fasta" "SRR28334394.fasta" "A55766.fasta")

# Define Kleborate modules
MODULES="enterobacterales__species,\
general__contig_stats,\
klebsiella__abst,\
klebsiella__cbst,\
klebsiella__rmpa2,\
klebsiella__rmst,\
klebsiella__smst,\
klebsiella__ybst,\
klebsiella_oxytoca_complex__mlst,\
klebsiella_pneumo_complex__amr,\
klebsiella_pneumo_complex__cipro_prediction,\
klebsiella_pneumo_complex__kaptive,\
klebsiella_pneumo_complex__mlst,\
klebsiella_pneumo_complex__resistance_class_count,\
klebsiella_pneumo_complex__resistance_gene_count,\
klebsiella_pneumo_complex__resistance_score,\
klebsiella_pneumo_complex__virulence_score,\
klebsiella_pneumo_complex__wzi"

# Loop through each sample and run Kleborate
for SAMPLE in "${SAMPLES[@]}"; do
  SAMPLE_NAME=$(basename "$SAMPLE" .fasta)
  OUTPUT_DIR="${BASE_DIR}/output_${SAMPLE_NAME}"
  mkdir -p "$OUTPUT_DIR"

  echo "Running Kleborate on $SAMPLE_NAME..."
  docker run --rm \
    -v "${BASE_DIR}:/data" \
    -w /data \
    "$DOCKER_IMAGE" \
    -a "/data/$SAMPLE" \
    -o "/data/output_${SAMPLE_NAME}" \
    --modules "$MODULES"

  echo "Finished $SAMPLE_NAME"
done

echo "All samples processed successfully."
