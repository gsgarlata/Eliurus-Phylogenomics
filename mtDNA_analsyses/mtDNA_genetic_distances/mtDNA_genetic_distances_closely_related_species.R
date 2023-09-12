require(adegenet)
require(ape)
require(reshape2)
require(plyr)
require(ggplot2)
require(data.table)
require(otuSummary)

input_file = "Eliurus_cytb_aligned_haps.fas"
info_file<-"mtDNAspecies_info_cytb_haplotypes.csv"

#load cytb mtDNA haploype data
dna<-fasta2DNAbin(file=input_file)
#load info data on species ID
info.df<-read.csv(info_file)

#split cytb sequence ID with respect to tab space
splitted_names = strsplit(rownames(dna),' ')
#extract only the first word of the cytb sequence ID
cytbIDs = do.call(rbind,lapply(splitted_names,function(x) x[1]))
#assign new IDs to cytb sequences
rownames(dna)<-cytbIDs[,1]
#identify outgroup sequence and remove it from the dataset
rm.indx<-which(labels(dna)=="EU349782.1")
dna<-dna[-rm.indx,]
#calculate raw genetic distances
res.dist<-dist.dna(dna,model="raw",pairwise.deletion=TRUE)
#convert matrix to 3-columns dataframe
final = otuSummary::matrixConvert(res.dist, colname = c("id1", "id2", "value"))
#assign species ID to cytb sequence IDs
final$species1<-NA
final$species2<-NA

for(i in 1:nrow(info.df)){
  
  coord1<-which(as.character(final$id1)==as.character(info.df$ID[i]))
  coord2<-which(as.character(final$id2)==as.character(info.df$ID[i]))
  
  final$species1[coord1]<-as.character(info.df$species[i])
  final$species2[coord2]<-as.character(info.df$species[i])
  
}

#order column of species names by alphabetic order, for each pair
for(h in 1:nrow(final)){
  
  species_pair<-final[h,c('species1','species2')]
  individual_pair<-final[h,c('id1','id2')]
  
  order_sp<-order(as.character(species_pair))
  
  final[h,'species1']<-as.character(species_pair)[order_sp[1]]
  final[h,'species2']<-as.character(species_pair)[order_sp[2]]
  final[h,'id1']<-as.matrix(individual_pair)[order_sp[1]]
  final[h,'id2']<-as.matrix(individual_pair)[order_sp[2]]
}
#combine species names of each pairwise comparison
final$combo<-paste0(final$species1,'-',final$species2)
#compute average and standard deviation of genetic distances for each species pair
mean_mtDNAdist<-ddply(final,.(combo), summarise,mean_diff=mean(value), sd_diff=sd(value))

###START: Closely-related species (sister species + 2nd closest species) analysis#####
species_pairs<-c('antsingy-carletoni','antsingy-majori','myoxinus-sp_nova','minor-myoxinus',
                 'ellermani-tanala','tanala-tsingimbato','ellermani-tsingimbato')
#extract closely-related species comparisons only
sister_spDF<-mean_mtDNAdist[mean_mtDNAdist$combo %in% species_pairs,]
#order data by average genetic distance
df_plot<-sister_spDF[with(sister_spDF, order(mean_diff)), ]

sp_names<-do.call(rbind,strsplit(as.character(df_plot$combo),"-"))

for(i in 1:nrow(sp_names)){
  
  sp_names[i,1]<-paste0('E. ',sp_names[i,1])
  sp_names[i,2]<-paste0('E. ',sp_names[i,2])
}

df_plot$combo<-paste0(sp_names[,1],'\nvs      \n',sp_names[,2])
df_plot$combo<-gsub('E. sp_nova','Eliurus sp. nova',as.character(df_plot$combo))


type_pair = c('sister','sister_2nd','sister_2nd','sister','sister','sister_2nd','sister_2nd')
df_plot$type = type_pair
df_plot = df_plot[order(df_plot$type),]
df_plot$combo<-factor(df_plot$combo, levels=df_plot$combo)

bar.plot<-ggplot(df_plot,aes(x=combo,y=mean_diff*100,
                             fill=factor(ifelse(combo=="E. myoxinus\nvs      \nEliurus sp. nova","Highlighted","Normal"))))+
  geom_bar(stat="identity",show.legend = FALSE)+scale_fill_manual(name = "", values=c("red","grey50"), labels=NULL)+
  geom_errorbar(aes(ymin=(mean_diff-sd_diff)*100, ymax=(mean_diff+sd_diff)*100))+theme_bw()+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust = 1,face = "italic"),
        axis.title.x=element_blank(),
        text=element_text(size=25))+ylab('% of nucleotide differences')

###END: Closely-related species (sister species + 2nd closest species) analysis#####
