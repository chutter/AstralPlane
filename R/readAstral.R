#' @title readAstral
#'
#' @description Function for writing alignments in R to phylip format
#'
#' @param astral.tree phylogenetic tree from ape read.tree
#'
#' @param outgroups a vector of outgroups to root the tree
#'
#' @param tip.length arbitrary value for the terminal tip lengths, Astral does not compute this
#'
#' @return saves the alignment as a phylip file
#'
#' @examples
#'
#' your.tree = ape::read.tree(file = "file-path-to-tree.tre")
#' astral.data = astralPlane(astral.tree = your.tree,
#'                           outgroups = c("species_one", "species_two"),
#'                           tip.length = 1)
#'
#'
#' @export

##### saves alignment as a phylip file
readAstral = function(astral.tree = NULL,
                      outgroups = NULL,
                      tip.length = 1){

  #astral.tree = "/Users/chutter/Dropbox/Research/1_Main-Projects/1_Collaborative-Projects/Microhylidae_SeqCap/New_Work_2021/Astral/filtered-Astral/Microhylidae_alignment_length_filters-S0-L1000-CPIS0-PPIS0_astral.tre"
  #outgroups  = c("Dyscophus_guineti_merged_ZCMV14884-SC", "Paradoxophyla_palmata_merged_CRH1173-SC", "Scaphiophryne_marmorata_mixed_CRH920-SC")
  #tip.length = 1

  #Parameter checks
  if(is.null(astral.tree) == TRUE){ stop("Please provide an astral tree file path.") }
  #Reads in tree
  if (file.exists(astral.tree) == FALSE){stop("Astral tree file could not be found.")  }

  #Check if files exist or not
  if (file.exists(astral.tree) == F){
    return(paste0("Astral tree could not be found. Exiting."))
  }#end file check

  #Read in tree and root it properly
  a.text = readLines(astral.tree, warn=FALSE)
  a.text = gsub(";", "$", a.text)
  a.text = gsub("'\\[", "@", a.text)
  a.text = gsub("]'", "@", a.text)

  if (substring(a.text, nchar(a.text), nchar(a.text)) != ';') { a.text = paste0(a.text, ";") }

  #Read in assess tree
  a.tree = ape::read.tree(text = a.text)
  a.tree = ape::unroot(a.tree)

  #Roots the tree if outgroups are provided
  if (is.null(outgroups) != T){
    if (ape::is.monophyletic(a.tree, outgroups) == T){
      spp.tree = ape::root(phy = a.tree, outgroup = outgroups, resolve.root = T)
    } else{ spp.tree = ape::root(phy = a.tree, outgroup = outgroups, resolve.root = T) }
  } else { spp.tree = a.tree }

  #Formats the node data
  spp.tree$node.label = gsub("\\@", "", spp.tree$node.label)
  node.vals = stringr::str_split(pattern = "\\$", spp.tree$node.label)

  #node.vals = gsub("@", "", node.vals)
  #node.vals = node.vals[node.vals != ""]
  #node.vals = node.vals[-1]

  #Gathers metadata
  node.data = as.data.frame(do.call(rbind, node.vals))
  node.data$V1 = gsub("\\@", "", node.data$V1)
  colnames(node.data) = c("q1", "q2", "q3", "f1", 'f2', "f3", "pp1", "pp2", "pp3",
                          "QC", "EN")

  #Adds in node number
  node.data = cbind(node = (length(spp.tree$tip.label)+1):(length(spp.tree$tip.label)+spp.tree$Nnode), node.data)
  node.data[node.data == ""] = NA
  node.data[node.data == "Root"] = NA
  #node.data[1,1] = "Root"

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

  node.data$EN = gsub("].*", "", node.data$EN)
  node.data$EN = round(as.numeric(gsub("EN=", "", node.data$EN)), 3)
  node.data$QC = round(as.numeric(gsub("QC=", "", node.data$QC)), 3)

  spp.tree$edge.length[is.na(spp.tree$edge.length) == T] = tip.length
  edge.node = edgeLengthTable(tree = spp.tree, tips = T)

  raw.tree = spp.tree
  raw.tree$node.label = node.data$node

  return(raw.tree)

  #Makes new S4 class out of data
#  astral.object = new("AstralPlane",
 #                     fileName = astral.tree,
  #                    samples = raw.tree$tip.label,
   #                   phylo = raw.tree,
    #                  nodeData = node.data,
     #                 edgeData = edge.node)

} #end function



