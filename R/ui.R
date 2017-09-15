ui <- navbarPage(title = textOutput("title", container = span),
    theme = "GA4GHshiny/bootstrap.css",
    selected = 1,
    tabPanel("Search Variants", value = 1, fluidRow(
        shinyjs::useShinyjs(),
        column(2, wellPanel(shinyjs::disabled(
            selectizeInput("datasetId", "Dataset", choices = NULL),
            selectizeInput("variantSetId", "Variant Set", choices = NULL),
            hr(), 
            selectizeInput("geneSymbol", "Gene Symbol", choices = NULL),
            radioButtons("genomicFeature", "Genomic Feature",
                choices = c("Genes", "Transcripts", "Exons", "CDS",
                "Promoters")),
            hr(),
            selectizeInput("referenceName", "Reference Name", choices=NULL),
            numericInput("start", "Start", value = NA_integer_),
            numericInput("end", "End", value = NA_integer_),
            hr(),
            actionButton("search", "Search Variants", class="btn-primary")
        ))),
        column(10, tabsetPanel(
            tabPanel("Variants", DT::dataTableOutput("dt.variants")),
            tabPanel("Beacon Network", htmlOutput("beacon"))
        ))
    )),
    tabPanel("About", h1("GA4GHshiny"))
)
