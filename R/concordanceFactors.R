#' @title concordanceFactors
#'
#' @description This function runs concordance factor analyses using IQTREE2
#'
#' @param alignment a concatenated alignment file
#'
#' @param species.tree a species trees (e.g. from astral) to assess concordance
#'
#' @param gene.trees a folder of genetree files that are concatenated.
#'
#' @param output.name the output name for the concordance files
#'
#' @param iqtree.path the full path to the iqtree executable if R cannot find it in the R path
#'
#' @param overwrite overwrite = TRUE to overwrite existing files
#'
#' @param quiet hides the screen output from astral if desired
#'
#' @param threads how many threads to use
#'
#' @return IQ-TREE 2 concordance factors files
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
                              iqtree.path = "iqtree2",
                              overwrite = FALSE,
                              quiet = TRUE,
                              threads = 1) {

  # species.tree = paste0(species.tree.dir, "/", a.files[i])
  # alignment = paste0(alignment.dir, "/", align.file)
  # gene.trees = paste0(genetree.dir, "/", gene.tree)
  # output.name = paste0(output.dir, "/", dataset.name)
  # quiet = quiet
  # threads = threads
  # overwrite = overwrite

  #Missing stuff checks
  if (is.null(species.tree) == TRUE){ stop("Error: A species tree must be provided.")}
  if (is.null(alignment) == TRUE){ stop("Error: A directory of alignments must be provided.")}
  if (is.null(gene.trees) == TRUE){ stop("Error: A directory of gene trees must be provided.")}
  if (is.null(output.name) == TRUE){ stop("Error: An output name must be provided.")}

  #Check if files exist or not
  if (file.exists(alignment) == F){
    return(paste0("Alignment could not be found. Exiting."))
  }#end file check

  #Check if files exist or not
  if (file.exists(gene.trees) == F){
    return(paste0("Folder of gene trees could not be found. Exiting."))
  }#end file check

  #Check if files exist or not
  if (file.exists(species.tree) == F){
    return(paste0("Species tree could not be found. Exiting."))
  }#end file check

  #Loads in the directory
  if (overwrite == TRUE){
    if(file.exists(paste0(output.name, ".cf.stat")) == TRUE){
      system(paste0("rm ", output.name, "*"))
      }#end file exists
  }#end overwrite

  #Checks for overwrite
  if (overwrite == FALSE){
    if(file.exists(paste0(output.name, ".cf.stat")) == TRUE){
      return("Overwrite = F and file exists. Skipping.")
    }#end if
  }#end if

  system(paste0(iqtree.path, " -t ", species.tree,
                " --gcf ", gene.trees,
                " -s ", alignment,
                " --scf 100 --prefix ", output.name,
                " -nt ", threads), ignore.stdout = quiet)

}#end function

