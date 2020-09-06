#' @title setupAstral
#'
#' @description This function sets up an astral run from gene trees
#'
#' @param genetree.folder a folder of genetrees to prepare for astral analyses
#'
#' @param output.name the save name for your concatenated gene tree file
#'
#' @param overwrite whether to overwrite an existing dataset
#'
#' @param taxa.remove species that you would like removed from each gene tree
#'
#' @param min.n.samples the minimum number of samples to keep a gene tree
#'
#' @param min.sample.prop the minimum proportion of samples to keep a gene tree
#'
#' @param make.polytomy whether to collapse poorly supported nodes into polytomies
#'
#' @param polytomy.limit if make.polytomy = TRUE, the threshold value for node collapsing
#'
#' @return the function goes through each gene tree and applies the desired filters. It then writes all the gene trees that pass the filters to a single file for use in ASTRAL-III.
#'
#' @examples
#'
#' genetree.folder = "file/path/to/folder/of/genetrees"
#' taxa.delete = c("species_one", "species_two")
#' save.name = "test-dataset"
#'
#' setupAstral(genetree.folder = genetree.folder,
#'             output.name = save.name,
#'             overwrite = TRUE,
#'             taxa.remove = taxa.delete,
#'             min.n.samples = 4,
#'             min.sample.prop = 0.1,
#'             make.polytomy = TRUE,
#'             polytomy.limit = 10)
#'
#' @export


setupAstral = function(genetree.folder = NULL,
                       output.name = NULL,
                       overwrite = TRUE,
                       taxa.remove = NULL,
                       min.n.samples = 4,
                       min.sample.prop = NULL,
                       make.polytomy = TRUE,
                       polytomy.limit = 0) {

  if (is.null(genetree.folder) == TRUE){ stop("A folder of gene trees must be provided.")}

  #Sets up directory for output
  if (file.exists(paste0(output.name, "_genetrees.tre")) == T){
    #Checks for output directory and creates it if not found
    unlink(paste0(output.name, "_genetrees.tre"))
  }#end overwrite

  #Gets list of gene trees
  gene.trees = list.files(genetree.folder)

  #Obtains total number of samples
  if (is.null(min.sample.prop) != TRUE){

    total.taxa = c()
    for (x in 1:length(gene.trees)){
      temp.tree = ape::read.tree(paste0(genetree.folder, "/", gene.trees[x]))
      total.taxa = append(total.taxa, length(temp.tree$tip.label))
    }#end x loop
    max.taxa = max(total.taxa)
  }#end if for sample prop

  #Loops through and places trees
  tree.counter = 0
  for (x in 1:length(gene.trees)){

    #read in tree file
    temp.tree = ape::read.tree(paste0(genetree.folder, "/", gene.trees[x]))

    #Removes taxa if it needs to
    if (is.null(taxa.remove) != TRUE){
      temp.tree = ape::drop.tip(temp.tree, taxa.remove)
    }

    #Skips if less than 4 taxa
    if (length(temp.tree$tip.label) < min.n.samples){
      print(paste0(gene.trees[x], " skipped, less than ", min.n.samples, " samples."))
      next
    }#end min sample check

    #Skips if less than the desire sampling proportion
    if (length(temp.tree$tip.label)/max.taxa < min.sample.prop){
      print(paste0(gene.trees[x], " skipped, less than ",
                   min.sample.prop, " proportion samples."))
      next
    }#end min sample check

    #Does the polytomy check
    if (make.polytomy == TRUE){
      #Find and collapse nodes with bl close to 0 from above
      temp.tree$node.label[temp.tree$node.label == ""] = "100"
      new.tree = AstralPlane::makePolytomy(tree = temp.tree, polytomy.limit = polytomy.limit)
    }

    #writes tree to a single file
    ape::write.tree(new.tree, file = paste0(output.name, "_genetrees.tre"), append = T)
    tree.counter = tree.counter + 1
  }#end x loop

  print(paste0(output.name, " complete! Wrote ", tree.counter,
               " gene trees to file: ", output.name, "_genetrees.tre"))

}#end setupAstral function


