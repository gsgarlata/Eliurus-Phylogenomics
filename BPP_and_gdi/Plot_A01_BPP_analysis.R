require(ggplot2)
require(gridExtra)
require(ggpubr)

sub_analysis<-'finetune1' #finetune0 or finetune1
ncombs<-6
nruns<-4

l.comb1<-expression(paste(beta['theta'],':0.002; ',beta['tau'],':0.02'))
l.comb2<-expression(paste(beta['theta'],':0.002; ',beta['tau'],':0.002'))
l.comb3<-expression(paste(beta['theta'],':0.02; ',beta['tau'],':0.02'))
l.comb4<-expression(paste(beta['theta'],':0.02; ',beta['tau'],':0.002'))
l.comb5<-expression(paste(beta['theta'],':0.2; ',beta['tau'],':0.02'))
l.comb6<-expression(paste(beta['theta'],':0.2; ',beta['tau'],':0.2'))

custom.col <- c("#FFDB6D", "#C4961A", "#F4EDCA", 
                "#D16103", "#C3D7A4", "#52854C")

path_analysis<-paste0('./output_dir/',sub_analysis)

final<-NULL

for(i in 1:ncombs){
  
  combination_id<-paste0('combination',i)
  
  for(u in 1:nruns){
    
    path_data<-paste0(path_analysis,'/',combination_id)
    tmp_df<-read.table(paste0(path_data,'/run',u,'/mcmc.txt'),header=FALSE,skip=1,sep="\t")
    tmp_df$combination<-combination_id
    tmp_df$run<-paste0('run',u)
    final<-rbind(final,tmp_df)
    rm(tmp_df)
  }
  
}

names(final)<-c('Gen','np','Tree','tau_4EminEmyoxEsp','tau_5EmyoxEsp','lnL','combination','run')

#PLOT tau ancestral population Eliurus sp. nova - E. myoxinus
TauEminEmyoxEsp<-final[,c('tau_4EminEmyoxEsp','combination','run')]
TauEminEmyoxEsp$type<-paste0(TauEminEmyoxEsp$combination,'_',TauEminEmyoxEsp$run)

plotEminEmyoxEspTau<-ggplot(TauEminEmyoxEsp, aes(x = run, y = tau_4EminEmyoxEsp,group=factor(type),fill=combination)) + 
  geom_violin(scale = "width", adjust = 1, width = 0.7,lwd=.1,show.legend = F)+
  scale_fill_manual(name='',values=custom.col,
                    labels=c(l.comb1,l.comb2,l.comb3,l.comb4,l.comb5,l.comb6))+
  xlab('')+ylab('')+labs(title=expression(paste(tau[italic('Eliurus sp. nova - E. myoxinus - E. minor')])))+
  theme_bw()

#PLOT tau ancestral population Eliurus sp. nova - E. myoxinus
TauEmyoxEsp<-final[,c('tau_5EmyoxEsp','combination','run')]
TauEmyoxEsp$type<-paste0(TauEmyoxEsp$combination,'_',TauEmyoxEsp$run)

plotEmyoxEspTau<-ggplot(TauEmyoxEsp, aes(x = run, y = tau_5EmyoxEsp,group=factor(type),fill=combination)) + 
  geom_violin(scale = "width", adjust = 1, width = 0.7,lwd=.1,show.legend = F)+
  scale_fill_manual(name='',values=custom.col,
                    labels=c(l.comb1,l.comb2,l.comb3,l.comb4,l.comb5,l.comb6))+
  xlab('')+ylab('')+labs(title=expression(paste(tau[italic('Eliurus sp. nova - E. myoxinus')])))+
  theme_bw()


#PLOT tau ancestral population Eliurus sp. nova - E. myoxinus
lnLEspnovaEmyoxEmin<-final[,c('lnL','combination','run')]
lnLEspnovaEmyoxEmin$type<-paste0(lnLEspnovaEmyoxEmin$combination,'_',lnLEspnovaEmyoxEmin$run)

plotEspnovaEmyoxlnL<-ggplot(lnLEspnovaEmyoxEmin, aes(x = run, y=lnL,group=factor(type),fill=combination)) + 
  geom_violin(scale = "width", adjust = 1, width = 0.7,lwd=.1,show.legend = F)+
  scale_fill_manual(name='',values=custom.col,
                    labels=c(l.comb1,l.comb2,l.comb3,l.comb4,l.comb5,l.comb6))+
  xlab('')+ylab('')+labs(title='lnL')+
  theme_bw()

combo_plots<-ggarrange(plotEminEmyoxEspTau,plotEmyoxEspTau,plotEspnovaEmyoxlnL,nrow=1,ncol=3)
