#Comp Bio Final Project
#Helen Pennington
#aim 3

#DistatisR
library(DistatisR)
library(data.table)

#sequence distance matrix
seq <- fread("/projectnb/bi720/MMG/compbio/sample_20_seq_dist.csv")
rownames <- seq$V1
seq <- seq[,-1]
seq <- as.matrix(seq)
rownames(seq) <- rownames
head(seq)

#structure distance matrix
structure <- fread("/projectnb/bi720/MMG/compbio/sample_20_str_dist.csv")
rownames <- structure$V1
structure <- structure[,-1]
structure <- as.matrix(structure)
rownames(structure) <- rownames
head(structure)

#Combine into 3D matrix
comb <- array(c(seq, structure), c(21, 21, 2), dimnames =list(rownames,rownames))

test<-distatis(comb, Norm ="MFA", Distance = TRUE, RV = TRUE, nfact2keep = 2, compact = FALSE)
comb_weighted <- test$res4Splus$Splus

#UPGMA
library(phangorn)
library(pvclust)
library(ape)

tree_comb <- pvclust(comb_weighted, method.dist="cor", method.hclust="average", nboot=1000, parallel=TRUE)
tree_comb<-as.phylo(tree_comb$hclust)
ape::write.tree(tree_comb, file=paste0('/projectnb/bi720/MMG/compbio/Aim3_trees/sample_20_seq_str_tree.txt'))
png(filename = "/projectnb/bi720/MMG/compbio/Aim3_trees/sample_20_seq_str_tree.png")
plot(tree_comb)
dev.off()
tree_seq <- upgma(as.dist(seq))
ape::write.tree(tree_seq, file=paste0('/projectnb/bi720/MMG/compbio/Aim3_trees/sample_20_seq_tree.txt'))
png(filename = "/projectnb/bi720/MMG/compbio/Aim3_trees/sample_20_seq_tree.png")
plot(tree_seq)
dev.off()
tree_str <- upgma(as.dist(structure))
ape::write.tree(tree_str, file=paste0('/projectnb/bi720/MMG/compbio/Aim3_trees/sample_20_str_tree.txt'))
png(filename = "/projectnb/bi720/MMG/compbio/Aim3_trees/sample_20_str_tree.png")
plot(tree_str)
dev.off()

#weighted trees function
weightedTree <- function(seq,structure,weightseq,weightstr){
  comb <- weightseq*seq + weightstr*structure
  tree_comb <- upgma(as.dist(comb))
  ape::write.tree(tree_comb, file=paste0('/projectnb/bi720/MMG/compbio/Aim3_trees/sample_20_comb',weightseq,weightstr,'seqstr_tree.txt'))
  png(filename = paste0('/projectnb/bi720/MMG/compbio/Aim3_trees/sample_20_comb',weightseq,weightstr,'seqstr_tree.png'))
  plot(tree_comb)
  dev.off()
}


x <- 0.1
y <- 0.9
for(i in 1:10){
  weightedTree(seq,structure,x,y)
  x <- x+0.1
  y <- y-0.1
}