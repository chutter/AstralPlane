###############################################################################
#Installation section
###############

#Install ape and stringr the tradiational way
install.packages(c("ape", "stringr"))
#Install devtools
install.packages("devtools")
#Install AstralPlane
devtools::install_github("chutter/AstralPlane")

###############################################################################
#Load packages
###############
library(AstralPlane)


###############################################################################
#astral and working directory setup
###############

#You will want a variable that includes your full path to the astral jar file.
#NOTE: if you move this file, you will need to move the lib/ directory along with it.
astral.path = "/usr/local/bin/Astral-5-14/astral.5.14.2.jar"

#Create
work.dir = "/Users/chutter/Dropbox/Research/1_Main-Projects/0_Working-Projects/Hylidae"
dir.create(work.dir)
setwd(work.dir)


###############################################################################
#Single dataset example
###############

#Set up your directories
tree.dir = "/Users/chutter/Dropbox/Research/1_Main-Projects/0_Working-Projects/Hylidae/Trees/Gene_Trees/all-markers_trimmed"
outgroups = c("Phyllomedusa_tomopterna_WED_55506", "Nyctimystes_infrafrenatus_SLT_771")
save.name = "test-dataset"

#Setting up a single dataset
setupAstral(genetree.folder = tree.dir,
            output.name = save.name,
            overwrite = TRUE,
            min.n.samples = 4,
            min.sample.prop = 0,
            make.polytomy = TRUE,
            polytomy.limit = 10)

#Run astral for a single set of gene trees
runAstral(input.genetrees = paste0(save.name, "_genetrees.tre"),
          output.name = save.name,
          astral.path = astral.path,
          astral.t = 2,
          quiet = FALSE,
          overwrite = TRUE,
          load.tree = FALSE,
          multi.thread = TRUE,
          memory = "8g")

#Read in the astral data and tree and organize it into different slots
astral.data = createAstralPlane(astral.tree = save.name,
                                outgroups = outgroups,
                                tip.length = 1)

#Plots the astral data
astralProjection(astral.plane = astral.data,
                 local.posterior = TRUE,
                 pie.plot = TRUE,
                 pie.data = "qscore",
                 save.file = NULL,
                 pie.colors = c("purple", "blue", "green"),
                 node.color.text = c("white"),
                 node.color.bg = c("black"),
                 tip.label.size = 0.75,
                 pie.chart.size = 1)

###############################################################################
###############################################################################
###############################################################################
###############################################################################
# Multi-dataset example
###############

library(AstralPlane)

work.dir = "/Users/chutter/Dropbox/Research/1_Main-Projects/0_Working-Projects/Hylidae"
genetree.folder = "/Users/chutter/Dropbox/Research/1_Main-Projects/0_Working-Projects/Hylidae/Trees/Gene_Trees"

setwd(work.dir)

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

#Obtains dataset names
datasets = list.dirs(genetree.folder, full.names = F, recursive = F)

for (i in 1:length(datasets)){

  #Read in the astral data and tree and organize it into different slots
  dataset.name = paste0("test-dataset/", datasets[i], "_astral.tre")
  astral.data = createAstralPlane(astral.tree = dataset.name,
                                  outgroups = outgroups,
                                  tip.length = 1)

  #Plots the astral data
  astralProjection(astral.plane = astral.data,
                   local.posterior = TRUE,
                   pie.plot = TRUE,
                   pie.data = "qscore",
                   save.file = paste0("test-dataset/", datasets[i], ".pdf"),
                   pie.colors = c("purple", "blue", "green"),
                   node.color.text = c("white"),
                   node.color.bg = c("black"),
                   tip.label.size = 0.75,
                   pie.chart.size = 1)

}#end i loop



###### END SCRIPT
