#!/bin/bash
set -euo pipefail

# Define base directory and Docker image
BASE_DIR="~/test"
DOCKER_IMAGE="myebenn/kleborate:3.2.1"

# Define input files
SAMPLES=("A55727.fasta" "SRR28334394.fasta" "A55766.fasta")

# Define Kleborate modules
MODULES="enterobacterales__species,\
escherichia__amr,\
escherichia__ectyper,\
escherichia__ezclermont,\
escherichia__mlst_achtman,\
escherichia__mlst_lee,\
escherichia__mlst_pasteur,\
escherichia__pathovar,\
escherichia__stxtyper,\
general__contig_stats"

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
