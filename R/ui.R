ui <- function(request) {
    navbarPage(title = request$serverName,
        selected = 1,
        tabPanel("Search Variants", value = 1, fluidRow(
            shinyjs::useShinyjs(),
            shinythemes::themeSelector(),
            column(2, wellPanel(shinyjs::disabled(
                selectizeInput("datasetId", "Dataset", choices = NULL),
                selectizeInput("variantSetId", "Variant Set", choices = NULL),
                hr(),
                fileInput("genesFile", "Gene Symbols File", 
                    accept = "text/plain"),
                selectizeInput("geneSymbol", "Gene Symbol", choices = NULL),
                radioButtons("genomicFeature", "Genomic Feature",
                    choices = c("Genes", "Transcripts", "Exons", "CDS",
                        "Promoters")),
                hr(),
                selectizeInput("referenceName", "Reference Name", choices = NULL),
                numericInput("start", "Start", value = NA_integer_),
                numericInput("end", "End", value = NA_integer_),
                hr(),
                actionButton("search", "Search Variants", class = "btn-primary")
            ))),
            column(10, tabsetPanel(id = "panel",
                tabPanel("Help", value = "help",
                    br(),
                    help("helpcontent", request$serverName)
                ),
                tabPanel("Variants", value = "variants",
                    br(),
                    DT::dataTableOutput("dt.variants"),
                    br(),
                    shinyjs::hidden(downloadButton(outputId = "download", 
                        label = "Download Results", class = "btn-secondary"))
                ),
                tabPanel("Beacon Network", value = "beacon",
                    br(),
                    htmlOutput("beacon")
                )
            ))
        ))
    )
}
