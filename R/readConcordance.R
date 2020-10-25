#' @title readConcordance
#'
#' @description Function for reading concordance factor data into a simple table
#'
#' @param file.name  file name of the .cf.stat file excluding ".cf.stat"
#'
#' @return a data.frame with the concordance factor data
#'
#' @examples
#'
#' your.tree = ape::read.tree(file = "file-path-to-tree.tre")
#' astral.data = astralPlane(astral.tree = your.tree,
#'                           outgroups = c("species_one", "species_two"),
#'                           tip.length = 1)
#'
#' @export


readConcordance = function(file.name = NULL) {

  #### *** MAKE S4 Object
  if (is.null(file.name) == TRUE){ stop("Error: A file name is needed.") }

  if (file.exists(file.name) == F){
    return(paste0("File in 'file.name' could not be found. Exiting."))
  }#end file check

  header.names = c("node","gCF","gCF_N","gDF1", "gDF1_N", "gDF2", "gDF2_N",
                   "gDFP", "gDFP_N", "gN", "sCF",	"sCF_N",	"sDF1",	"sDF1_N",
                   "sDF2",	"sDF2_N",	"sN",	"Label", "Length")

  #Read in stat file
  stat.file = read.table(paste0(file.name, ".cf.stat"), row.names = NULL,
                         header = T, skip = 25, comment.char = "#")
  colnames(stat.file) = header.names

  #combines the data
  save.data = cbind(Dataset = file.name, stat.file)

  return(save.data)

}#end function


