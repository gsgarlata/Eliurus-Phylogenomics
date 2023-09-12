require(ggplot2)
require(gridExtra)
require(ggpubr)

path_analysis<-'./output_dir/estimate'

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


final<-NULL

for(i in 1:ncombs){

  combination_id<-paste0('combination',i)
  
for(u in 1:nruns){
  
  path_data<-paste0(path_analysis,'/',combination_id)
  tmp_df<-read.table(paste0(path_data,'/run',u,'/mcmc.txt'),header=TRUE,sep="\t")
  
  tmp_df$combination<-combination_id
  tmp_df$run<-paste0('run',u)
  final<-rbind(final,tmp_df)
  rm(tmp_df)
}

}


#PLOT theta E. myoxinus
ThetaEmyox<-final[,c('theta_1Emyox','combination','run')]
ThetaEmyox$type<-paste0(ThetaEmyox$combination,'_',ThetaEmyox$run)

plotEmyoxTheta<-ggplot(ThetaEmyox, aes(x = run, y = theta_1Emyox,group=factor(type),fill=combination)) + 
  geom_violin(scale = "width", adjust = 1, width = 0.7, lwd=.1,show.legend = F)+
  scale_fill_manual(name='',values=custom.col,
                    labels=c(l.comb1,l.comb2,l.comb3,l.comb4,l.comb5,l.comb6))+
  xlab('')+ylab('')+labs(title=expression(paste(theta[italic('E. myoxinus')])))+
  theme_bw()

#PLOT theta E. minor
ThetaEminor<-final[,c('theta_2Emin','combination','run')]
ThetaEminor$type<-paste0(ThetaEminor$combination,'_',ThetaEminor$run)

plotEminorTheta<-ggplot(ThetaEminor, aes(x = run, y = theta_2Emin,group=factor(type),fill=combination)) + 
  geom_violin(scale = "width", adjust = 1, width = 0.7, lwd=.1,show.legend = F)+
  scale_fill_manual(name='',values=custom.col,
                    labels=c(l.comb1,l.comb2,l.comb3,l.comb4,l.comb5,l.comb6))+
  xlab('')+ylab('')+labs(title=expression(paste(theta[italic('E. minor')])))+
  theme_bw()

#PLOT theta Eliurus sp. nova
ThetaEspnova<-final[,c('theta_3Esp','combination','run')]
ThetaEspnova$type<-paste0(ThetaEspnova$combination,'_',ThetaEspnova$run)

plotEspnovaTheta<-ggplot(ThetaEspnova, aes(x = run, y = theta_3Esp,group=factor(type),fill=combination)) + 
  geom_violin(scale = "width", adjust = 1, width = 0.7, lwd=.1,show.legend = F)+
  scale_fill_manual(name='',values=custom.col,
                    labels=c(l.comb1,l.comb2,l.comb3,l.comb4,l.comb5,l.comb6))+
  xlab('')+ylab('')+labs(title=expression(paste(theta[italic('Eliurus sp. nova')])))+
  theme_bw()

#PLOT theta ancestral population Eliurus sp. nova - E. myoxinus
ThetaEspnovaEmyox<-final[,c('theta_5EmyoxEsp','combination','run')]
ThetaEspnovaEmyox$type<-paste0(ThetaEspnovaEmyox$combination,'_',ThetaEspnovaEmyox$run)

plotEspnovaEmyoxTheta<-ggplot(ThetaEspnovaEmyox, aes(x = run, y = theta_5EmyoxEsp,group=factor(type),fill=combination)) + 
  geom_violin(scale = "width", adjust = 1, width = 0.7, lwd=.1,show.legend = F)+
  scale_fill_manual(name='',values=custom.col,
                    labels=c(l.comb1,l.comb2,l.comb3,l.comb4,l.comb5,l.comb6))+
  xlab('')+ylab('')+labs(title=expression(paste(theta[italic('Eliurus sp. nova - E. myoxinus')])))+
  theme_bw()

#PLOT theta ancestral population Eliurus sp. nova - E. myoxinus - E. minor
ThetaEspnovaEmyoxEmin<-final[,c('theta_4EminEmyoxEsp','combination','run')]
ThetaEspnovaEmyoxEmin$type<-paste0(ThetaEspnovaEmyoxEmin$combination,'_',ThetaEspnovaEmyoxEmin$run)

plotEspnovaEmyoxEminTheta<-ggplot(ThetaEspnovaEmyoxEmin, aes(x = run, y = theta_4EminEmyoxEsp,group=factor(type),fill=combination)) + 
  geom_violin(scale = "width", adjust = 1, width = 0.7, lwd=.1,show.legend = F)+
  scale_fill_manual(name='',values=custom.col,
                    labels=c(l.comb1,l.comb2,l.comb3,l.comb4,l.comb5,l.comb6))+
  xlab('')+ylab('')+labs(title=expression(paste(theta[italic('Eliurus sp. nova - E. myoxinus - E. minor')])))+
  theme_bw()

#PLOT tau ancestral population Eliurus sp. nova - E. myoxinus - E. minor
TauEspnovaEmyoxEmin<-final[,c('tau_4EminEmyoxEsp','combination','run')]
TauEspnovaEmyoxEmin$type<-paste0(TauEspnovaEmyoxEmin$combination,'_',TauEspnovaEmyoxEmin$run)

plotEspnovaEmyoxEminTau<-ggplot(TauEspnovaEmyoxEmin, aes(x = run, y = tau_4EminEmyoxEsp,group=factor(type),fill=combination)) + 
  geom_violin(scale = "width", adjust = 1, width = 0.7, lwd=.1,show.legend = F)+
  scale_fill_manual(name='',values=custom.col,
                    labels=c(l.comb1,l.comb2,l.comb3,l.comb4,l.comb5,l.comb6))+
  xlab('')+ylab('')+labs(title=expression(paste(tau[italic('Eliurus sp. nova - E. myoxinus - E. minor')])))+
  theme_bw()

#PLOT tau ancestral population Eliurus sp. nova - E. myoxinus
TauEspnovaEmyox<-final[,c('tau_5EmyoxEsp','combination','run')]
TauEspnovaEmyox$type<-paste0(TauEspnovaEmyox$combination,'_',TauEspnovaEmyox$run)

plotEspnovaEmyoxTau<-ggplot(TauEspnovaEmyox, aes(x = run, y = tau_5EmyoxEsp,group=factor(type),fill=combination)) + 
  geom_violin(scale = "width", adjust = 1, width = 0.7, lwd=.1,show.legend = F)+
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


ploForLegend<-ggplot(lnLEspnovaEmyoxEmin, aes(x = run, y=lnL,group=factor(type),fill=combination)) + 
  geom_violin(scale = "width", adjust = 1, width = 0.7, lwd=.1)+
  scale_fill_manual(name='',values=custom.col,
                    labels=c(l.comb1,l.comb2,l.comb3,l.comb4,l.comb5,l.comb6))+
  xlab('')+ylab('')+labs(title='lnL')+
  theme_bw()


combo_PLOTS<-ggarrange(plotEmyoxTheta,plotEminorTheta,plotEspnovaTheta,plotEspnovaEmyoxTheta,
                                     plotEspnovaEmyoxEminTheta,plotEspnovaEmyoxEminTau,
                                     plotEspnovaEmyoxTau,plotEspnovaEmyoxlnL,nrow=3,ncol=3)





