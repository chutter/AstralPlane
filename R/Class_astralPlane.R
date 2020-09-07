##' Class "AstralPlane"
##' This class stores astral phylogenetic data
##'
##' @name AstralPlane-class
##' @docType class
##' @slot samples sample names are here
##' @slot phylo phylo object for tree structure
##' @slot nodeData newick tree string
##' @slot edgeData associated data
##' @importClassesFrom ape stringr
##' @exportClass AstralPlane
##' @keywords classes

#Sets the class for the phylogenetic object
setOldClass(Classes = "phylo")

setClass("AstralPlane", slots=list(samples="character",
                              phylo = "phylo",
                              nodeData="data.frame",
                              edgeData="data.frame"))

##' @importFrom ape
##' @export

