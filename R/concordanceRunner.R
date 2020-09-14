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
                             overwrite = TRUE,
                             quiet = TRUE,
                             threads = 1) {

  #Loads in the directory
  if (overwrite == TRUE){
    system(paste0("rm -r ", output.dir))
    dir.create(output.dir) }

  #Checks for overwrite
  if (overwrite == FALSE){
    if(file.exists(output.dir) == TRUE){
      stop("Error: overwrite = F and folder exists")
    }#end if
  }#end if

  #Loads in the files
  a.files = list.files(species.tree.dir)
  align.files = list.files(alignment.dir)
  gene.files = list.files(genetree.dir)

  #Loops through and does concordance factors on each filtered tree
  for (i in 1:length(a.files)){

    dataset.name = gsub("_astral.tre$", "", a.files[i])

    sub.align = align.files[grep(dataset.name, align.files)]
    align.file = sub.align[grep(".phy$", sub.align)]
    part.file = sub.align[grep("_raxml.txt$", sub.align)]
    gene.tree = gene.files[grep(dataset.name, gene.files)]

    concordanceFactors(species.tree = paste0(species.tree.dir, "/", a.files[i]),
                       alignment = paste0(alignment.dir, "/", align.file),
                       gene.trees = paste0(genetree.dir, "/", gene.tree),
                       output.name = paste0(output.dir, "/", dataset.name),
                       quiet = quiet, threads = threads)

  }#end i loop

}#end function

