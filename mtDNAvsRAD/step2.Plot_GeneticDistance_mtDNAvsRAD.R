require(reshape2)
require(ggplot2)
require(ggrepel)
require(plyr)


#######INPUT INFO#######
pairs_file<-'Eliurus_species_pairs_labels.tsv'
info_file<-'Eliurus_sp_all_sp_nova_proj_RAD_dist.csv'
parameters<-'npop125_pop5_p4_r0.80_all_sp_nova_proj_min100'
path_data = './output'
mtDNA_data<-'Eliurus_mtDNA_gen_dist_across_species.csv'
#######INPUT INFO#######


#load info data
pairs_info<-read.table(pairs_file)
info_file<-read.csv(info_file)

#START: load RAD-seq genetic distance data for all Eliurus species pairs#
final<-NULL

for(i in 1:nrow(pairs_info)){
  
  species_1<-as.character(pairs_info[i,1])
  species_2<-as.character(pairs_info[i,2])
  
  load(paste0(path_data,'/',species_1,'_',species_2,'_',parameters,'.Rdata'))
  dist_mat<-as.matrix(res.dist)
  dist_mat[upper.tri(dist_mat,diag = T)] <- NA
  dist_df<-reshape2::melt(dist_mat)
  dist_df<-dist_df[!is.na(dist_df$value),]
  
  dist_df$species1<-info_file$species[match(dist_df$Var1,info_file$id_code)]
  dist_df$species2<-info_file$species[match(dist_df$Var2,info_file$id_code)]
  final<-rbind(final,dist_df) 
}

res_df<-aggregate(value ~ species1 + species2, data = final, mean)
temp_mat<-as.matrix(aggregate(value ~ species1 + species2, data = final, sd)["value"])
attr(temp_mat, "dimnames")<-NULL
res_df$sd<-temp_mat
rm(temp_mat)

res_df$combo<-NA

for(u in 1:nrow(res_df)){
  
  name1<-as.character(res_df[u,'species1'])
  name2<-as.character(res_df[u,'species2'])
  res_df$combo[u]<-paste(sort(c(name1,name2)),collapse='-')
}

res_df$combo<- factor(res_df$combo, levels = res_df$combo[order(res_df$value)])
#END: load RAD-seq genetic distance data for all Eliurus species pairs#

#START: load mtDNA genetic distance data for all Eliurus species pairs#
mtdna_df<-read.csv(paste0(path_data,'/',mtDNA_data))

mtdna_df$combo<-paste0(mtdna_df$species1,'-',mtdna_df$species2)

heat.mtdna<-ddply(mtdna_df,.(combo), summarise,mean_diff=mean(value), sd_diff=sd(value))
heat_sp_names<-do.call(rbind,strsplit(as.character(heat.mtdna$combo),"-"))
heat.mtdna$species1<-paste0('E. ',heat_sp_names[,1])
heat.mtdna$species2<-paste0('E. ',heat_sp_names[,2])
heat.mtdna$combo<-paste0(heat.mtdna$species1,'-',heat.mtdna$species2)
heat.mtdna$combo<-gsub('E. sp_nova','Eliurus sp. nova',as.character(heat.mtdna$combo))

res_df$mean_diff.mt<-NA
res_df$sd_diff.mt<-NA

for(u in 1:nrow(res_df)){
  coord.com<-which(heat.mtdna$combo==res_df$combo[u])
  res_df$mean_diff.mt[u]<-heat.mtdna$mean_diff[coord.com]
  res_df$sd_diff.mt[u]<-heat.mtdna$sd_diff[coord.com]
}
#END: load mtDNA genetic distance data for all Eliurus species pairs#


mtRAD<-ggplot(res_df,aes(x=value,y=mean_diff.mt,label=combo,
                  colour=factor(ifelse(combo=="E. myoxinus-Eliurus sp. nova","Highlighted","Normal"))))+
  geom_errorbar(aes(ymin = mean_diff.mt-sd_diff.mt,ymax = mean_diff.mt+sd_diff.mt),show.legend = FALSE,alpha=.3) +
  geom_errorbarh(aes(xmin = value-sd,xmax = value+sd),show.legend = FALSE,alpha=.3) +
  geom_point(show.legend = FALSE)+
  scale_colour_manual(name = "", values=c("red","black"), labels=NULL)+
  geom_text_repel(min.segment.length = 0,size   = 3,segment.size = 0.2,show.legend = FALSE)+
  theme_bw()+labs(x='RAD-seq genetic distance',y='mtDNA genetic distance')+
  theme(text= element_text(size=10))


#measure correlations
cor_res<-cor.test(res_df$mean_diff.mt, res_df$value, method="spearman")
cor_res_log<-cor.test(res_df$mean_diff.mt, log(res_df$value), method="spearman")




