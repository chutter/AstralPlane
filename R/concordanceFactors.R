#' @title concordanceRunner
#'
#' @description This function runs many concordance factor analyses using IQTREE2
#'
#' @param alignment.dir a folder of alignment files that are concatenated.
#'
#' @param species.tree.dir a folder of species trees (e.g. from astral) to assess concordance
#'
#' @param genetree.dir a folder of genetree files that are concatenated.
#'
#' @param output.dir the output directory name for the astral file
#'
#' @param overwrite overwrite if file exists?
#'
#' @param quiet hides the screen output from astral if desired
#'
#' @param threads how many threads to use
#'
#' @return IQTree concordance factors are run using this function as a wrapper. The CF output is saved to file, and can be read into R using the function "readConcordance".
#'
#' @examples
#'
#' concordanceFactors(species.tree = paste0(species.tree.dir, "/", a.files[i]),
#'                    alignment = paste0(alignment.dir, "/", align.file),
#'                    gene.trees = paste0(genetree.dir, "/", gene.tree),
#'                    output.name = paste0(output.dir, "/", dataset.name),
#'                    quiet = quiet, threads = threads)
#'
#' @export

#Concordance factors function
concordanceFactors = function(species.tree = NULL,
                              alignment = NULL,
                              gene.trees = NULL,
                              output.name = NULL,
                              overwrite = FALSE,
                              quiet = TRUE,
                              threads = 1) {

  #Missing stuff checks
  if (is.null(species.tree) == TRUE){ stop("Error: A species tree must be provided.")}
  if (is.null(alignment) == TRUE){ stop("Error: A directory of alignments must be provided.")}
  if (is.null(gene.trees) == TRUE){ stop("Error: A directory of gene trees must be provided.")}
  if (is.null(output.name) == TRUE){ stop("Error: An output name must be provided.")}

  #Check if files exist or not
  if (dir.exists(alignment) == F){
    return(paste0("Folder of alignments could not be found. Exiting."))
  }#end file check

  #Check if files exist or not
  if (dir.exists(gene.trees) == F){
    return(paste0("Folder of gene trees could not be found. Exiting."))
  }#end file check

  #Check if files exist or not
  if (file.exists(species.tree) == F){
    return(paste0("Species tree could not be found. Exiting."))
  }#end file check

  #Loads in the directory
  if (overwrite == TRUE){
    if(file.exists(paste0(output.name, ".log")) == TRUE){
      system(paste0("rm ", output.name, "*"))
      }#end file exists
  }#end overwrite

  #Checks for overwrite
  if (overwrite == FALSE){
    if(file.exists(paste0(output.name, ".log")) == TRUE){
      stop("Error: overwrite = F and file exists")
    }#end if
  }#end if

  system(paste0("iqtree2 -t ", species.tree,
                " --gcf ", gene.trees,
                " -s ", alignment,
                " --scf 100 --prefix ", output.name,
                " -nt ", threads), ignore.stdout = quiet)

}#end function

