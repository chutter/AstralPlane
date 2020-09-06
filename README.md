# AstralPlane

R Package For Preparing, Running, Analyzing and Plotting from the Species Tree Program ASTRAL-III

This R package is meant to facilitate ASTRAL-III analyses and provide easy R plotting. The package helps prepare analyses from a folder of gene trees, runs astral from R, and creates a new S4 object type "AstralPlane" for easily analyzing the output from ASTRAL-III. The packageprovides several different types of plots, from pie charts on phylogenetic trees representing the quartet frequencies to plotting the gene tree frequencies as far plots. 

This package is still in beta testing phase, so if you find any issues with something not working, or you would like features to be added, go to issues in the top menu bar and submit them. 

For now, you can cite the R package by linking to this GitHub if you use it. 


# Installation

The major dependency for AstralPlane is of course the program ASTRAL-III. This program is Java-based and can be run on any machine that can run Java. 

ASTRAL-III is available on GitHub here: https://github.com/smirarab/ASTRAL

Instructions for installation and testing ASTRAL-III are included therein, and once it is up and running AstralPlane should be functional! 

The package has two R package dependencies: 
  ape (>= 5.0)
  stringr (>= 1.4)
  
And to install AstralPlane, you should use the R package devtools. 


