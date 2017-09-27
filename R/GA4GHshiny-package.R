#' Shiny application for interacting with GA4GH-based data servers
#'
#' GA4GHshiny package provides an easy way to interact with data servers based
#' on Global Alliance for Genomics and Health (GA4GH) Genomics API through a
#' Shiny application. It also integrates with Beacon Network.
#'
#' @name GA4GHshiny-package
#' @aliases GA4GHshiny GA4GHshiny-package
#' @docType package
#' @author Welliton Souza, Benilton Carvalho, Cristiane Rocha, Elizabeth Borgognoni
#'
#' Maintainer: Welliton Souza <well309@gmail.com>
#' @keywords package
#'
#' @importMethodsFrom GenomeInfoDb seqlevelsStyle seqlevelsStyle<- seqnames
#' @importMethodsFrom GenomicFeatures genes transcripts exons cds promoters
#' @importMethodsFrom BiocGenerics as.data.frame start end
#' @importMethodsFrom S4Vectors mcols
#' @importFrom dplyr %>% bind_rows bind_cols mutate_ mutate_all mutate_if
#'     select_ select_if
#' @importFrom DT datatable renderDataTable dataTableOutput
#' @importFrom GA4GHclient searchDatasets searchVariants searchVariantSets
#'     searchVariantsByGRanges getVariantSet searchReferences getReferenceSet
#' @importFrom methods new
#' @importFrom purrr is_list map_chr map_df map_if map_int map_lgl
#' @importFrom S4Vectors DataFrame
#' @importFrom shiny shinyApp numericInput selectizeInput fluidPage fluidRow
#'     column actionButton observeEvent eventReactive updateSelectizeInput 
#'     radioButtons shinyServer validate need updateNumericInput hr htmlOutput
#'     renderUI tags tabsetPanel tabPanel wellPanel navbarPage
#'     textOutput showModal modalDialog downloadButton em tagList
#'     downloadHandler br fileInput p updateTabsetPanel a
#' @importFrom stats complete.cases
#' @importFrom tidyr unnest_
#' @importFrom utils packageVersion
#' @importFrom openxlsx write.xlsx
NULL