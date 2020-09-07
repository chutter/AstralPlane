# AstralPlane

R Package For Preparing, Running, Analyzing and Plotting from the Species Tree Program ASTRAL-III

This R package is meant to facilitate ASTRAL-III analyses and provide easy R plotting. The package helps prepare analyses from a folder of gene trees, runs astral from R, and creates a new S4 object type "AstralPlane" for easily analyzing the output from ASTRAL-III. The packageprovides several different types of plots, from pie charts on phylogenetic trees representing the quartet frequencies to plotting the gene tree frequencies as far plots. 

This package is still in beta testing phase, and more features and expanded functionality will be added in the future. Now, the package can run a standard ASTRAL-III analysis, read in the analysis results, and create pie-chart tree plots. 

If you find any issues with something not working, or you would like features to be added, go to issues in the top menu bar and submit them. 

For now, you can cite the R package by linking to this GitHub if you use it. 


# Installation

The major dependency for AstralPlane is of course the program ASTRAL-III. This program is Java-based and can be run on any machine that can run Java. 

ASTRAL-III is available on GitHub here: https://github.com/smirarab/ASTRAL

Instructions for installation and testing ASTRAL-III are included therein, and once it is up and running AstralPlane should be functional! 

The package has two R package dependencies, which are treated as imports (i.e. you need them installed, but library(ape) and library(stringr) not needed: 
  ape (>= 5.0)
  stringr (>= 1.4)
  
And to install AstralPlane, you can use the R package devtools. Here are step-by-step instructions for installation:

1) Install devtools by typing "install.packages(devtools)" in your R console. 

2) Install AstralPlane by typing in your R console: "devtools::install_github("chutter/AstralPlane")"

3) Devtools will ask you to install the package dependecies (ape and stringr), select "Yes". If devtools asks you to update packages, you may choose to do so. I would recommend not to install packages from source if devtools asks you. Ape is problemic from source and I could not get it to install on my machine. If devtools is still giving you trouble, you can install the dependencies with "install.packages(c("ape", "stringr"))". Then rerun Step 2 and skip package updates. 

4) Devtools should finish and say the package loaded properly. Load the package with library(AstralPlane). 

And you should be done! 


# Mini-Vingette: Usage and single dataset example 

I have included an R script in the main repository with some examples. It is also described here in detail. 

1) first install and load the R package. Its a good idea to install new (or check) every time as this package is being updated frequently. 

```
devtools::install_github("chutter/AstralPlane")
library(AstralPlane)

```

2) You will want a character variable that includes your full path to the astral jar file. NOTE: if you move this file, you will need to move the lib/ directory along with it, as astral depends on it. 


```
astral.path = "/usr/local/bin/Astral-5-14/astral.5.14.2.jar"
```

3)Setup your working directory and create if necessary

```
work.dir = "/Test_Astral"
dir.create(work.dir)
setwd(work.dir)
```

4) Next, this step will walk through a single dataset example. 

First, you will want to add a character variable with the path to your gene tree directory. The gene trees here were generated using IQTree and the script should work with other tree types as well, as long as they have branch lengths and support values. Also indicate your outgroups for rooting the tree later. Finally, the output name can be put in a variable or directly entered, your choice. 

```
tree.dir = "/Trees/Gene_Trees/trimmed_exons"
outgroups = c("Species_A", "Species_B")
save.name = "test-dataset"

```

5) the setupAstral function is used to take your folder of gene trees, apply some filters to the gene trees, and then save them in a single file that can be read by ASTRAL-III. This should take about a minute to run. 


```
setupAstral(genetree.folder = tree.dir,
            output.name = save.name,
            min.n.samples = 4,
            min.sample.prop = 0,
            make.polytomy = TRUE,
            polytomy.limit = 10)
```

Parameter explanations: 

```
genetree.folder: a folder of genetrees to prepare for astral analyses
output.name: the save name for your concatenated gene tree file
overwrite: whether to overwrite an existing dataset
taxa.remove: species that you would like removed from each gene tree
min.n.samples: the minimum number of samples to keep a gene tree
min.sample.prop: the minimum proportion of samples to keep a gene tree
make.polytomy: whether to collapse poorly supported nodes into polytomies
polytomy.limit: if make.polytomy = TRUE, the threshold value for node collapsing
```

6) When the setup function finishes running, you can now run ASTRAL-III using the runAstral function. This uses the astral jar directly, and should a minute or two depending on your number of gene trees using multi-threading and around 10 without the multi-threading option. 

```
runAstral(input.genetrees = save.name,
          output.name = save.name,
          astral.path = astral.path,
          astral.t = 2,
          quiet = FALSE,
          load.tree = FALSE,
          multi.thread = TRUE,
          memory = "8g")
```

Parameter explanations: 

```
input.genetrees: a file of genetrees from setupAstral
output.name: the save name for the astral file
astral.path: the absolute path to astral. Needed because astral needs it.
astral.t: the t value from astral for different annotations. t = 2, all annotations is recommended for full functionality
quiet: hides the screen output from astral if desired
load.tree: should the tree be loaded into R?
multi.thread: whether to use Astral-MP multithreading or not.
memory: memory value to be passed to java. Should be in "Xg" format, X = an integer
```

7) Next, you can read in the astral data using the astralPlane S4 Object class, which organizes all the analysis data into different slots in the object that can be accessed using the @ symbol. 


```
astral.data = astralPlane(astral.tree = save.name,
                          outgroups = outgroups,
                          tip.length = 1)
```

Parameter explanations: 

```
astral.tree: phylogenetic tree from ape read.tree
outgroups: a vector of outgroups to root the tree
tip.length: arbitrary value for the terminal tip lengths, Astral does not compute this
```

8) Finally, you can plot your results using the astralProjection function. You give the function the astralPlane object from the previous step, and select your settings for plotting, and what you would like to plot. An example plot is provided in the main Github repository. 

```
astralProjection(astral.plane = astral.data,
                 local.posterior = TRUE,
                 pie.plot = "qscore",
                 save.file = "example_plot.pdf",
                 pie.colors = c("purple", "blue", "green"),
                 node.color.text = c("white"),
                 node.color.bg = c("black"),
                 tip.label.size = 0.75,
                 pie.chart.size = 1)
```


Parameter explanations: 

```
astral.plane: AstralPlane S4 object of data generated from AstralPlane function
local.posterior: plot the local posterior support?
pie.plot: select one to plot: 'qscore' the quartet support or 'genetree' proportion of gene trees that support a branch
save.file: if you wish to save to file, put file name. Saves as PDF
pie.colors: select three colors to plot your pie.plot
node.color.text: if local.posterior = TRUE, select the color of posterior support text
node.color.bg: if local.posterior = TRUE, select the color of posterior support background
tip.label.size: size of the tip labels, passed to cex in plotting function
pie.chart.size: size of pie chart, passed to edgelabel plotting function

```


# Mini-Vingette: Usage and many dataset example 


Coming soon!


