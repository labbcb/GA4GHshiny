# Reference Class used internally by Shiny application.
# It should not be used by the user.
setRefClass("GA4GHSet",
    fields = list(
        host = "character",
        orgDb = "character",
        txDb = "character",
        datasets = "DataFrame",
        referenceSet = "DataFrame",
        references = "DataFrame",
        variantSets = "DataFrame",
        variantSet = "DataFrame",
        variants = "DataFrame",
        variant = "DataFrame",
        seqlevelsStyle = "character",
        serverName = "character"
    ))
