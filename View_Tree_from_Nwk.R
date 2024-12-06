###tmping viewing trees made in SCC for aim 1
###Luke Berger

###Set up
set.seed(1)
setwd('/projectnb/bi720/MMG/compbio/Aim_1')

##libs
library(ape)
library(stringr)
library(phytools)

###Newick files
#basic <- ape::read.tree(file = 'tmp_tree.nwk')
#names <- ape::read.tree(file = '20_species_aligned.nwk')
hmmer <- ape::read.tree(file = 'hmmer_tree.nwk')

#jgi        <- ape::read.tree(file = 'fungi-2024-published.newik')
#jgi_lables <- ape::read.tree(file = 'fungi-2024-published-with-labels-and-support-values.newik')

###Plots
#plot(names)
plot(hmmer)
#plot(jgi_lables)

###Relable hmmer
lables <- read.FASTA('/projectnb/bi720/MMG/compbio/sample_20_its_seq.fasta')
lables <- objects(lables)
lables

tips = hmmer$tip.label
tips
sort(tips)

copy = hmmer

for (i in 1:length(tips)) {
  tmp = lables[which(
    str_detect(lables, tips[i])
  )]
  tmp = str_remove(tmp, tips[i])
  #print(tmp)
  copy$tip.label[i] = tmp
}
#plot(copy)


#emilies change
copy$tip.label
copy$tip.label[16] <- "Bipolaris heveae"
copy$tip.label[17] <- "Curvularia pallescens"
copy$tip.label

###Output relabled newik
ape::write.tree(copy, 'hmmer_tree_v3_relabled.nwk')

###Fancy plot
plot.phylo(copy)
