version 1.0

workflow kleborate_wf {
  input {
    Array[File] assemblies
    Array[String] samplenames
    String kleborate_docker_image
  }

  scatter (i in range(length(assemblies))) {
    call run_kleborate {
      input:
        assembly = assemblies[i],
        samplename = samplenames[i],
        kleborate_docker_image = kleborate_docker_image
    }
  }
}

task run_kleborate {
  input {
    File assembly
    String samplename
    String kleborate_docker_image
  }

  command {
    mkdir -p output_~{samplename}
    kleborate \
      -a ~{assembly} \
      -o output_~{samplename} \
      --modules enterobacterales__species,\
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
klebsiella_pneumo_complex__wzi
  }

  output {
    Array[File] result_files = glob("output_~{samplename}/*")
  }

  runtime {
    docker: kleborate_docker_image
    memory: "4G"
    cpu: 1
  }
}
