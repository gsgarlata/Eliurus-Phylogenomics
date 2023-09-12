require(reshape2)
require(ggplot2)
require(ggrepel)
require(plyr)
require(fields)

info_file = 'Eliurus_sp_all_sp_nova_proj_RAD_dist.csv'
geo_file = 'Eliurus_spp_ID_POP.csv'
pairs_info<-rbind(c('E_myoxinus','Eliurus_sp_nova'),
                  c('E_myoxinus','E_myoxinus'),
                  c('Eliurus_sp_nova','Eliurus_sp_nova'))
parameters<-'npop125_pop5_p4_r0.80_all_sp_nova_proj_min100'

####
info_df<-read.csv(info_file)
geo_info<-read.csv(geo_file)

final<-NULL

for(i in 1:nrow(pairs_info)){
  
  species_1<-as.character(pairs_info[i,1])
  species_2<-as.character(pairs_info[i,2])
  
  #load distance matrix of raw pairwise genetic differences
  load(paste0(species_1,'_',species_2,'_',parameters,'.Rdata'))
  dist_mat<-as.matrix(res.dist)

  #convert matrix into three columns dataframe
  dist_mat[upper.tri(dist_mat,diag = F)] <- NA
  dist_df<-melt(dist_mat)
  dist_df<-dist_df[!is.na(dist_df$value),]
  
  #get species identity based on individual IDs
  dist_df$species1<-info_df$species[match(dist_df$Var1,info_df$id_code)]
  dist_df$species2<-info_df$species[match(dist_df$Var2,info_df$id_code)]
  final<-rbind(final,dist_df) 
}

#get individual IDs
final$id1<-info_df[match(final$Var1,info_df$id_code),'id']
final$id2<-info_df[match(final$Var2,info_df$id_code),'id']

unique_ids<-unique(c(final$id1,final$id2))

#match individual IDs with samples geographical coordinates in geo_file
geo_df<-geo_info[match(unique_ids,geo_info$id_seq),c('id_seq','longitude','latitude')]

#compute geographic distance
mat.dist<-rdist.earth(geo_df[,c('longitude','latitude')],miles = FALSE)
colnames(mat.dist)<-as.character(geo_df$id_seq)
rownames(mat.dist)<-as.character(geo_df$id_seq)

#convert matrix into three columns dataframe
mat.dist[upper.tri(mat.dist,diag=FALSE)] <- NA
dat.geo<-melt(mat.dist)
dat.geo<-dat.geo[-which(is.na(dat.geo$value)),]

temp_geo<-as.matrix(dat.geo[,c(1,2)])
colnames(temp_geo)<-NULL
temp_geo<-do.call(rbind,lapply(1:nrow(temp_geo), function(x) sort(temp_geo[x,])))

dat.geo$Var1<-temp_geo[,1]
dat.geo$Var2<-temp_geo[,2]

gen_dist<-data.frame(id1=final$id1,id2=final$id2,value=final$value,
                     species1=final$species1,species2=final$species2)

temp_gen<-as.matrix(gen_dist[,c(1,2)])
colnames(temp_gen)<-NULL
temp_gen<-do.call(rbind,lapply(1:nrow(temp_gen), function(x) sort(temp_gen[x,])))

gen_dist$id1<-temp_gen[,1]
gen_dist$id2<-temp_gen[,2]

gen_dist$combo_ids<-paste0(gen_dist$id1,'-',gen_dist$id2)
dat.geo$combo_ids<-paste0(dat.geo$Var1,'-',dat.geo$Var2)

gen_dist$geo_dist<-dat.geo[match(gen_dist$combo_ids,dat.geo$combo_ids),'value']
gen_dist$combo_ids<-NULL
gen_dist$sp_combo<-paste0(gen_dist$species1,'-',gen_dist$species2)
gen_dist$sp_combo<-gsub('Eliurus sp. nova-E. myoxinus','E. myoxinus-Eliurus sp. nova',gen_dist$sp_combo)
gen_dist$value<-gen_dist$value*100

#plot euclidean geographic and genetic distance
IBD_raw_dist<-ggplot(gen_dist,aes(x=geo_dist,y=value,colour=factor(sp_combo),group=factor(sp_combo)))+
  geom_smooth(se=FALSE,size=.5)+
  geom_point(alpha=.5)+
  scale_colour_manual(name='',values=c('orange','#8700fe','grey55'),
                      breaks=c('Eliurus sp. nova-Eliurus sp. nova',
                               'E. myoxinus-E. myoxinus','E. myoxinus-Eliurus sp. nova'),
                      labels=c(expression(italic('Eliurus sp. nova - Eliurus sp. nova')),
                               expression(italic('E. myoxinus - E. myoxinus')),
                               expression(italic('E. myoxinus - Eliurus sp. nova'))))+
  xlab('Geographical distance (km)')+
  ylab('Genetic Distance (% pairwise difference)')+
  theme_bw()+theme(legend.position="none",text=element_text(size=15))

#plot disribution of pairwise individual genetic distances
plot_GenDistComp<-ggplot(gen_dist,aes(x=factor(sp_combo),y=value,colour=factor(sp_combo)))+
  geom_boxplot(outlier.size = 0,alpha=.3, show.legend = F)+
  geom_point()+
  geom_signif(comparisons = list(c("Eliurus sp. nova-Eliurus sp. nova", "E. myoxinus-E. myoxinus"),
                                 c("E. myoxinus-E. myoxinus","E. myoxinus-Eliurus sp. nova"),
                                 c("E. myoxinus-Eliurus sp. nova","Eliurus sp. nova-Eliurus sp. nova")),
              map_signif_level=TRUE,vjust=0,step_increase = 0.15)+
  geom_hline(yintercept = 0,colour='red',linetype='dashed')+
  scale_colour_manual(name='',values=c('orange','#8700fe','grey55'),
                      breaks=c('Eliurus sp. nova-Eliurus sp. nova',
                               'E. myoxinus-E. myoxinus','E. myoxinus-Eliurus sp. nova'),
                      labels=c(expression(italic('Eliurus sp. nova-Eliurus sp. nova')),
                               expression(italic('E. myoxinus-E. myoxinus')),
                               expression(italic('E. myoxinus-Eliurus sp. nova'))))+
  xlab('')+ylab('Genetic Distance (% pairwise difference)')+theme_bw()+theme(axis.title.x=element_blank(),
                                                       axis.text.x=element_blank(),
                                                       axis.ticks.x=element_blank())+
  theme(text=element_text(size=15))
