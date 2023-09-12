require(adegenet)
require(ape)
require(reshape2)
require(plyr)
require(ggplot2)
require(data.table)
#require(geosphere)


path_data<-"/Users/gabrielemariasgarlata/Documents/Projects/PhD_project/RAD_seq/Eliurus/Eliurus_spp/analysis/mtDNA_sequenced/input"
path_info<-'/Users/gabrielemariasgarlata/Documents/Projects/PhD_project/RAD_seq/Eliurus/Eliurus_spp/data_info/mtDNA'
out_path<-"/Users/gabrielemariasgarlata/Documents/Projects/PhD_project/RAD_seq/Eliurus/Eliurus_spp/analysis/mtDNA_sequenced/distance_analysis"

dataset<-"Eliurus_cytb_aligned_haps.fas"
info_file<-'mtDNAspecies_info_cytb_haplotypes'
out_name<-'Eliurus_spp_mtDNA_species_pairs'

input_file<-paste0(path_data,"/",dataset)
dna<-fasta2DNAbin(file=input_file)

info.df<-read.csv(paste0(path_info,"/",info_file,".csv"))


test<-do.call(rbind,strsplit(rownames(dna),' '))

rownames(dna)<-test[,1]

rm.indx<-which(labels(dna)=="EU349782.1")

dna<-dna[-rm.indx,]

res.dist<-dist.dna(dna,model="raw",pairwise.deletion=TRUE)

dist.pairs.mat<-subset(reshape::melt(as.matrix(res.dist)), value!=0)

check_dupl<-which(duplicated(t(apply(dist.pairs.mat[,c('X1','X2')], 1, sort)))==TRUE)

if(length(check_dupl)>0){
  int.final<-dist.pairs.mat[,c('X1','X2')][!duplicated(t(apply(dist.pairs.mat[,c('X1','X2')], 1, sort))),]
  
  setDT(int.final)
  setkey(setDT(dist.pairs.mat), X1, X2)
  final<-dist.pairs.mat[int.final]
  
}else{
  final<-dist.pairs.mat 
}

final$species1<-NA
final$species2<-NA

for(i in 1:nrow(info.df)){
  
  coord1<-which(as.character(final$X1)==as.character(info.df$ID[i]))
  coord2<-which(as.character(final$X2)==as.character(info.df$ID[i]))
  
  final$species1[coord1]<-as.character(info.df$species[i])
  final$species2[coord2]<-as.character(info.df$species[i])
    
}

#check_dupl<-which(duplicated(t(apply(dist.pairs.mat[,c('species1','species2')], 1, sort)))==TRUE)


for(h in 1:nrow(final)){
  
  species_pair<-final[h,c('species1','species2')]
  individual_pair<-final[h,c('X1','X2')]

  order_sp<-order(species_pair)

  final[h,'species1']<-as.character(species_pair)[order_sp[1]]
  final[h,'species2']<-as.character(species_pair)[order_sp[2]]
  final[h,'X1']<-as.matrix(individual_pair)[order_sp[1]]
  final[h,'X2']<-as.matrix(individual_pair)[order_sp[2]]
}
  


final$combo<-paste0(final$species1,'-',final$species2)

heat<-ddply(final,.(combo), summarise,mean_diff=mean(value), sd_diff=sd(value))

sp_names<-do.call(rbind,strsplit(heat$combo,"-"))

heat$species1<-sp_names[,1]
heat$species2<-sp_names[,2]

###heatmap  
midpoint_col<-7.5#median(heat$mean_diff)

uni_sp1<-unique(heat$species1)[!unique(heat$species1) %in% 'sp_nova']
uni_sp2<-unique(heat$species2)[!unique(heat$species2) %in% 'sp_nova']

for(u in 1:length(uni_sp1)){
  
  coord_sp1<-which(heat$species1==uni_sp1[u])
  
  heat[coord_sp1,'species1']<-paste0('E. ',uni_sp1[u])
  
}
for(u in 1:length(uni_sp2)){
  
  coord_sp2<-which(heat$species2==uni_sp2[u])
  
  heat[coord_sp2,'species2']<-paste0('E. ',uni_sp2[u])
  
}

heat$species1<-gsub('sp_nova','Eliurus sp. nova',heat$species1)
heat$species2<-gsub('sp_nova','Eliurus sp. nova',heat$species2)

##SP NOVA-TANALA
coord_sp_nova_tanala<-which(heat$combo=='sp_nova-tanala')
sp1_1st<-heat[coord_sp_nova_tanala,'species1']
heat[coord_sp_nova_tanala,'species1']<-heat[coord_sp_nova_tanala,'species2']
heat[coord_sp_nova_tanala,'species2']<-sp1_1st

##SP NOVA-TSINGIMBATO
coord_sp_nova_tsingimbato<-which(heat$combo=='sp_nova-tsingimbato')
sp1_2nd<-heat[coord_sp_nova_tsingimbato,'species1']
heat[coord_sp_nova_tsingimbato,'species1']<-heat[coord_sp_nova_tsingimbato,'species2']
heat[coord_sp_nova_tsingimbato,'species2']<-sp1_2nd

##SP NOVA-WEBBI
coord_sp_nova_webbi<-which(heat$combo=='sp_nova-webbi')
sp1_3rd<-heat[coord_sp_nova_webbi,'species1']
heat[coord_sp_nova_webbi,'species1']<-heat[coord_sp_nova_webbi,'species2']
heat[coord_sp_nova_webbi,'species2']<-sp1_3rd



plot.heat<-ggplot(data = heat, aes(x=species1, y=species2, fill=mean_diff*100)) + 
  geom_tile(color = "white")+
  scale_fill_gradient2(low = "blue", high = "red", mid = "white", 
                       midpoint = midpoint_col, space = "Lab", 
                       name="% of nucleotide\ndifferences")+labs(x='',y='')+
  theme_minimal()+ # minimal theme
  theme(axis.text.x = element_text(angle = 45, vjust = 1, 
                                   size = 20, hjust = 1,face = "italic"),
        axis.text.y = element_text(size = 20, hjust = 1,face = "italic"),
        text = element_text(size=20))+coord_fixed()

ggsave(filename = paste0(out_path,"/",out_name,'_heatmap.png'),
       plot=plot.heat,width=10,height=10)
####END Heatmap#######

heat<-heat[-which(heat$species1==heat$species2),]


df_plot<-heat[with(heat, order(mean_diff)), ]
coord_sp<-which(df_plot$combo=='myoxinus-sp_nova')

plot.dist<-ggplot(data=df_plot, aes(x=1:nrow(df_plot), y=mean_diff*100))+geom_bar(stat="identity",col="#0072B2")+
  geom_errorbar(aes(ymin=(mean_diff-sd_diff)*100, ymax=(mean_diff+sd_diff)*100))+
  geom_vline(xintercept=coord_sp,col="red",lwd=1)+theme_bw()+
  labs(x="Pairwise Species comparison", y="% of nucleotide differences")+
  theme(text = element_text(size=30),axis.text.x=element_blank(),
        axis.ticks.x=element_blank())


ggsave(filename = paste0(out_path,"/",out_name,'_barplot.png'),
       plot=plot.dist,width=8,height=8)







