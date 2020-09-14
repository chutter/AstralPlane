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
                              overwrite = TRUE,
                              quiet = TRUE,
                              threads = 1) {

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

