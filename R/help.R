help <- function(id, serverName) {
    tagList(
    p("This web application interactive access to federated genomic data servers based on Global Alliance for Genomics and Health (GA4GH) application programming interface (API). See guidelines below to search for genomic variants on", serverName, "."),
    p("Dataset", class="h5"),
    p("Collection of variant sets that share group of individuals. Selection of Dataset determines available Variant Sets."),
    p("Variant Set", class="h5"),
    p("Collection of genomic variants given a reference genome. Selection of Variant Set determines list of Reference Names."),
    p("Gene Symbols File", class="h5"),
    p(em("Optional."), "Upload a plain text file containing list of Gene Symbols (one gene per line) to search for variants. Application will ignore unidentified symbols. List of available gene symbols are determined by reference genome version. Providing this file will make available Genome Feature and will disable Reference Name, Start, End and Gene Symbol."),
    p("Gene Symbol", class="h5"),
    p(em("Optional."), "List of available gene symbol to search variants. List of available gene symbols are determined by reference genome version. Selection of Gene Symbol fills Reference Name, Start and End fields with genomic location of selected gene and it will make available Genome Feature."),
    p("Genome Feature", class="h5"),
    p(em("Optional."), "List of genomic features to filter variants. Selection of Genome Feature will be used for all provided gene symbols."),
    tags$ul(
        tags$li("Genes - all genomic variants of a given gene."),
        tags$li("Transcripts - only genomic variants located at known transcripts."),
        tags$li("Exons - only genomic variants located at known exons."),
        tags$li("CDS - only genomic variants located at known coding regions."),
        tags$li("Promoters - only genomic variants located at known promoter regions.")
    ),
    p("Reference Genome, Start and End", class="h5"),
    p("Genomic location to search for variants. Start and End are 1-based inclusive coordinates."),
    p("Variants Tab", class="h5"),
    p("Results will be available after completion of search. It shows an interactive table containing all genomic variants found at given location or genes. Columns are dependent of search parameters. Use text field located at top right to find in table (all columns). Use arrows and page numbers located at bottom right of the table to navigate through page results. Click in Download Results button to download full result table as XLSX file (Microsoft Office Excel and LibreOffice Calc compatible)."),
    p("Beacon Network Tab", class="h5"),
    p("Given selected genomic variant in result table (Variant Tab), ask presence of that variant in", a("Beacon Network", href="https://beacon-network.org/", target="_blank"), "service. The Beacon Network is a search engine across the world's public beacons. It enables global discovery of genetic mutations, federated across a large and growing network of shared genetic datasets."),
    p("Contributing", class="h5"),
    p("Help us to improve our web application by providing feedback at", a("https://github.com/labbcb/GA4GHshiny", href="https://github.com/labbcb/GA4GHshiny", target="_blank"), "."),
    p("Partnership", class="h5"),
    tags$ul(
        tags$li(a("Biostatistics and Computational Biology Laboratory", href="http://bcblab.org/", target="_blank")),
        tags$li(a("Brazilian Initiative on Precision Medicine", href="http://bipmed.org/", target="_blank")),
        tags$li(a("Global Alliance for Genomics and Health", href="http://genomicsandhealth.org/", target="_blank"))
    ),
    p(paste("GA4GHshiny", packageVersion("GA4GHshiny"))))
}