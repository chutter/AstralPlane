#' @title batchAstral
#'
#' @description Function for running many astral analyses across many datasets. Runs setupAstral and runAstral when given a folder that contains folders of gene trees.
#'
#' @param genetree.datasets a folder with folders of genetrees to prepare for astral analyses
#'
#' @param output.dir the save name for the output directory
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
#' @param astral.path the absolute path to astral. Needed because astral needs it.
#'
#' @param astral.t the t value from astral for different annotations.
#'
#' @param quiet hides the screen output from astral if desired
#'
#' @param multi.thread whether to use Astral-MP multithreading or not.
#'
#' @param memory memory value to be passed to java. Should be in "Xg" format, X = an integer
#'
#' @return applies setupAstral and runAstral to a folder, that contains folders of gene trees. Facilitates running the preparation and ASTRAL-III analysis for many different datasets at once. Genetree files and the astral output are saved in the desired output directory that can be read in individually as an AstralPlane object and plooted using AstralProjection.
#'
#' @examples
#'
#' genetree.folder = "file/path/to/folder/of/genetree/folders"
#' taxa.delete = c("species_one", "species_two")
#'
#' batchAstral(genetree.datasets = genetree.folder,
#'             output.dir = "test-dataset",
#'             overwrite = TRUE,
#'             taxa.remove = taxa.delete,
#'             min.n.samples = 4,
#'             min.sample.prop = 0.1,
#'             make.polytomy = TRUE,
#'             polytomy.limit = 10,
#'             astral.path = astral.path,
#'             astral.t = 2,
#'             quiet = F,
#'             multi.thread = TRUE,
#'             memory = "8g")
#'
#' @export


batchAstral = function(genetree.datasets = NULL,
                       output.dir = NULL,
                       overwrite = TRUE,
                       taxa.remove = NULL,
                       min.n.samples = 4,
                       min.sample.prop = NULL,
                       make.polytomy = TRUE,
                       polytomy.limit = 0,
                       astral.path = NULL,
                       astral.t = 2,
                       quiet = TRUE,
                       multi.thread = TRUE,
                       memory = "1g") {

  #Checks for missing stuff
  if (is.null(genetree.datasets) == TRUE){ stop("No gene tree folder provided.") }
  if (is.null(output.dir) == TRUE){ stop("No output directory provided.") }
  if (is.null(astral.path) == TRUE){ stop("A full path to your astral JAR file is needed.") }

  #Sets up directory for output
  if (dir.exists(output.dir) == F){ dir.create(output.dir) }
  #Checks for output directory and creates it if not found
  if (overwrite == TRUE){
    if (dir.exists(output.dir) == T){
      unlink(output.dir, recursive = T)
      dir.create(output.dir)
    }#end dir exist
  }#end overwrite

  #Loops through and runs each datasset
  dataset.dirs = list.dirs(genetree.folder, recursive = FALSE)
  for (x in 1:length(dataset.dirs)){

    dataset.name = gsub(".*/", "", dataset.dirs[x])

    AstralPlane::setupAstral(min.n.samples = min.n.samples,
                min.sample.prop = min.sample.prop,
                genetree.folder = dataset.dirs[x],
                taxa.remove = taxa.remove,
                output.name = paste0(output.dir, "/", dataset.name),
                make.polytomy = make.polytomy,
                polytomy.limit = polytomy.limit,
                overwrite = TRUE)

    #Moves to new folder
    out.file = paste0(dataset.name, "_genetrees.tre")

    createAstralPlane::runAstral(input.genetrees = paste0(output.dir, "/", out.file),
                                 astral.t = astral.t,
                                 output.name = paste0(output.dir, "/", dataset.name),
                                 quiet = quiet,
                                 astral.path = astral.path,
                                 memory = memory,
                                 multi.thread = TRUE,
                                 load.tree = FALSE)

    print(paste0("Finished ", dataset.name, "!"))

  }#end x loop

}#end manyAstral

