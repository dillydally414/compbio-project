set.seed(1)
setwd('/projectnb/bi720/MMG/compbio/Aim_1')

library(phangorn)
library(pvclust)
library(ape)
library(stringr)
library(phytools)
library(seqinr)
library(stringr)


###load matrix 
mat <- read.csv('/projectnb/bi720/MMG/compbio/Aim_1/reformat_test.csv')
nms <- mat[,1]
mat <- mat[,-1]
mat <- as.matrix(mat)
rownames(mat) <- nms

###Run UPGMA
tree <-  upgma(as.dist(mat))
ape::write.tree(tree, '/projectnb/bi720/MMG/compbio/Aim_1/ITSDB_noDups_Longest_UPGMA.nwk')

