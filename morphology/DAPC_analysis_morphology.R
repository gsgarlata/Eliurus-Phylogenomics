require(adegenet)
require(ggplot2)
require(ggstar)

input<-"morpho_bioclim_data_eliurus.csv"
colour_sp<-c("chartreuse3","#8700fe","#1787ff","red3","orange")
name_list<-c('E. minor','E. myoxinus','E. carletoni','E. ellermani','Eliurus sp. nova')

obj <- read.csv(file=input)

data_dapc = obj[,-grep('species|id|bio|altitude|id_seq',names(obj))]

#Perform DAPC analysis
#set the number PCs to retain to 4
#set the number discriminant functions to retain = 4
dapc.res<- dapc(data_dapc,obj$species)

#methods to find the optimal number of PCs to include
temp <- optim.a.score(dapc.res)

#get infos on DAPC
dapc.eig = data.frame(dapc.res$eig)
dapc.eig$percentage = (dapc.eig[, 1]/sum(dapc.eig$dapc.res.eig))*100
perc.dapc1<-round(dapc.eig$percentage[1],1)

######START SCATTER PLOT OF DAPC ANALYSIS FOR PRINCIPAL DAPC COMPONENTS######
###### 1, 2, 3, 4.###### 
dapc_dfpc1_2 = data.frame(x=dapc.res$ind.coord[,'LD1'],y=dapc.res$ind.coord[,'LD2'],type=dapc.res$grp)
dapc_dfpc3_4 = data.frame(x=dapc.res$ind.coord[,'LD3'],y=dapc.res$ind.coord[,'LD4'],type=dapc.res$grp)

shape_vals<-c(11,12,15,13,1)

plotDAPC12 = ggplot(dapc_dfpc1_2,aes(x=x,y=y,shape=type,colour=type))+
  geom_star(aes(starshape=type,fill=type),size = 3,alpha=.8)+
  stat_ellipse(show.legend = FALSE)+
  scale_fill_manual(name = '',values=colour_sp,breaks=name_list,
                    guide = guide_legend(label.theme = element_text(angle = 0, face = "italic")))+
  scale_starshape_manual(name = '',values=shape_vals,
                         breaks=name_list,
                         guide = guide_legend(label.theme = element_text(angle = 0, face = "italic")))+
  scale_colour_manual(name='',breaks=name_list,values=colour_sp,
                      guide = guide_legend(label.theme = element_text(angle = 0, face = "italic")))+
  theme_bw()+
  labs(x='DAPC component 1',y='DAPC component 2')


plotDAPC34 = ggplot(dapc_dfpc3_4,aes(x=x,y=y,shape=type,colour=type))+
  geom_star(aes(starshape=type,fill=type),size = 3,alpha=.8)+
  stat_ellipse(show.legend = FALSE)+
  scale_fill_manual(name = '',values=colour_sp,breaks=name_list,
                    guide = guide_legend(label.theme = element_text(angle = 0, face = "italic")))+
  scale_starshape_manual(name = '',values=shape_vals,
                         breaks=name_list,
                         guide = guide_legend(label.theme = element_text(angle = 0, face = "italic")))+
  scale_colour_manual(name='',breaks=name_list,values=colour_sp,
                      guide = guide_legend(label.theme = element_text(angle = 0, face = "italic")))+
  theme_bw()+
  labs(x='DAPC component 3',y='DAPC component 4')
######END SCATTER PLOT OF DAPC ANALYSIS FOR PRINCIPAL DAPC COMPONENTS######
###### 1, 2, 3, 4.###### 


######START: LOADING PLOT CONTRIBUTION MORPHO VARIABLES TO MORPHO STRUCTURE
#threashodl at 0.07
contrib <- loadingplot(dapc.res$var.contr, axis=1,
                       thres=.07, lab.jitter=1)

load_df = as.data.frame(dapc.res$var.contr)
load_df$variables = gsub('_',' ',rownames(load_df))

plotLoadings = ggplot(load_df,aes(x=variables,y=LD1,group=variables,colours=variables))+
  geom_bar(stat = "identity")+
  geom_hline(yintercept=0.2669348,size=0.6,linetype='dashed')+
  xlab('')+
  ylab('Contribution to morphological structure')+
  theme_bw()+
  theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1))  
######END: LOADING PLOT CONTRIBUTION MORPHO VARIABLES TO MORPHO STRUCTURE

