#Fungi Phylogenetic Tree
#Helen Pennington
#Scores

#Packages
library(ggplot2)
library(data.table)

#qsub inputs
args = commandArgs(trailingOnly=TRUE)
print(args)
scores <- ''
sample <- ''

# test if there is at least 3 arguments: if not, return an error
if (length(args) < 2) {
  stop('At least two arguments must be supplied.', call.=FALSE)
} else if (length(args)==2) {
  scores = args[1] 
  sample = args[2]
}
print(scores)
print(sample)

#Comparisons
scores <- data.frame(fread(scores))
head(scores)
distatis_score <- scores[which(scores$tree == "distatis"),2]
scores$distatis<-rep(as.numeric(distatis_score),times=nrow(scores))
scores <- scores[-12,]

# Plot
scores$tree <- factor(scores$tree, levels = scores$tree)
ggplot(scores, aes(x=tree, y=score,group = 1)) +
  geom_point() + geom_line() + geom_line(aes(y=distatis),linetype="dotted") + 
  labs(x = "Phylogeny", y = "Score", 
       title = "Phylogeny Score for Varying Primary Sequence + Secondary Structure Weights", shape = c("weights","distatis"))
ggsave(
  paste0('./',sample,'structure_sequence_treescore_lineplot.png'),
  plot = last_plot())