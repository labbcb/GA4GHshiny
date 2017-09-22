.onLoad <- function(libname, pkgname) {
    shiny::addResourcePath("wwww", system.file("www", package = "GA4GHshiny")
    )
}