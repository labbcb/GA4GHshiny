ui <- function(request) {
    navbarPage(title = request$serverName,
        theme = shinythemes::shinytheme("cerulean"),
        selected = 1,
        tabPanel("Search Variants", value = 1, fluidRow(
            shinyjs::useShinyjs(),
            column(2, wellPanel(shinyjs::disabled(
                selectizeInput("datasetId", "Dataset", choices = NULL),
                selectizeInput("variantSetId", "Variant Set", choices = NULL),
                fileInput("genesFile", "Gene Symbols File", 
                    accept = "text/plain"),
                selectizeInput("geneSymbol", "Gene Symbol", choices = NULL),
                radioButtons("genomicFeature", "Genomic Feature",
                    choices = c("Genes", "Transcripts", "Exons", "CDS",
                        "Promoters")),
                selectizeInput("referenceName", "Reference Name", choices = NULL),
                numericInput("start", "Start", value = NA_integer_),
                numericInput("end", "End", value = NA_integer_),
                actionButton("search", "Search Variants", class = "btn-primary")
            ))),
            column(10, tabsetPanel(id = "inTabset",
                tabPanel("Variants", value = "panelvariants",
                    br(),
                    shinyjs::hidden(
                        div(id = "message", class="alert alert-info",
                            p("Searching for genomic variants, please wait."))),
                    shinyjs::hidden(
                        div(id = "errormessage", class="alert alert-danger",
                            p("No variants found."))),
                    DT::dataTableOutput("dt.variants"),
                    br(),
                    shinyjs::hidden(downloadButton(outputId = "download", 
                        label = "Download Results", class = "btn-secondary"))
                ),
                tabPanel("Beacon Network", value = "panelbeacon",
                    br(),
                    htmlOutput("beacon")
                ),
                tabPanel("Help", value = "panelhelp",
                    br(),
                    help("helpcontent", request$serverName)    
                )
            ))
        ))
    )
}
