server <- function(data) {
    shinyServer(function(input, output, session) {
        # Dataset input list initialization
        choices <- data$datasets$id
        names(choices) <- data$datasets$name
        updateSelectizeInput(session, 'datasetId', choices = choices)
        shinyjs::enable("datasetId")
        
        # Gene symbol input list initialization
        if (!is.null(data$orgDb) && !is.na(data$orgDb)) {
            genomicFeatures <- list(
                "Genes" = genes,
                "Transcripts" = transcripts,
                "Exons" = exons,
                "CDS" = cds,
                "Promoters" = promoters
            )
            choices <- getGeneSymbols(data$orgDb)
            choices <- c("Select" = "Select", choices)
            updateSelectizeInput(session, "geneSymbol", choices = choices,
                selected = "Select", server = TRUE)
            
            shinyjs::enable("geneSymbol")
            shinyjs::enable("genesFile")
        }
        
        observeEvent(input$search, {
            shinyjs::hide("errormessage")
            shinyjs::hide("refmessage")
            shinyjs::hide("startmessage")
            shinyjs::hide("endmessage")
            shinyjs::hide("startendmessage")
            shinyjs::show("message")
            updateTabsetPanel(session, "inTabset", selected = "panelvariants")
        })
        
        # Search button click action
        # This action will initialize Variant data table
        variants <- eventReactive(input$search, {
            if(!is.null(input$genesFile)) {
                data$variants <- searchVariantsByGeneSymbol(
                    host = data$host,
                    variantSetId = data$variantSet$id,
                    seqlevelsStyle = data$seqlevelsStyle,
                    geneSymbol = toupper(trimws(readLines(
                        input$genesFile$datapath))),
                    orgDb = data$orgDb, txDb = data$txDb,
                    feature = genomicFeatures[[input$genomicFeature]])
            } else {
                if (input$referenceName == "Select") {
                    shinyjs::hide("message")
                    shinyjs::hide("download")
                    shinyjs::show("refmessage")
                    return()
                }
                if (is.na(input$start)) {
                    shinyjs::hide("message")
                    shinyjs::hide("download")
                    shinyjs::show("startmessage")
                    return()
                }
                if (is.na(input$end)) {
                    shinyjs::hide("message")
                    shinyjs::hide("download")
                    shinyjs::show("endmessage")
                    return()
                }
                if (input$start > input$end) {
                    shinyjs::hide("message")
                    shinyjs::hide("download")
                    shinyjs::show("startendmessage")
                    return()
                }
                if (input$genomicFeature != "Genes") {
                    data$variants <- searchVariantsByGeneSymbol(
                        host = data$host,
                        variantSetId = data$variantSet$id,
                        seqlevelsStyle = data$seqlevelsStyle,
                        geneSymbol = input$geneSymbol, orgDb = data$orgDb,
                        txDb = data$txDb,
                        feature = genomicFeatures[[input$genomicFeature]])
                } else {
                    data$variants <- searchVariants(
                        host = data$host,
                        variantSetId = data$variantSet$id,
                        referenceName = input$referenceName,
                        start = input$start,
                        end = input$end,
                        asVCF = FALSE)
                }
            }
            if (nrow(data$variants) == 0) {
                shinyjs::hide("message")
                shinyjs::hide("download")
                shinyjs::show("errormessage")
                return()
            }
            table <- tidyVariants(data$variants)
            table$`dbSNP ID` <- dbSNPlink(table$`dbSNP ID`)
            shinyjs::hide("message")
            shinyjs::show("download")
            DT::datatable(table, selection = list(mode = "single", selected = 1,
                target = "row"), escape = FALSE, options = list(scrollX = TRUE))
        })
        output$dt.variants <- DT::renderDataTable({
            variants()
        })
        
        # Variant set input list initialization
        # It depends on Dataset input list selection
        observeEvent(input$datasetId, {
            if (input$datasetId == "")
                return()
            data <- initializeVariantSet(data, input$datasetId)
            choices <- data$variantSets$id
            names(choices) <- data$variantSets$name
            updateSelectizeInput(session, "variantSetId", choices = choices)
            shinyjs::enable("variantSetId")
        })
        
        # Reference Name input list initialization
        # It depends on Variant set input list selection
        observeEvent(input$variantSetId, {
            if (input$variantSetId == "")
                return()
            data <- initializeReferences(data, input$variantSetId)
            updateSelectizeInput(session, "referenceName",
                choices = c("Select" = "Select", data$references$name),
                selected = "Select")
            shinyjs::enable("referenceName")
            shinyjs::enable("start")
            shinyjs::enable("end")
            shinyjs::enable("search")
        })
        
        # Gene symbol input list selection action
        # Reference Name, Start and End will change
        observeEvent(input$geneSymbol, {
            if (input$geneSymbol == "" || input$geneSymbol  == "Select")
                return()
            gene <- getGene(input$geneSymbol, data$orgDb, data$txDb)
            if (length(gene) == 0) {
                showModal(modalDialog(paste0("Gene symbol '", input$geneSymbol,
                    "' not available for this version of the reference genome."
                ), easyClose = TRUE))
                updateSelectizeInput(session, "referenceName",
                    selected = "Select")
                updateNumericInput(session, "start", value = "")
                updateNumericInput(session, "end", value = "")
                return()
            }
            if (length(gene) > 1) {
                warning(paste0("Found more than one genomic location for '",
                    input$geneSymbol, "' gene. Using the first."))
                gene <- gene[1]
            }
            seqlevelsStyle(gene) <- data$seqlevelsStyle
            selected <- as.character(seqnames(gene))
            updateSelectizeInput(session, "referenceName", selected = selected)
            updateNumericInput(session, "start", value = start(gene))
            updateNumericInput(session, "end", value = end(gene))
            shinyjs::enable("genomicFeature")
        })
        
        output$beacon <- renderUI({
            if (is.null(input$dt.variants_rows_selected))
                return()
            data$variant <- data$variants[input$dt.variants_rows_selected, ]
            if (data$referenceSet$name == "NCBI37")
                data$referenceSet$name <- "GRCh37"
            src <- paste0("https://beacon-network.org:443/#/widget?",
                "rs=", data$referenceSet$name,
                "&chrom=", data$variant$referenceName,
                "&pos=", data$variant$start,
                "&ref=", data$variant$referenceBases,
                "&allele=", data$variant$alternateBases)
            tags$div(class="embed-responsive embed-responsive-16by9",
                tags$iframe(src = src, class="embed-responsive-item",
                    style = "border:none;"))
        })
        
        output$download <- downloadHandler(
            filename = function() {
                "results.xlsx"
            },
            content = function(file) {
                write.xlsx(tidyVariants(data$variants), file)
            },
            contentType = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet"
        )
        
        observeEvent(input$genesFile, {
            if(!is.null(input$genesFile)) {
                shinyjs::disable("geneSymbol")
                shinyjs::disable("referenceName")
                shinyjs::disable("start")
                shinyjs::disable("end")
                shinyjs::enable("genomicFeature")
            } else {
                shinyjs::enable("geneSymbol")
                shinyjs::enable("referenceName")
                shinyjs::enable("start")
                shinyjs::enable("end")
                shinyjs::disable("genomicFeature")
            }
        })
    })
}  
