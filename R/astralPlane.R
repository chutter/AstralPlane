#' @title AstralPlane
#'
#' @description Function for reading data into the astralPlane format
#'
#' @param astral.tree phylogenetic tree from ape read.tree
#'
#' @param outgroups a vector of outgroups to root the tree
#'
#' @param tip.length arbitrary value for the terminal tip lengths, Astral does not compute this
#'
#' @return an S4 Object of class astralPlane. The object is slotted and contains: 1. Sample names, 2. phylogenetic tree rooted, 3. node.data table of ASTRAL-III node data, 4. edge.data table of ASTRAL-III branch data. All these make ASTRAL-III output readable and easy to use in other functions, or to plot using the astralProjection function.
#'
#' @examples
#'
#' your.tree = ape::read.tree(file = "file-path-to-tree.tre")
#' astral.data = astralPlane(astral.tree = your.tree,
#'                           outgroups = c("species_one", "species_two"),
#'                           tip.length = 1)
#'
#' @export


astralPlane = function(astral.tree = NULL,
                       outgroups = NULL,
                       tip.length = 1){

  #Sets the class for the phylogenetic object
  setOldClass(Classes = "phylo")

  setClass("astralPlane", slots=list(samples="character",
                                tree = "phylo",
                                node.data="data.frame",
                                edge.data="data.frame"))

  if(is.null(outgroups) == TRUE){ stop("Please provide outgroups.") }

  #Read in tree and root it properly
  a.tree = ape::read.tree(astral.tree)
  a.tree = ape::unroot(a.tree)
  if (ape::is.monophyletic(a.tree, outgroups) == T){
    spp.tree = ape::root(phy = a.tree, outgroup = outgroups, resolve.root = T)
  } else{ spp.tree = ape::root(phy = a.tree, outgroup = outgroups, resolve.root = T) }

  #Formats the node data
  node.vals = stringr::str_split(pattern = ";", spp.tree$node.label)
  node.vals = node.vals[node.vals != ""]
  node.vals = node.vals[-1]
  node.data = as.data.frame(do.call(rbind, node.vals))
  node.data$V1 = gsub("\\[", "", node.data$V1)
  colnames(node.data) = c("q1", "q2", "q3", "f1", 'f2', "f3", "pp1", "pp2", "pp3",
                          "QC", "EN")

  #Adds in node number
  node.data = cbind(node = (length(spp.tree$tip.label)+3):(length(spp.tree$tip.label)+spp.tree$Nnode), node.data)

  #Node data
  node.data$q1 = round(as.numeric(gsub("q1=", "", node.data$q1)), 3)
  node.data$q2 = round(as.numeric(gsub("q2=", "", node.data$q2)), 3)
  node.data$q3 = round(as.numeric(gsub("q3=", "", node.data$q3)), 3)

  node.data$f1 = round(as.numeric(gsub("f1=", "", node.data$f1)), 3)
  node.data$f2 = round(as.numeric(gsub("f2=", "", node.data$f2)), 3)
  node.data$f3 = round(as.numeric(gsub("f3=", "", node.data$f3)), 3)

  node.data$pp1 = round(as.numeric(gsub("pp1=", "", node.data$pp1)), 3)
  node.data$pp2 = round(as.numeric(gsub("pp2=", "", node.data$pp2)), 3)
  node.data$pp3 = round(as.numeric(gsub("pp3=", "", node.data$pp3)), 3)

  node.data$QC = round(as.numeric(gsub("QC=", "", node.data$QC)), 3)
  node.data$QC = round(as.numeric(gsub("QC=", "", node.data$QC)), 3)
  node.data$QC = round(as.numeric(gsub("QC=", "", node.data$QC)), 3)

  node.data$EN = gsub("]", "", node.data$EN)
  node.data$EN = gsub("]", "", node.data$EN)
  node.data$EN = gsub("]", "", node.data$EN)
  node.data$EN = round(as.numeric(gsub("EN=", "", node.data$EN)), 3)
  node.data$EN = round(as.numeric(gsub("EN=", "", node.data$EN)), 3)
  node.data$EN = round(as.numeric(gsub("EN=", "", node.data$EN)), 3)

  spp.tree$edge.length[is.na(spp.tree$edge.length) == T] = tip.length
  edge.node = astralPlane::edgeLengthTable(tree = spp.tree, tips = T)

  raw.tree = spp.tree
  raw.tree$node.label = NULL
  #Makes new S4 class out of data
  astral.object = new("astralPlane",
      samples = raw.tree$tip.label,
      tree = raw.tree,
      node.data = node.data,
      edge.data = edge.node)

  return(astral.object)

} #end function

