##' Class "AstralPlane"
##' This class stores astral phylogenetic data
##'
##' @name AstralPlane-class
##' @docType class
##' @slot fileName file name is here
##' @slot samples sample names are here
##' @slot phylo phylo object for tree structure
##' @slot nodeData data for nodes
##' @slot edgeData data for branches
##' @slot ConcordanceFactorData associated data from concordance factor analysis
##' @importClassesFrom ape stringr
##' @exportClass AstralPlane
##' @keywords classes

#Sets the class for the phylogenetic object
setOldClass(Classes = "phylo")

setClass("AstralPlane", slots=list(fileName = "character",
                                   samples="character",
                                   phylo = "phylo",
                                   nodeData="data.frame",
                                   edgeData="data.frame",
                                   concordanceFactorData = "data.frame"))

##' @importFrom ape
##' @export

