#' @title makePolytomy
#'
#' @description This function collapses nodes under a certain support value into a polytomy
#'
#' @param tree phylogenetic tree from ape read.tree in phylo format
#'
#' @param polytomy.limit the threshold for collapsing a node into a polytomy
#'
#' @return phylogenetic tree in phylo format, with the nodes collapsed into polytomies.
#'
#' @examples
#'
#' your.tree = ape::read.tree(file = "file-path-to-tree.tre")
#' new.tree = makePolytomy(tree = your.tree, polytomy.limit = 10)
#'
#' @export


#### This function collapses nodes under a certain support value into a polytomy
#### tree: phylogenetic tree
#### polytomy.limit: the support value to collapse. Must be in same units.

### Adapted from Ape's multi2di function

### This function collapses polytomies in your tree
makePolytomy = function(tree = NULL,
                        polytomy.limit = NULL) {

  #Checks for things
  if (is.null(tree)){ stop("Tree not provided.") }
  if (is.null(polytomy.limit)){ stop("Polytomy limit not provided.") }
  if (is.null(tree$edge.length)){ stop("Tree has no branch lengths.") }
  if (is.null(tree$node.label)) { stop("Tree has no node labels.") }

  #Crates node-edge table to reference and collapse
  edge.table = data.frame(tree$edge[tree$edge[,2] > length(tree$tip.label),])
  edge.table = cbind(edge.table, as.numeric(tree$node.label[2:length(tree$node.label)]))
  colnames(edge.table) = c(1,2,3)
  if (mean(edge.table[,3]) < 1 & polytomy.limit > 1){ stop("Polytomy limit must match support values.") }
  if (mean(edge.table[,3]) > 1 & polytomy.limit < 1){ stop("Polytomy limit must match support values.") }

  #obtains nodes to collapse
  collapse.table = edge.table[edge.table[,3] < polytomy.limit,]

  #returns tree if no nodes to collapse
  if (nrow(collapse.table) == 0){ return(tree) }

  #Obtains nodes to manipulate
  del.nodes = collapse.table[,2]
  anc.nodes = collapse.table[,1]

  #helper function to interively combine ancestors into 1
  # newAnc = function(tree, ancestor, delete) {
  #   #ancestor = anc.nodes[x]
  #   #delete = del.nodes[x]
  #   #Obtains the edges to delete
  #   edge.del = which(tree$edge[,1] == delete)
  #   #Goes through each edge
  #   for (y in edge.del) {
  #     #Checks if the adjcent node also needs to be deleted
  #     if (tree$edge[y, 2] %in% del.nodes){
  #       newAnc(tree, ancestor, tree$edge[y,2])
  #       } else {
  #         tree$edge[y, 1] = ancestor
  #       }#end else
  #   }#end loop
  #   return(tree)
  # }#end helper function

  newAnc = function(ancestor, des) {
    edge.del = which(tree$edge[, 1] == des)
    for (k in edge.del) {
      if (tree$edge[k, 2] %in% del.nodes)
        newAnc(ancestor, tree$edge[k, 2])
      else tree$edge[k, 1] <<- ancestor
    }
  }

  #Goes through each node to delete
  for (x in 1:length(del.nodes)) {
    #Skips the node if already collapse
    if (anc.nodes[x] %in% del.nodes){ next }
    #runs helper function
    newAnc(anc.nodes[x], del.nodes[x])
  }#end x loop

  #Removes the edges
  remove.edge = which(tree$edge[,2] %in% collapse.table[,2])
  tree$edge = tree$edge[-remove.edge,]
  tree$edge.length = tree$edge.length[-remove.edge]
  tree$Nnode = tree$Nnode - length(remove.edge)

  #renumbers edges
  renum = tree$edge > min(del.nodes)
  for (x in which(renum)){
    tree$edge[x] = tree$edge[x] - sum(del.nodes < tree$edge[x])
  }#end x loop

  #remove old node labels
  if (is.null(tree$node.label) != TRUE){
    tree$node.label = tree$node.label[-(del.nodes - length(tree$tip.label))]
  }#end if statement

  return(tree)

}#end collpase nodes function
