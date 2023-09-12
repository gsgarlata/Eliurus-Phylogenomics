require(tidyr)
require(ggplot2)
require(multcompView)
require(ggpubr)

generate_label_df <- function(TUKEY, variable){
  
  # Extract labels and factor levels from Tukey post-hoc 
  Tukey.levels <- variable[,4]
  Tukey.labels <- data.frame(multcompLetters(Tukey.levels)['Letters'])
  
  #I need to put the labels in the same order as in the boxplot :
  Tukey.labels$treatment=rownames(Tukey.labels)
  Tukey.labels=Tukey.labels[order(Tukey.labels$treatment) , ]
  return(Tukey.labels)
}

input = 'morpho_bioclim_data_eliurus.csv'
name_list<-c('E. minor','E. myoxinus','E. carletoni','E. ellermani','Eliurus sp. nova')
colour_sp<-c("chartreuse3","#8700fe","#1787ff","red3","orange")
names_morphio_vars = c('Head Length (mm)','Body Length (mm)','Tail length (mm)','Weight (gr)')

#load morphological data
obj <- read.csv(file=input)

#change format of the dataframe (including only morphological variables)
df.long <- pivot_longer(obj, cols=3:6, names_to = "morpho_type", values_to = "value")
morpho_vars = unique(df.long$morpho_type)

plot.list<-vector("list",length=length(morpho_vars))

#perform box plots for each morphological variable, independently
for(i in 1:length(morpho_vars)){
  
  data_dos = subset(df.long,morpho_type==morpho_vars[i])
  
  p<-ggplot(data_dos,aes(x=factor(species),y=value,colour=factor(species)))+
    geom_boxplot(outlier.size = 0,alpha=.3, show.legend = F) +
    geom_jitter(alpha=.3,show.legend = F)+
    scale_colour_manual(name='',breaks=name_list,values=colour_sp)+
    xlab('')+ylab(names_morphio_vars[i])+ylim(min(data_dos$value),max(data_dos$value)+20)+
    theme_bw()+theme(axis.title.x=element_blank(),
                     axis.text.x=element_text(face = "italic"),
                     axis.ticks.x=element_blank())
  
  #perform linear regression analysis
  model=lm(value ~ species, data=data_dos)
  
  #perfom ANOVA analysis
  ANOVA=aov(model)
  
  #assess sifgnificant differences between box plots
  TUKEY <- TukeyHSD(ANOVA)
  labels <- generate_label_df(TUKEY, TUKEY$species)
  
  names(labels) <- c('Letters','species')
  yvalue <- aggregate(data_dos$value, list(data_dos$species), data=data_dos, quantile, probs=.75)  
  final <- data.frame(labels, yvalue[,2])
  
  names(final)<-c("letters","species","value")
  
  morpho_var_plot = p + geom_text(data = final,  aes(x=species, y=value, colour=species,label=letters),
                                  vjust=-5, hjust=-1,size=5,fontface = "bold",show.legend = F)+
    theme(axis.text.x = element_text(angle = 45, vjust = 1, hjust=1,size=10))  
  
  plot.list[[i]] <- morpho_var_plot
  
}

grid<-ggarrange(plotlist=plot.list,align = "hv",
                common.legend = TRUE, legend="right")
