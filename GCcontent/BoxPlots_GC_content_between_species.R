
require(ape)
require(seqinr)
require(phangorn)
require(insect)
require(multcompView)

###functions###
generate_label_df <- function(TUKEY, variable){
  
  # Extract labels and factor levels from Tukey post-hoc 
  Tukey.levels <- variable[,4]
  Tukey.labels <- data.frame(multcompLetters(Tukey.levels)['Letters'])
  
  #I need to put the labels in the same order as in the boxplot :
  Tukey.labels$treatment=rownames(Tukey.labels)
  Tukey.labels=Tukey.labels[order(Tukey.labels$treatment) , ]
  return(Tukey.labels)
}
###functions###

####
input = 'Eliurus_sp_npop125_pop5_p4_r0.80_all_sp_nova_proj_min100_all.Rdata'
info_file = 'Eliurus_sp_all_sp_nova_proj_RAD_dist.csv'

load(input)
info_ids<-read.csv(info_file)

final<-NULL

for(i in 1:nrow(DNAbin)){

subset_inds<-rep(FALSE,nrow(DNAbin))
subset_inds[i]<-TRUE

indDNAbin<-subset.DNAbin(DNAbin,subset_inds)

ind_res<-c(i,GC.content(indDNAbin))

final<-rbind(final,ind_res)

rm(ind_res,indDNAbin,subset_inds)

}

rownames(final)<-NULL

dataset_final<-data.frame(id_code=final[,1],GC=final[,2])
dataset_final$species<-info_ids[match(dataset_final$id_code,info_ids$id_code),'species']

name_list<-c('E. minor','E. myoxinus','E. carletoni','E. ellermani','Eliurus sp. nova')
colour_sp<-c("chartreuse3","#8700fe","#1787ff","red3","orange")


p<-ggplot(dataset_final,aes(x=factor(species),y=GC,colour=factor(species)))+
  geom_boxplot(outlier.size = 0,alpha=.3, show.legend = F) +
  geom_point(position = position_jitterdodge(),alpha=.3,show.legend = F)+
  scale_colour_manual(name='',breaks=name_list,values=colour_sp)+
                        xlab('')+ylab('GC%')+ylim(min(dataset_final$GC),max(dataset_final$GC)+0.001)+
  theme_bw()+theme(axis.title.x=element_blank(),
                             axis.text.x=element_text(face = "italic"),
                             axis.ticks.x=element_blank())
  

model=lm(GC ~ species, data=dataset_final)
ANOVA=aov(model)
TUKEY <- TukeyHSD(ANOVA)
labels <- generate_label_df(TUKEY, TUKEY$species)

names(labels) <- c('Letters','species')
yvalue <- aggregate(dataset_final$GC, list(dataset_final$species), data=dataset_final, quantile, probs=.75)  
final <- data.frame(labels, yvalue[,2])

names(final)<-c("letters","species","GC")

plotGCBOX <- p + geom_text(data = final,  aes(x=species, y=GC, colour=species,label=letters),
                   vjust=-5, hjust=-1,size=5,fontface = "bold",show.legend = F)+
  theme(text=element_text(size=20))

