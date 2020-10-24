#' @title runAstral
#'
#' @description This function sets up an astral run from gene trees
#'
#' @param input.genetrees a file of genetrees from setupAstral
#'
#' @param output.name the save name for the astral file
#'
#' @param astral.path the absolute path to astral. Needed because astral needs it.
#'
#' @param astral.t the t value from astral for different annotations. t = 2, all annotations is recommended for full functionality
#'
#' @param quiet hides the screen output from astral if desired
#'
#' @param load.tree should the tree be loaded into R?
#'
#' @param multi.thread whether to use Astral-MP multithreading or not.
#'
#' @param memory memory value to be passed to java. Should be in "Xg" format, X = an integer
#'
#' @return Astral is run using this function as a wrapper. The astral output is saved to file, and can optionally be read into R as an ape phylo object using load.tree = TRUE.
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
#' runAstral(input.genetrees = save.name,
#'           output.name = save.name,
#'           astral.path = astral.path,
#'           astral.t = 2,
#'           quiet = F,
#'           load.tree = FALSE,
#'           multi.thread = TRUE,
#'           memory = "8g")
#'
#' @export


runAstral = function(input.genetrees = NULL,
                     output.name = NULL,
                     astral.path = NULL,
                     astral.t = 2,
                     quiet = TRUE,
                     load.tree = FALSE,
                     overwrite = FALSE,
                     multi.thread = TRUE,
                     memory = "1g") {

  if (is.null(input.genetrees) == TRUE){ stop("Error: No gene tree file provided.") }
  if (is.null(output.name) == TRUE){ stop("Error: No output save name provided.") }
  if (is.null(astral.path) == TRUE){ stop("Error: A full path to your astral JAR file is needed.") }

  if (overwrite == FALSE){
    if (file.exists(paste0(output.name, "_astral.tre")) == TRUE){
      stop("Error: overwrite = FALSE and file exists.")
      }
  }#end overwrite if

  input.genetrees = paste0(input.genetrees)

  if (file.exists(input.genetrees) == FALSE){ input.genetrees = paste0(input.genetrees, "_genetrees.tre") }

  if (multi.thread == TRUE){

    as.command = gsub(".*/", "", astral.path)
    lib.path = paste0(gsub(as.command, "", astral.path), "lib/")

    system(paste0("java -D\"java.library.path=", lib.path, "\" -Xmx",
                memory, " -jar ", astral.path,
               " -i ", input.genetrees,
               " -t ", astral.t, " -o ", output.name, "_astral.tre"), ignore.stderr = quiet)
  } else {

    system(paste0("java -Xmx", memory, " -jar ", astral.path,
                " -i ", input.genetrees,
                " -t ", astral.t, " -o ", output.name, "_astral.tre"),
                  ignore.stderr = quiet)
}

  if (load.tree == TRUE){
    tree = ape::read.tree(file = paste0(output.name, "_astral.tre"))
    return(tree)
  }

} #end runAstral


