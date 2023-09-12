require(adegenet)
require(ggplot2)
library(factoextra)
library(magrittr)
require(ape)
require(ggrepel)
require(plotrix)
library(stringr)
library(reshape2)
require(ggstar)

########
data_file = 'Eliurus_sp_npop125_pop5_p4_r0.80_all_sp_nova_proj_min100.Rdata'
info_file = 'Eliurus_sp_all_sp_nova_proj.csv'

obj<-get(load(data_file))
info_df<-read.table(info_file,sep=",",header=TRUE)  

# perform PCA analysis on genlight object
pca1<-glPca(obj,nf=4)

# extract info on PCA components
pc.eig = data.frame(pca1$eig)
pc.eig$percentage = (pc.eig[, 1]/sum(pc.eig$pca1.eig))*100

perc.pca1<-round(pc.eig$percentage[1],1)
perc.pca2<-round(pc.eig$percentage[2],1)

perc.pca3<-round(pc.eig$percentage[3],1)
perc.pca4<-round(pc.eig$percentage[4],1)

df.pca<-as.data.frame(pca1$scores)
df.pca$names<-rownames(df.pca)
rownames(df.pca)<-NULL

#assign species identity to each individuals based on mtDNA species assignment
df.pca$pop<-info_df[match(df.pca$names,info_df$id_seq),"species"]
df.pca$names<-info_df[match(df.pca$names,info_df$id_seq),"id"]
df.pca$new_names<-paste0(df.pca$pop,".",df.pca$names)

# add italic species name
my_label1<-expression(italic("E. carletoni"))
my_label2<-expression(italic("E. ellermani"))
my_label3<-expression(italic("E. minor"))
my_label4<-expression(italic("E. myoxinus"))
my_label5<-expression(italic("Eliurus sp. nova"))

# define colors and shapes for data points
color_vals<-c('#1787ff','red3','chartreuse3','#8700fe','orange')
shape_vals<-c(15,13,11,12,1)

#plot for 1 and 2 principal components
pca.plot1_2<-ggplot(df.pca,aes(x=PC1,y=PC2,label="",shape=pop))+
  geom_star(aes(starshape=pop,fill=pop),size = 4)+
  scale_fill_manual(name = 'Taxa',values=color_vals,breaks=c("E. carletoni","E. ellermani","E. minor","E. myoxinus","Eliurus sp. nova"),
                    labels=list(my_label1, my_label2, my_label3, my_label4, my_label5))+
  scale_starshape_manual(name = 'Taxa',values=shape_vals,
                         breaks=c("E. carletoni","E. ellermani","E. minor","E. myoxinus","Eliurus sp. nova"),
                         labels=list(my_label1, my_label2, my_label3, my_label4, my_label5))+
  theme_bw()+
  labs(x=paste0("PC1 (",perc.pca1,"%)"),y=paste0("PC2 (",perc.pca2,"%)"))+
  theme(text=element_text(size=15))

#plot for 3 and 4 principal components
pca.plot3_4<-ggplot(df.pca,aes(x=PC3,y=PC4,label=new_names,shape=pop))+
  geom_star(aes(starshape=pop,fill=pop),size = 4)+
  scale_fill_manual(name = 'Taxa',values=color_vals,breaks=c("E. carletoni","E. ellermani","E. minor","E. myoxinus","Eliurus sp. nova"),
                    labels=list(my_label1, my_label2, my_label3, my_label4, my_label5))+
  scale_starshape_manual(name = 'Taxa',values=shape_vals,
                         breaks=c("E. carletoni","E. ellermani","E. minor","E. myoxinus","Eliurus sp. nova"),
                         labels=list(my_label1, my_label2, my_label3, my_label4, my_label5))+
  theme_bw()+
  labs(x=paste0("PC3 (",perc.pca3,"%)"),y=paste0("PC4 (",perc.pca4,"%)"))+
  theme(text=element_text(size=15))
