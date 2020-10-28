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
#' @param overwrite overwrite = TRUE to overwrite existing files
#'
#' @param quiet hides the screen output from astral if desired
#'
#' @param threads how many threads to use
#'
#' @return IQTree concordance factors are run using this function as a wrapper. The CF output is saved to file, and can be read into R using the function "readConcordance".
#'
#' @examples
#'
#' paths
#' genetree.path = paste0(work.dir, "/filtered-genetrees-concatenated")
#' alignment.path = paste0(work.dir, "/filtered-alignments-concatenated")
#' output.path = "concordance-factors"
#' astral.tree.path = paste0(work.dir, "/", astral.dir)
#'
#' concordanceRunner(alignment.dir = alignment.path,
#'                  species.tree.dir = astral.tree.path,
#'                  genetree.dir = genetree.path,
#'                  output.dir = "concordance-factors",
#'                  overwrite = TRUE,
#'                  quiet = TRUE,
#'                  threads  = 6)
#'
#' @export


#Concordance factors function
concordanceRunner = function(alignment.dir = NULL,
                             species.tree.dir = NULL,
                             genetree.dir = NULL,
                             output.dir = "concordance-factors",
                             overwrite = FALSE,
                             quiet = TRUE,
                             threads = 1) {

  # alignment.dir = paste0(work.dir, "/filtered-alignments-concatenated")
  # species.tree.dir = paste0(work.dir, "/filtered-astral")
  # genetree.dir = paste0(work.dir, "/filtered-genetrees-concatenated")
  # output.dir = "concordance-factors"
  # overwrite = TRUE
  # quiet = TRUE
  # threads  = 6

  #Missing stuff checks
  if (is.null(species.tree.dir) == TRUE){ stop("Error: A directory of species trees must be provided.")}
  if (is.null(alignment.dir) == TRUE){ stop("Error: A directory of alignments must be provided.")}
  if (is.null(genetree.dir) == TRUE){ stop("Error: A directory of gene trees must be provided.")}
  if (is.null(output.dir) == TRUE){ stop("Error: An output directory must be provided.")}

  #Check if files exist or not
  if (dir.exists(alignment.dir) == F){
    return(paste0("Directory of alignments could not be found. Exiting."))
  }#end file check

  #Check if files exist or not
  if (dir.exists(genetree.dir) == F){
    return(paste0("Directory of gene trees could not be found. Exiting."))
  }#end file check

  #Check if files exist or not
  if (dir.exists(species.tree.dir) == F){
    return(paste0("Directory of species trees could not be found. Exiting."))
  }#end file check

  #Loads in the directory
  if (overwrite == TRUE){
    system(paste0("rm -r ", output.dir))
    dir.create(output.dir) } else { dir.create(output.dir) }

  #Loads in the files
  a.files = list.files(species.tree.dir)
  align.files = list.files(alignment.dir)
  gene.files = list.files(genetree.dir)

  #Loops through and does concordance factors on each filtered tree
  for (i in 1:length(a.files)){

    dataset.name = gsub("_astral.tre$", "", a.files[i])

    sub.align = align.files[grep(paste0(dataset.name, "$"), gsub(".phy$", "", align.files))]
    align.file = sub.align[grep(".phy$", sub.align)]
    gene.tree = gene.files[grep(paste0(dataset.name, "$"), gsub("_genetrees.tre", "", gene.files))]

    #Overwrite check
    if (overwrite == FALSE){
      if (file.exists(paste0(output.dir, "/", dataset.name, ".cf.stat")) == TRUE){
        print(paste0("skipping ", dataset.name, "; file already exists and overwrite = FALSE."))
        next }
    }#end overwrite if

    concordanceFactors(species.tree = paste0(species.tree.dir, "/", a.files[i]),
                       alignment = paste0(alignment.dir, "/", align.file),
                       gene.trees = paste0(genetree.dir, "/", gene.tree),
                       output.name = paste0(output.dir, "/", dataset.name),
                       quiet = quiet,
                       threads = threads,
                       overwrite = overwrite)

    print(paste0(dataset.name, " has finished concordance factor analysis!"))

  }#end i loop

}#end function

