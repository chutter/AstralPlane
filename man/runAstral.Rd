% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/runAstral.R
\name{runAstral}
\alias{runAstral}
\title{runAstral}
\usage{
runAstral(
  input.genetrees = NULL,
  output.name = NULL,
  astral.path = NULL,
  astral.t = 2,
  quiet = TRUE,
  load.tree = FALSE,
  overwrite = FALSE,
  multi.thread = TRUE,
  memory = "1g"
)
}
\arguments{
\item{input.genetrees}{a file of genetrees from setupAstral}

\item{output.name}{the save name for the astral file}

\item{astral.path}{the absolute path to astral. Needed because astral needs it.}

\item{astral.t}{the t value from astral for different annotations. t = 2, all annotations is recommended for full functionality}

\item{quiet}{hides the screen output from astral if desired}

\item{load.tree}{should the tree be loaded into R?}

\item{overwrite}{whether to overwrite an existing dataset}

\item{multi.thread}{whether to use Astral-MP multithreading or not.}

\item{memory}{memory value to be passed to java. Should be in "Xg" format, X = an integer}
}
\value{
Astral is run using this function as a wrapper. The astral output is saved to file, and can optionally be read into R as an ape phylo object using load.tree = TRUE.
}
\description{
This function sets up an astral run from gene trees
}
\examples{

genetree.folder = "file/path/to/folder/of/genetrees"
taxa.delete = c("species_one", "species_two")
save.name = "test-dataset"

setupAstral(genetree.folder = genetree.folder,
            output.name = save.name,
            overwrite = TRUE,
            taxa.remove = taxa.delete,
            min.n.samples = 4,
            min.sample.prop = 0.1,
            make.polytomy = TRUE,
            polytomy.limit = 10)

runAstral(input.genetrees = save.name,
          output.name = save.name,
          astral.path = astral.path,
          astral.t = 2,
          quiet = F,
          load.tree = FALSE,
          multi.thread = TRUE,
          memory = "8g")

}
