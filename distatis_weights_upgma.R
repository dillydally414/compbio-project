#Comp Bio Final Project
#Helen Pennington
#aim 3

#Packages
library(DistatisR)
library(data.table)
library(phangorn)
library(pvclust)
library(ape)

#qsub inputs
args = commandArgs(trailingOnly=TRUE)
print(args)
seq <- ''
structure <- ''
sample <- ''

# test if there is at least 3 arguments: if not, return an error
if (length(args) < 3) {
  stop('At least three arguments must be supplied.', call.=FALSE)
} else if (length(args)==3) {
  seq = args[1] 
  structure = args[2] 
  sample = args[3]
}

print(seq)
print(structure)
print(sample)

#sequence distance matrix
seq <- fread(seq)
rownames <- seq$V1
seq <- seq[,-1]
seq <- as.matrix(seq)
rownames(seq) <- rownames
head(seq)

#structure distance matrix
structure <- fread(structure)
rownames <- structure$V1
structure <- structure[,-1]
structure <- as.matrix(structure)
rownames(structure) <- rownames
head(structure)

#Combine into 3D matrix
combined_matrix <- array(c(seq, structure), c(21, 21, 2), dimnames =list(rownames,rownames))
#run distatis
distatis_output <-distatis(combined_matrix, Norm ="MFA", Distance = TRUE, RV = TRUE, nfact2keep = 2, compact = FALSE)
#distatis outputs needed
#pull out combined "compromise" matrix
combined_distatis_matrix <- distatis_output$res4Splus$Splus
#check which weights were used
combined_distatis_weights <- distatis_output$res4Splus$alphaWeights
combined_distatis_weights

#UPGMA
phylogeneticTree <- function(tree,name,newick){
  #write tree as Newick file for scoring
  ape::write.tree(tree, file=paste0('/projectnb/bi720/MMG/compbio/comparisons/',name,'.txt'))
  #save visual of tree
  png(filename = paste0('/projectnb/bi720/MMG/compbio/Aim3_trees/',name,'.png'))
  plot(newick)
  dev.off()
}

#pvclust is needed to produce upgma plot for distatis output matrix
tree_comb <- pvclust(combined_distatis_matrix, method.dist="cor", method.hclust="average", nboot=1000, parallel=TRUE)
tree_comb_py<-as.phylo(tree_comb$hclust)
phylogeneticTree(tree_comb_py,paste0(sample,'_seq_str_tree'),tree_comb)

tree_seq <- upgma(as.dist(seq))
phylogeneticTree(tree_seq,paste0(sample,'_seq_tree'),tree_seq)

tree_str <- upgma(as.dist(structure))
phylogeneticTree(tree_str,paste0(sample,'_seq_tree'),tree_str)

#write tree as Newick file for scoring
#ape::write.tree(tree_comb_py, file=paste0('/projectnb/bi720/MMG/compbio/Aim3_trees/sample_20_seq_str_tree.txt'))
#save visual of tree
#png(filename = "/projectnb/bi720/MMG/compbio/Aim3_trees/sample_20_seq_str_tree.png")
#plot(tree_comb)
#dev.off()
#tree_seq <- upgma(as.dist(seq))
#ape::write.tree(tree_seq, file=paste0('/projectnb/bi720/MMG/compbio/Aim3_trees/sample_20_seq_tree.txt'))
#png(filename = "/projectnb/bi720/MMG/compbio/Aim3_trees/sample_20_seq_tree.png")
#plot(tree_seq)
#dev.off()
#tree_str <- upgma(as.dist(structure))
#ape::write.tree(tree_str, file=paste0('/projectnb/bi720/MMG/compbio/Aim3_trees/sample_20_str_tree.txt'))
#png(filename = "/projectnb/bi720/MMG/compbio/Aim3_trees/sample_20_str_tree.png")
#plot(tree_str)
#dev.off()

#Weighted trees function
weightedTree <- function(seq,structure,weightseq,weightstr){
  comb <- weightseq*seq + weightstr*structure
  tree_comb <- upgma(as.dist(comb))
  ape::write.tree(tree_comb, file=paste0('/projectnb/bi720/MMG/compbio/comparisons/',sample,'comb',weightseq,weightstr,'seqstr_tree.txt'))
  png(filename = paste0('/projectnb/bi720/MMG/compbio/Aim3_trees/',sample,'comb',weightseq,weightstr,'seqstr_tree.png'))
  plot(tree_comb)
  dev.off()
}

#Loop
x <- 0.1
y <- 1-x
for(i in 1:9){
  weightedTree(seq,structure,x,y)
  x <- x+0.1
  y <- y-0.1
}