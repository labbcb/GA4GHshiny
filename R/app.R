#' @title Open web application
#' @description Web application for interacting with GA4GH API data servers.
#' @details This application is dependent of which data the server provides
#' trough GA4GH API. If some of tables or graphic charts not appear, the server
#' connected may not provide the necessary data. For example, INFO data.
#' @param host Character vector of an URL of GA4GH API data server endpoint.
#' @param orgDb character vector of an org.Db package.
#' @param txDb character vector of a TxDb package.
#' @param serverName character vector of the server name. It will be the
#' \code{host} by default.
#' @return Shiny application object.
#' @examples
#' if (interactive()) {
#'   library(org.Hs.eg.db)
#'   library(TxDb.Hsapiens.UCSC.hg19.knownGene)
#'   app("http://1kgenomes.ga4gh.org/", orgDb = "org.Hs.eg.db",
#'     txDb = "TxDb.Hsapiens.UCSC.hg19.knownGene")
#' }
#' @export app
app <- function(host, orgDb = NA_character_, txDb = NA_character_,
                serverName = host) {
    if (!is.na(orgDb) || !is.na(txDb)) {
        if (is.na(orgDb) || is.na(txDb))
            stop("Both orgDb and TxDb packages should be informed or none of them.")
        if (!require(orgDb, character.only = TRUE))
            stop(paste("Cannot load", orgDb, "package."))
        if (!require(txDb, character.only = TRUE))
            stop(paste("Cannot load", txDb, "package"))
    }
    data <- new("GA4GHSet", host = host)
    data$orgDb <- orgDb
    data$txDb <- txDb
    data$serverName <- serverName
    data$datasets <- searchDatasets(data$host)
    shinyApp(ui, server(data))
}