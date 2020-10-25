#' @title edgeLengthTable
#'
#' @description This function creates an edge length table showing the two connecting nodes to the edge
#'
#' @param tree phylogenetic tree from ape read.tree in phylo format
#'
#' @param tips whether to include the tip edges or not
#'
#' @return a data.frame is returned with the columns: "edge" = edge number; "node1" = ancestral node; and "node2" = descendent node. Node that node1 can be repeated because many descendents could have 1 ancestor.
#'
#' @examples
#'
#' your.tree = ape::read.tree(file = "file-path-to-tree.tre")
#' edge.table = edgeLengthTable(tree = your.tree, tips = TRUE)
#'
#' @export


edgeLengthTable = function(tree = NULL,
                           tips = FALSE) {

  if (is.null(tree) == TRUE){ stop("No phylogenetic tree provided.") }

  #Extract node numbers and associated branch lengths
  node.no = as.numeric(length(tree$tip.label)+2:tree$Nnode)
  the.edges = tree$edge
  out.table = data.frame(edge = rep(1:nrow(the.edges)),
                         edge_length = tree$edge.length,
                         node1 = the.edges[,1],
                         node2 = the.edges[,2])

  #Whether to include the tip branches or not
  if (tips == FALSE){
    out.table = out.table[out.table$node1 > length(tree$tip.label),]
    out.table = out.table[out.table$node2 > length(tree$tip.label),]
  }#end if

  return(out.table)
}

