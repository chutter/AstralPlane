#' @title astralRunner
#'
#' @description This function runs many astral analyses across a folder of concatenated gene trees
#'
#' @param concat.genetree.folder a folder of genetree files that are concatenated.
#'
#' @param output.dir the output directory name for the astral file
#'
#' @param overwrite overwrite = TRUE to overwrite existing files
#'
#' @param astral.path the absolute file path to the ASTRAL-III jar file
#'
#' @param astral.t the ASTRAL-III "t" parameter for different annotations, t = 2 is all annotation
#'
#' @param quiet TRUE hides the screen output from astral 
#'
#' @param multi.thread TRUE to use Astral-MP multithreading 
#'
#' @param memory memory value to be passed to java. Should be in "Xg" format, X = an integer
#'
#' @return Astral is run using this function as a wrapper. The astral output is saved to file, and can optionally be read into R as an ape phylo object using load.tree = TRUE.
#'
#' @examples
#'
#'
#' @export


astralRunner = function(concat.genetree.folder = NULL,
                        output.dir = NULL,
                        overwrite = FALSE,
                        astral.path = NULL,
                        astral.t = 2,
                        quiet = TRUE,
                        multi.thread = TRUE,
                        memory = "1g"){

  #Checks
  if (is.null(concat.genetree.folder) == TRUE){ stop("No gene trees provided.") }
  if (is.null(output.dir) == TRUE){ stop("No output save name provided.") }
  if (is.null(astral.path) == TRUE){ stop("A full path to your astral JAR file is needed.") }

  #Check if files exist or not
  if (file.exists(astral.path) == F){
    return(paste0("Astral jar file could not be found. Exiting."))
  }#end file check

  #Sets up directory for output
  if (dir.exists(output.dir) == F){ dir.create(output.dir) }
  #Checks for output directory and creates it if not found
  if (overwrite == TRUE){
    if (dir.exists(output.dir) == T){
      unlink(output.dir, recursive = T)
      dir.create(output.dir)
    }#end dir exist
  }#end overwrite

  concat.genetrees = list.files(concat.genetree.folder)

  #sink(file="Astral_log.txt", append = TRUE, type = "output")

  for (x in 1:length(concat.genetrees)){

    #print(paste0("Running ", concat.genetrees[x], " through Astral ...."))
    concat.name = gsub("_genetrees.tre", "", concat.genetrees[x])
    input.trees = paste0(concat.genetree.folder, "/", concat.genetrees[x])
    out.name = paste0(output.dir, "/", concat.name)

    if (overwrite == FALSE){
      if (file.exists(paste0(out.name, "_astral.tre")) == TRUE){
        print(paste0("skipping ", out.name, "; file already exists and overwrite = FALSE."))
        next }
    }#end overwrite if

    #Runs astral
    runAstral(input.genetrees = input.trees,
              output.name = out.name,
              astral.path = astral.path,
              astral.t = astral.t,
              quiet = quiet,
              overwrite = overwrite,
              load.tree = FALSE,
              multi.thread = multi.thread,
              memory = memory)

    print(paste0("Finished ASTRAL run for ", concat.genetrees[x], "!"))

  }#end x loop

 # sink()

}#end function

