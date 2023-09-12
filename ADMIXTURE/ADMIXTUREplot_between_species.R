require(reshape2)
require(dplyr)
require(ggforce)
require(ggplot2)
require(ggforce)


rm(list=ls())

##functions##
barNaming <- function(vec) {
  retVec <- vec
  for (k in 2:length(vec)) {
    if (vec[k - 1] == vec[k])
      retVec[k] <- ""
  }
  return(retVec)
}
##functions##

#COLOR CODES. E. myoxinus: #8700fe; Eliurus sp.nova: orange; 
#E. ellermani: red; E. carletoni: #1787ff; E. minor: green.

ID_file = 'sampleIDs.tsv'
info_file = 'Eliurus_sp_all_sp_nova_proj.csv'
order_file = 'Eliurus_spp_pop_order.txt'
selected_KVAL = 6
path_data = './output'
##

#convert numeric to character
K_value<-as.character(selected_KVAL)
#load input data from ADMIXTURE outout
input_df<-read.table(paste0(path_data,"/K=",K_value,"/MajorCluster/CLUMPP.files/ClumppIndFile.output"))
#load samples IDs
sample.ids<-as.character(read.table(paste0(path_data,"/",ID_file))[,1])
#extract only ancestry values
input_df<-input_df[,-c(1,2,3,4,5)]
#load species and population info for each individual 
pop.ids<-read.table(info_file,sep=",",header=TRUE)
#load population order
pop.order<-read.table(order_file)

#get population and species IDs
new.pop.ids<-pop.ids[match(sample.ids,pop.ids$id_seq),"site"]
species.id<-pop.ids[match(sample.ids,pop.ids$id_seq),"species"]

#create a temporary dataframe with info on ancestry, species and population IDs
temp<-data.frame(ID=sample.ids,POP=new.pop.ids,species=species.id,cluster=input_df)
temp$ID<-as.character(temp$ID)
temp$POP<-as.character(temp$POP)
temp$species<-as.character(temp$species)
names(temp)<-c("ID","POP","species",paste0("cluster",1:K_value))

pop.order<-as.character(pop.order$V1)
species_list<-unique(temp$species)
final<-NULL

#one way of reordering the data following the POP ORDER file information (based on geography)
for(u in 1:length(species_list)){
  
  int.df<-subset(temp,species==species_list[u])
  
  for(j in 1:length(pop.order)){
    
    coords<-which(int.df$POP==pop.order[j])
    
    final<-rbind(final,int.df[coords,])
  }
}

final$ID<-as.character(final$ID)  

for(d in 1:nrow(final)){
  options(warn=2)
  cood<-which(as.character(pop.ids$id_seq)==as.character(final$ID[d]))
  final$ID[d]<-as.character(pop.ids$id[cood])
}

final$ID<-factor(final$ID, levels=final$ID)
final$POP<-factor(final$POP, levels=pop.order)

df.pie<-reshape2::melt(final, id.vars=c("ID","POP","species"))


old_names<-as.character(final$ID)
new_names<-barNaming(as.character(final$species))

#set legend names
breaks_names<-paste0("cluster",1:as.numeric(K_value))
labels_names<-paste0("Cluster ",1:as.numeric(K_value))

#define list of coulours based on the K value
if(selected_KVAL==6){
  colour_values<-c('chartreuse3','#96d2ff','#8700fe','red3','#1787ff','orange')
}else{
  colour_values<-c('chartreuse3','#96d2ff','#8700fe','red3','#1787ff','orange')
}
if(selected_KVAL==4){
  colour_values<-c('chartreuse3','#1787ff','#8700fe','red3','orange')
}

#create ADIXTURE BAR plot
ADMIXTUREplot<-ggplot(data=df.pie, aes(x=ID, y=value, fill=variable))+
  geom_bar(stat="identity")+
  scale_fill_manual(name="",breaks = breaks_names,values = colour_values,
                    labels=labels_names)+scale_x_discrete(breaks=old_names,labels=new_names)+
  theme(panel.background = element_blank(),
        axis.ticks = element_blank(),
        panel.grid = element_blank(),
        axis.title = element_blank(),
        axis.text.x=element_text(angle=0,vjust=1,face = "italic"))+
  theme(text=element_text(size=30))

