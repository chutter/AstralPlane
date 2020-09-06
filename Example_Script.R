###############################################################################
#Installation section
###############

#Install ape and stringr the tradiational way
install.packages(c("ape", "stringr"))

#Install devtools
install.packages("devtools")
devtools::install_github("chutter/AstralPlane")

###############################################################################
#Load packages
###############

library(ape)
library(stringr)
library(devtools)
library(AstralPlane)


###############################################################################
#astral and working directory setup
###############

#You will want a variable that includes your full path to the astral jar file.
#NOTE: if you move this file, you will need to move the lib/ directory along with it.
astral.path = "/usr/local/bin/Astral-5-14/astral.5.14.2.jar"

#Create
work.dir = "/Volumes/Armored/Hylidae/Test_Astral"
dir.create(work.dir)
setwd(work.dir)


###############################################################################
#Single dataset example
###############

#Set up your directories
tree.dir = "/Users/chutter/Dropbox/Research/2_WIP/Hylidae/Trees/Gene_Trees/all-markers_trimmed"
outgroups = c("Phyllomedusa_tomopterna_WED_55506", "Nyctimystes_infrafrenatus_SLT_771")
save.name = "test-dataset"

#Setting up a single dataset
setupAstral(genetree.folder = tree.dir,
            output.name = save.name,
            min.n.samples = 4,
            min.sample.prop = 0,
            make.polytomy = TRUE,
            polytomy.limit = 10)

#Run astral for a single set of gene trees
runAstral(input.genetrees = save.name,
          output.name = save.name,
          astral.path = astral.path,
          astral.t = 2,
          quiet = FALSE,
          load.tree = FALSE,
          multi.thread = TRUE,
          memory = "8g")

#Read in the astral data and tree and organize it into different slots
astral.data = astralPlane(astral.tree = save.name,
                          astral.t = 2,
                          outgroups = outgroups,
                          tip.length = 1)


#Plots the astral data
astralProject(astral.plane = astral.data,
              local.posterior = TRUE,
              pie.plot = "qscore",
              save.file = "test-dataset.pdf",
              pie.colors = c("purple", "blue", "green"),
              node.color.text = c("white"),
              node.color.bg = c("black"),
              tip.label.size = 0.75,
              pie.chart.size = 1)




###############################################################################
#Single dataset example
###############

genetree.folder = "/Users/chutter/Dropbox/Research/2_WIP/Hylidae/Trees/Gene_Trees"
exon.tree = "/Volumes/Armored/Hylidae/Test_Astral/test-dataset/exon-only_trimmed_astral.tre"


#If you have many different datasets to set up and run, you can give it the folder
#of various datasets.
batchAstral(genetree.datasets = genetree.folder,
           astral.t = 2,
           output.dir = "test-dataset",
           min.n.samples = 4,
           min.sample.prop = 0.1,
           taxa.remove = NULL,
           overwrite = TRUE,
           quiet = F,
           astral.path = astral.path,
           make.polytomy = TRUE,
           polytomy.limit = 10,
           multi.thread = TRUE,
           memory = "8g")


#Read in the astral data and tree and organize it into different slots
astral.data = astralPlane(astral.tree = exon.tree,
                          astral.t = 2,
                          outgroups = outgroups,
                          tip.length = 1)

#Plots the astral data
astralProject(astral.plane = astral.data,
              local.posterior = TRUE,
              pie.plot = "qscore",
              save.file = "test-dataset.pdf",
              pie.colors = c("purple", "blue", "green"),
              node.color.text = c("white"),
              node.color.bg = c("black"),
              tip.label.size = 0.75,
              pie.chart.size = 1)




###### END SCRIPT
