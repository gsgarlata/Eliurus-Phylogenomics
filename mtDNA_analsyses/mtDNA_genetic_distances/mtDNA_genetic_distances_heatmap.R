require(adegenet)
require(ape)
require(reshape2)
require(plyr)
require(ggplot2)
require(data.table)


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

sp_names<-do.call(rbind,strsplit(as.character(mean_mtDNAdist$combo),"-"))

mean_mtDNAdist$species1<-sp_names[,1]
mean_mtDNAdist$species2<-sp_names[,2]

###heatmap  
midpoint_col<-7.5#median(heat$mean_diff)

uni_sp1<-unique(mean_mtDNAdist$species1)[!unique(mean_mtDNAdist$species1) %in% 'sp_nova']
uni_sp2<-unique(mean_mtDNAdist$species2)[!unique(mean_mtDNAdist$species2) %in% 'sp_nova']

for(u in 1:length(uni_sp1)){
  coord_sp1<-which(mean_mtDNAdist$species1==uni_sp1[u])
  mean_mtDNAdist[coord_sp1,'species1']<-paste0('E. ',uni_sp1[u])
}

for(u in 1:length(uni_sp2)){
  coord_sp2<-which(mean_mtDNAdist$species2==uni_sp2[u])
  mean_mtDNAdist[coord_sp2,'species2']<-paste0('E. ',uni_sp2[u])
}

mean_mtDNAdist$species1<-gsub('sp_nova','Eliurus sp. nova',mean_mtDNAdist$species1)
mean_mtDNAdist$species2<-gsub('sp_nova','Eliurus sp. nova',mean_mtDNAdist$species2)

###Some name editing to deal with Eliurus sp. nova###
##SP NOVA-TANALA
coord_sp_nova_tanala<-which(mean_mtDNAdist$combo=='sp_nova-tanala')
sp1_1st<-mean_mtDNAdist[coord_sp_nova_tanala,'species1']
mean_mtDNAdist[coord_sp_nova_tanala,'species1']<-mean_mtDNAdist[coord_sp_nova_tanala,'species2']
mean_mtDNAdist[coord_sp_nova_tanala,'species2']<-sp1_1st

##SP NOVA-TSINGIMBATO
coord_sp_nova_tsingimbato<-which(mean_mtDNAdist$combo=='sp_nova-tsingimbato')
sp1_2nd<-mean_mtDNAdist[coord_sp_nova_tsingimbato,'species1']
mean_mtDNAdist[coord_sp_nova_tsingimbato,'species1']<-mean_mtDNAdist[coord_sp_nova_tsingimbato,'species2']
mean_mtDNAdist[coord_sp_nova_tsingimbato,'species2']<-sp1_2nd

##SP NOVA-WEBBI
coord_sp_nova_webbi<-which(mean_mtDNAdist$combo=='sp_nova-webbi')
sp1_3rd<-mean_mtDNAdist[coord_sp_nova_webbi,'species1']
mean_mtDNAdist[coord_sp_nova_webbi,'species1']<-mean_mtDNAdist[coord_sp_nova_webbi,'species2']
mean_mtDNAdist[coord_sp_nova_webbi,'species2']<-sp1_3rd
###Some name editing to deal with Eliurus sp. nova###

plot.heat<-ggplot(data = mean_mtDNAdist, aes(x=species1, y=species2, fill=mean_diff*100)) + 
  geom_tile(color = "white")+
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = midpoint_col, space = "Lab", 
                       name="% of nucleotide\ndifferences")+labs(x='',y='')+
  theme_minimal()+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 20, hjust = 1,face = "italic"),
        axis.text.y = element_text(size = 20, hjust = 1,face = "italic"),
        text = element_text(size=20))+coord_fixed()




