isRefHomozygous <- function(x) all(x == 0)
isAltHeterozygous <- function(x) x[1] != x[2]
isAltHomozygous <- function(x) all(x[1] != 0 & x[1] == x[2])

hasManyOrNone <- function(col)
{
    any(map_lgl(col, ~ length(.x) > 1 || length(.x) == 0))
}

dbSNPlink <- function(xs) {
    link <- function(x)
        paste0('<a target="_blank" ',
            'href="https://www.ncbi.nlm.nih.gov/SNP/snp_ref.cgi?rs=',
            x, '">', x, '</a>')
    xs %>%
        map_if(~ startsWith(.x, prefix = "rs"), link) %>%
        unlist
}

# This function arranges response data of GA4GHclient::searchVariants function.
tidyVariants <- function(variants)
{
    variants <- as.data.frame(variants)
    if (nrow(variants) == 0)
        return(NULL)

    variants$calls <- NULL

    alt.length <- map_int(variants$alternateBases, length)
    notOk <- function(x) !identical(map_int(x, length), alt.length)

    cols.rm <- variants %>%
        select_if(hasManyOrNone) %>%
        select_if(notOk) %>%
        names
    variants[cols.rm] <- NULL

    cols <- variants %>%
        select_if(hasManyOrNone) %>%
        names

    cols.info <- names(variants)[startsWith(names(variants), "info.")]
    names(cols.info) <- cols.info %>%
        map_chr(sub, pattern = "^info\\.", replacement = "")

    cols.selected <- c("DNA change" = "hgvs", "dbSNP ID" = "names")

    if (!is.null(variants$geneSymbol))
        cols.selected <- c(cols.selected, "Gene Symbol" = "geneSymbol")
    if (!is.null(variants$featureId))
        cols.selected <- c(cols.selected, "Feature ID" = "featureId")

    cols.selected <- c(cols.selected,
        "Reference Name" = "referenceName", "Start" = "start", "End" = "end",
        "Reference Bases" = "referenceBases",
        "Alternate Bases" = "alternateBases",
        cols.info)

    df <- variants

    if (length(cols) != 0)
        df <- unnest_(df, unnest_cols = cols, .drop = FALSE)

    mutate_all(df, function(x) ifelse(is.na(x), "-", x)) %>%
        mutate_(hgvs = ~HGVSnames(start, referenceBases, alternateBases)) %>%
        mutate_if(is.numeric, round, digits = 4) %>%
        select_(.dots = cols.selected) %>%
        mutate_if(is.list, unlist)
}
    
# This function returns a list of available genes symbols from an org.Db object. 
getGeneSymbols <- function(orgDb) 
{
    orgDb <- get(orgDb)
    AnnotationDbi::keys(orgDb, keytype = "SYMBOL")
}

# This function searches genomic variants by a gene symbol. 
# The feature parameter recieves a function name for get genomic features.
# Example: genes, transcripts, exons, promoters.
searchVariantsByGeneSymbol <- function(host, variantSetId, seqlevelsStyle, 
    geneSymbol, orgDb, txDb, feature = genes)
{
    orgDb <- get(orgDb)
    txDb <- get(txDb)
        
    df <- AnnotationDbi::select(orgDb, keys = geneSymbol,
        columns = c("SYMBOL", "ENTREZID"), keytype = "SYMBOL")
    df <- df[complete.cases(df), ]
    granges <- feature(txDb, filter = list(gene_id = df$ENTREZID))
    geneIds <- unlist(feature(txDb, column = "gene_id", 
        filter = list(gene_id = df$ENTREZID))$gene_id)
    
    validExons <- geneIds %in% df$ENTREZID
    geneIds <-  geneIds[validExons]
    
    if (length(granges) == 0) {
        return(NULL)
    }
    
    seqlevelsStyle(granges) <- seqlevelsStyle
    
    variants <- searchVariantsByGRanges(host = host,
        variantSetId = variantSetId, granges = granges, 
        asVCF = FALSE)
    variants <- lapply(variants, as.data.frame)
    ids <- rep(mcols(granges)[, 1], sapply(variants, function(x) {
        if (is.null(x))
            return(0)
        nrow(x)
    }))
    geneIds <- rep(geneIds, sapply(variants, function(x) {
        if (is.null(x))
            return(0)
        nrow(x)
    }))
    variants <- variants[!sapply(variants, is.null)]
    variants <- DataFrame(bind_rows(variants))
    variants$featureId <- ids
    if (length(geneSymbol) > 1) {
        variants$geneSymbol <- df[match(geneIds, df$ENTREZID), "SYMBOL"]
    }
    variants
}

# This function returns genomic coordinate (GRanges) by gene symbol.
getGene <- function(geneSymbol, orgDb, txDb)
{
    orgDb <- get(orgDb)
    txDb <- get(txDb)
    entrezid <- AnnotationDbi::select(orgDb, keys = geneSymbol,
        columns = c("SYMBOL", "ENTREZID"), keytype = "SYMBOL")$ENTREZID
    genes(txDb, filter = list(gene_id = entrezid))
}

# This function adds refernce set data from a dataset to an GA4GHSet object.
# The data argument is changed by reference.
initializeVariantSet <- function(data, datasetId)
{
    data$variantSets <- searchVariantSets(data$host, datasetId)
    data
}

# This function adds references data from a variant set to an GA4GHSet object.
# The data argument is changed by reference.
initializeReferences <- function(data, variantSetId)
{
    data$variantSet <- getVariantSet(data$host, variantSetId, 
        asVCFHeader = FALSE)
    data$referenceSet <- getReferenceSet(data$host,
        data$variantSet$referenceSetId)
    data$references <- searchReferences(data$host,
        referenceSetId = data$variantSet$referenceSetId)
    data$seqlevelsStyle <- seqlevelsStyle(data$references$name)[1]
    data
}
