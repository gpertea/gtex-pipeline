task star_index {

    File reference_fasta
    File annotation_gtf
    String prefix
    Int overhang
    Int? suffix_lengthmax
    String? transform_type
    File? transform_vcf

    Int memory
    Int disk_space
    Int num_threads
    Int num_preempt

    command {
        set -euo pipefail
        mkdir ${prefix}
        STAR \
            --runMode genomeGenerate \
            --genomeDir ${prefix} \
            --genomeFastaFiles ${reference_fasta} \
            --sjdbGTFfile ${annotation_gtf} \
            --sjdbOverhang ${overhang} \
            ${"--genomeSuffixLengthMax " + suffix_lengthmax} \
            ${"--genomeTransformType " + transform_type} \
            ${"--genomeTransformVCF " + transform_vcf} \
            --runThreadN ${num_threads}
        tar -cvzf genome_index_${prefix}.tar.gz ${prefix}
    }

    output {
        File star_index = "genome_index_${prefix}.tar.gz"
    }

    runtime {
        docker: "gcr.io/broad-cga-francois-gtex/gtex_rnaseq:V10"
        memory: "${memory}GB"
        disks: "local-disk ${disk_space} HDD"
        cpu: "${num_threads}"
        preemptible: "${num_preempt}"
    }

    meta {
        author: "Francois Aguet"
    }
}


workflow star_index_workflow {
    call star_index
}
