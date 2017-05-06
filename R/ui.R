ui <- function(request) {
    shinyUI(dashboardPage(
    dashboardHeader(titleWidth = "100%"),
    dashboardSidebar(disable = TRUE),
    dashboardBody(
        shinyjs::useShinyjs(),
        fluidRow(
        column(2, shinyjs::disabled(
            box(width = NULL,
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
                actionButton("search", "Search Variants")
            )
        )),
        column(10,
            box(title = "Variants", width = NULL, collapsible = TRUE,
                DT::dataTableOutput("dt.variants")
            ),
            box(title = "Beacon Network", width = NULL, collapsible = TRUE,
                htmlOutput("beacon")
            )
        )
    ))
))}
