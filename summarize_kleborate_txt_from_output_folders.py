import os
import pandas as pd
import glob

# Columns to extract from each Kleborate .txt file
KEY_COLUMNS = [
    'strain',
    'enterobacterales__species__species',
    'general__contig_stats__N50',
    'klebsiella_pneumo_complex__mlst__ST',
    'klebsiella_pneumo_complex__resistance_class_count__num_resistance_classes',
    'klebsiella_pneumo_complex__resistance_gene_count__num_resistance_genes',
    'klebsiella_pneumo_complex__resistance_score__resistance_score',
    'klebsiella_pneumo_complex__virulence_score__virulence_score',
]

def find_txt_files_from_output_folders(base_dir):
    """Find all .txt files inside folders named 'output_*' under base_dir."""
    txt_files = []
    pattern = os.path.join(base_dir, "output_*", "**", "*.txt")
    for path in glob.glob(pattern, recursive=True):
        txt_files.append(path)
    return txt_files

def summarize_txt_files(txt_paths):
    """Load and filter relevant columns from .txt Kleborate outputs."""
    all_data = []
    for path in txt_paths:
        try:
            df = pd.read_csv(path, sep="\t")
            filtered_df = df[KEY_COLUMNS].copy()
            filtered_df["source_file"] = os.path.basename(path)
            all_data.append(filtered_df)
        except Exception as e:
            print(f" Skipping {path}: {e}")
    return pd.concat(all_data, ignore_index=True) if all_data else pd.DataFrame()

def main():
    # Change this to the parent directory containing all `output_*` folders
    base_dir = "./"

    output_file = "kleborate_summary.xlsx"

    print(f" Searching for .txt files in folders like {base_dir}/output_*/ ...")
    txt_files = find_txt_files_from_output_folders(base_dir)

    print(f" Found {len(txt_files)} .txt files.")
    summary_df = summarize_txt_files(txt_files)

    if not summary_df.empty:
        summary_df.to_excel(output_file, index=False)
        print(f" Summary saved to {output_file}")
    else:
        print("⚠️ No valid data found.")

if __name__ == "__main__":
    main()
