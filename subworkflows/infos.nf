include { GET_CONTIGS_INFO } from "../modules/get_contigs_info.nf"

workflow INFOS {
    take: 
        path
        outdir
    
    main:
        GET_CONTIGS_INFO(path)
        
        infos = GET_CONTIGS_INFO.out
        .collectFile(storeDir:outdir) {it -> ["length.tsv", it]} 
        .splitText() {it.replaceFirst(/\n/, "").split()}  

    emit:
        infos = infos.flatten().collate(2)
}
