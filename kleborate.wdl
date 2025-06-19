version 1.0

task KleborateTask {
  input {
    File fasta_file
    String basename
  }

  command {
    kleborate \
      -a ${fasta_file} \
      -o ./ \
      --modules klebsiella_pneumo_complex__amr,klebsiella_pneumo_complex__mlst,klebsiella_pneumo_complex__kaptive,klebsiella_pneumo_complex__virulence_score
  }

  output {
    File result = "${basename}.kleborate.tsv"
  }

  runtime {
    docker: "myebenn/kleborate:3.2.1"
    cpu: 1
    memory: "2G"
  }
}

workflow run_kleborate {
  input {
    File fasta_file
    String basename
  }

  call KleborateTask {
    input:
      fasta_file = fasta_file,
      basename = basename
  }

  output {
    File kleborate_output = KleborateTask.result
  }
}
