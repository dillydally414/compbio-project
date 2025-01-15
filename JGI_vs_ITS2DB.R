set.seed(1)
setwd('/projectnb/bi720/MMG/compbio/Aim_1')
library(seqinr)
library(stringr)

#Data
JGI <- read.csv('/projectnb/bi720/MMG/compbio/portalid_taxname.csv')
DB <- read.fasta('/projectnb/bi720/MMG/compbio/fungi_its_seq.fasta', 
                 seqtype = 'DNA', as.string = T)

for(i in 1:length(DB)){
  DB[[i]][1] <- toupper(DB[[i]][1]) #converts lowercase to upper, needed when outputting
}



###Find overlap based on portal ID
DB_annot <- getAnnot(DB) #gets annotaation in '>AZ1234 Genus Species' format
DB_annot <- str_remove(DB_annot, '.*[:digit:] ')  #cuts down to just 'Genus species'

DB_ov <- DB[which(DB_annot %in% JGI$species)]   # filter both data sets to only
JGI_ov <- JGI[which(JGI$species %in% DB_annot),]# species prensent in both

#output file with full name (matches input fasta)
write.fasta(sequences = getSequence(DB_ov), names = str_remove(getAnnot(DB_ov), '>') ,
            file.out = '/projectnb/bi720/MMG/compbio/ITS2DB_species_in_JGI.fasta', nbchar = 3000)

###Reformat name
#repeat annotation cleaning for just overlap species
DB_annot_ov <- getAnnot(DB_ov)
DB_annot_ov <- str_remove(DB_annot_ov, '.*[:digit:] ')
#how many duplicated names in DB?
# length(unique(DB_annot_ov))

write.fasta(sequences = getSequence(DB_ov), names = DB_annot ,
            file.out = '/projectnb/bi720/MMG/compbio/ITS2DB_species_in_JGI_CleanNames.fasta', nbchar = 3000)


###No Duplicate species, take only the longest (or the first )
new_DB <- list()
#for each unique species
uniq_spec <- unique(DB_annot_ov)
for (i in 1:length(uniq_spec)) {
  #get the sub list of ITS2s from that species
  species <- uniq_spec[i]
  DB_sub <- DB_ov[DB_annot_ov == species]
  #get sequences from that list
  tmp <- unlist(getSequence(DB_sub, as.string = T))
  #take only the longest ITS, use it as unique entry for this species
  lg <- which.max(nchar(tmp)) #1 if the seq length is 1
  new_DB <- append(new_DB, DB_sub[lg])
}
rm(tmp, DB_sub, species, i, lg)

write.fasta(sequences = getSequence(new_DB), names = str_remove(getAnnot(new_DB), '>') ,
            file.out = '/projectnb/bi720/MMG/compbio/ITS2DB_species_in_JGI_NoDups_Longest.fasta',
            nbchar = 3000)
write.fasta(sequences = getSequence(new_DB), names = str_remove(getAnnot(new_DB), '>[A-z][A-z][:digit:]* ') ,
            file.out = '/projectnb/bi720/MMG/compbio/ITS2DB_species_in_JGI_NoDups_Longest_CleanNames.fasta',
            nbchar = 3000)
 
###Remove species duplicates from JGI overlaps
# JGI_ov <- JGI_ov[which(!is.na(JGI_ov$species)),]
# JGI_ov <- JGI_ov[!duplicated(JGI_ov$species), ]
