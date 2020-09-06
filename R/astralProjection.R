#' @title AstralProjection
#'
#' @description Function for plotting data from the astralPlane format
#'
#' @param astral.plane AstralPlane S4 object of data generated from AstralPlane function
#'
#' @param local.posterior plot the local posterior support?
#'
#' @param pie.plot select one to plot: 'qscore' the quartet support or 'genetree' proportion of gene trees that support a branch
#'
#' @param save.file if you wish to save to file, put file name. Saves as PDF
#'
#' @param pie.colors select three colors to plot your pie.plot
#'
#' @param node.color.text if local.posterior = TRUE, select the color of posterior support text
#'
#' @param node.color.bg if local.posterior = TRUE, select the color of posterior support background
#'
#' @param tip.label.size size of the tip labels, passed to cex in plotting function
#'
#' @param pie.chart.size size of pie chart, passed to edgelabel plotting function
#'
#' @return plots the phylogenetic tree and selected data associated with an AstralPlane object. Can optionally be saved to file as a PDF by giving save.file a file name.
#'
#' @examples
#'
#' your.tree = ape::read.tree(file = "file-path-to-tree.tre")
#' astral.data = astralPlane(astral.tree = your.tree,
#'                           outgroups = c("species_one", "species_two"),
#'                           tip.length = 1)
#'
#' astralProjection(astral.plane = astral.data,
#'                  local.posterior = TRUE,
#'                  pie.plot = "qscore",
#'                  save.file = "test-dataset.pdf",
#'                  pie.colors = c("purple", "blue", "green"),
#'                  node.color.text = c("white"),
#'                  node.color.bg = c("black"),
#'                  tip.label.size = 0.75,
#'                  pie.chart.size = 1)
#'
#' @export


astralProjection = function(astral.plane = NULL,
                            local.posterior = TRUE,
                            pie.plot = c("qscore", "genetree"),
                            save.file = NULL,
                            pie.colors = c("black", "grey", "white"),
                            node.color.text = c("white"),
                            node.color.bg = c("black"),
                            tip.label.size = 1,
                            pie.chart.size = 1) {

  if (is.null(astral.plane) == TRUE){ stop("No data provided! Run astralPlane function first.") }
  if (length(pie.plot) == 2){ stop("Please pick 'qscore' or 'genetree' for pie plots") }

  #Gathers pie data
  if (pie.plot == "qscore"){
    pie.data = data.frame(node = astral.plane@nodeData$node,
                          q1 = astral.plane@nodeData$q1,
                          q2 = astral.plane@nodeData$q2,
                          q3 = astral.plane@nodeData$q3)
  }#end qscore if

  if (pie.plot == "genetree"){
    pie.data = data.frame(node = astral.plane@nodeData$node,
                          f1 = astral.plane@nodeData$f1,
                          f2 = astral.plane@nodeData$f2,
                          f3 = astral.plane@nodeData$f3)
  }#end genetree if

  #Matches edge data with nodes
  edge.no = which(astral.plane@edgeData$node2 > length(astral.plane@samples))
  edge.node = astral.plane@phylo$edge
  edge.node = data.frame(edge = rep(1:nrow(edge.node)), node1 = edge.node[,1], node2 = edge.node[,2])

  edge.red = astral.plane@edgeData[edge.no,]
  merge.data = merge(astral.plane@nodeData, astral.plane@edgeData, by.x = "node", by.y = "node2")

  #Saves file
  if(is.null(save.file) != T){ pdf(file = save.file, width = 10, height = 8) }

  ape::plot(astral.plane@phylo, cex = tip.label.size)
  ape::edgelabels(edge = merge.data$edge,
             pie = as.matrix(merge.data[,2:4]),
             piecol = pie.colors, cex = pie.chart.size)

  if(local.posterior == TRUE){
    ape::nodelabels(text = round(merge.data$pp1, 2),
               node = merge.data$node,
               col = "white",
               bg = "black",
               adj = c(-0.3, 0.3),
               cex = tip.label.size)
  }#end posterior

  #Branch length legend
  if(is.null(save.file) != T){  dev.off() }

} #end Astral project function

