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

The package has two R package dependencies: 
  ape (>= 5.0)
  stringr (>= 1.4)
  
And to install AstralPlane, you can use the R package devtools. Here are step-by-step instructions for installation:

1) Install devtools by typing "install.packages(devtools)" in your R console. 

2) Install AstralPlane by typing in your R console: "devtools::install_github("chutter/AstralPlane")"

3) Devtools will ask you to install the package dependecies (ape and stringr), select "Yes". If devtools asks you to update packages, you may choose to do so. I would recommend not to install packages from source if devtools asks you. Ape is problemic from source and I could not get it to install on my machine. If devtools is still giving you trouble, you can install the dependencies with "install.packages(c("ape", "stringr"))". Then rerun Step 2 and skip package updates. 

4) Devtools should finish and say the package loaded properly. Load the package with library(AstralPlane). 

And you should be done! 


# Usage and examples 

I have included an R script in the main repository with some examples. It is also described here in detail. 

1) first load in your R packages.

```
library(ape)
library(stringr)
library(devtools)
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

Second, the setupAstral function is used to take your folder of gene trees, apply some filters to the gene trees, and then save them in a single file that can be read by ASTRAL-III. 

Parameter explanations: 

genetree.folder: a folder of genetrees to prepare for astral analyses
output.name: the save name for your concatenated gene tree file
overwrite: whether to overwrite an existing dataset
taxa.remove: species that you would like removed from each gene tree
min.n.samples: the minimum number of samples to keep a gene tree
min.sample.prop: the minimum proportion of samples to keep a gene tree
make.polytomy: whether to collapse poorly supported nodes into polytomies
polytomy.limit: if make.polytomy = TRUE, the threshold value for node collapsing


```
setupAstral(genetree.folder = tree.dir,
            output.name = save.name,
            min.n.samples = 4,
            min.sample.prop = 0,
            make.polytomy = TRUE,
            polytomy.limit = 10)
```












