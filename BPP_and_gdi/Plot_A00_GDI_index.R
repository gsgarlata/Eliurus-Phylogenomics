require(ggplot2)
require(gridExtra)
require(ggpubr)
require(reshape2)


path_proj<-'/Users/gabrielemariasgarlata/Documents/Projects/PhD_project/RAD_seq/Eliurus'
parameters<-'npop15_pop5_p4_3ind_per_species_min15'
ncombs<-6
nruns<-4

path_analysis<-'./output_dir/estimate'


l.comb1<-expression(paste(beta['theta'],':0.002; ',beta['tau'],':0.02'))
l.comb2<-expression(paste(beta['theta'],':0.002; ',beta['tau'],':0.002'))
l.comb3<-expression(paste(beta['theta'],':0.02; ',beta['tau'],':0.02'))
l.comb4<-expression(paste(beta['theta'],':0.02; ',beta['tau'],':0.002'))
l.comb5<-expression(paste(beta['theta'],':0.2; ',beta['tau'],':0.02'))
l.comb6<-expression(paste(beta['theta'],':0.2; ',beta['tau'],':0.2'))

custom.col <- c("#FFDB6D", "#C4961A", "#F4EDCA", 
                "#D16103", "#C3D7A4", "#52854C")


final<-NULL

for(i in 1:ncombs){
  
  combination_id<-paste0('combination',i)
  
  for(u in 1:nruns){
    
    path_data<-paste0(path_analysis,'/',combination_id)
    tmp_df<-read.table(paste0(path_data,'/run',u,'/mcmc.txt'),header=TRUE,sep="\t")
    tmp_df$combination<-combination_id
    tmp_df$run<-paste0('run',u)
    tmp_df$gdiEsp<-(1-exp(-(2*tmp_df$theta_5EmyoxEsp/tmp_df$theta_3Esp)))
    tmp_df$gdiEmyox<-(1-exp(-(2*tmp_df$theta_5EmyoxEsp/tmp_df$theta_1Emyox)))
    final<-rbind(final,tmp_df)
    rm(tmp_df)
  }
}

GDItmp<-final[,c('gdiEsp','gdiEmyox','combination','run')]
GDItmp$type<-paste0(GDItmp$combination,'_',GDItmp$run)
GDIdataset<-melt(GDItmp,id.vars=c('combination','run','type'))
GDIdataset$x_value<-paste0(GDIdataset$variable,'_',GDIdataset$run)


plotGDI<-ggplot(GDIdataset, aes(x = x_value, y = value,group=factor(type),fill=combination))+ 
  geom_violin(scale = "width", adjust = 1, width = 4,lwd=.6,show.legend = F)+
  scale_fill_manual(name='',values=custom.col,
                    labels=c(l.comb1,l.comb2,l.comb3,l.comb4,l.comb5,l.comb6))+ 
  xlab('')+ylab(expression(paste(italic('gdi'),' index')))+
  scale_x_discrete(labels=c("gdiEsp_run1" = expression(paste(theta[italic('Eliurus sp. nova')])),
                            "gdiEsp_run2" = expression(paste(theta[italic('Eliurus sp. nova')])),
                            "gdiEsp_run3" = expression(paste(theta[italic('Eliurus sp. nova')])),
                   "gdiEsp_run4" = expression(paste(theta[italic('Eliurus sp. nova')])),
                   "gdiEmyox_run1" = expression(paste(theta[italic('E. myoxinus')])),
                   "gdiEmyox_run2" = expression(paste(theta[italic('E. myoxinus')])),
                   "gdiEmyox_run3" = expression(paste(theta[italic('E. myoxinus')])),
                   "gdiEmyox_run4" = expression(paste(theta[italic('E. myoxinus')]))))+
  theme_bw()+
  theme(text=element_text(size=20),axis.text.x=element_text(angle=45,hjust=1))



