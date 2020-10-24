#' @title astralRunner
#'
#' @description This function runs many astral analyses across a folder of concatenated gene trees
#'
#' @param concat.genetree.folder a folder of genetree files that are concatenated.
#'
#' @param output.dir the output directory name for the astral file
#'
#' @param overwrite overwrite if file exists?
#'
#' @param astral.path the absolute path to astral. Needed because astral needs it.
#'
#' @param astral.t the t value from astral for different annotations. t = 2, all annotations is recommended for full functionality
#'
#' @param quiet hides the screen output from astral if desired
#'
#' @param multi.thread whether to use Astral-MP multithreading or not.
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

  #Sets up directory for output
  if (dir.exists(output.dir) == F){ dir.create(output.dir) }
  #Checks for output directory and creates it if not found
  # if (overwrite == TRUE){
  #   if (dir.exists(output.dir) == T){
  #     unlink(output.dir, recursive = T)
  #     dir.create(output.dir)
  #   }#end dir exist
  # }#end overwrite

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

    print(paste0("Finished ", concat.genetrees[x], "!"))

  }#end x loop

 # sink()

}#end function

