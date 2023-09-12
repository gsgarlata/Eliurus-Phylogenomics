library(ape)
library(phangorn)
library(devtools)
library(magrittr)
library(phytools)
require(treeio)
require(ggtree)

path_to_file<-"/Users/gabrielemariasgarlata/Documents/Projects/PhD_project/RAD_seq/Eliurus/Eliurus_spp/analysis/mtDNA_sequenced/MrBayes/output"
path_info<-"/Users/gabrielemariasgarlata/Documents/Projects/PhD_project/RAD_seq/Eliurus/Eliurus_spp/data_info/mtDNA"

info_file<-"Eliurus_spp_IS_species_colour.csv"
input<-'./output/Eliurus_cytb_haps.con.tre'


#load mrbayes cytb  mtDNA tree
mrbayes.tree <- read.nexus(input)

#root the tree with the outgroup
new.tree<-root(mrbayes.tree$con_50_majrule,outgroup="EU349782.1_1_1140")
new.tree$node.label[1]<-""
#round the support node values
new.tree$node.label<-round(as.numeric(new.tree$node.label),digits = 1)
#give a red color id to node with bootstrap value higher than 50 
label_node<-new.tree$node.label
size_node<-rep(NA,length(label_node))
size_node[which(label_node>0.5)]<-1
col_node<-rep(NA,length(label_node))
col_node[which(label_node>0.5)]<-"red"
#edit tip labels
new.tree$tip.label<-gsub('_[0-9]_[0-9]+','',new.tree$tip.label)
#load info data
info.df<-read.csv(info_file)

#get the MRCA of two E. myoxinus sequences in the tree for collapsing E. myoxinus clade
tip1_myoxinus<-"AF160565.1"
tip2_myoxinus<-"KF058153.1"
node_myoxinus<- getMRCA(new.tree, tip = c(tip1_myoxinus, tip2_myoxinus))
col_myoxinus<-as.character(subset(info.df, SPECIES=="E_myoxinus")[,"COLOUR"])

#get the MRCA of two E. minor sequences in the tree for collapsing E. minor clade
tip1_minor<-"AMBAL.B78"
tip2_minor<-"AF160542.1"
node_minor<- getMRCA(new.tree, tip = c(tip1_minor, tip2_minor))
col_minor<-as.character(subset(info.df, SPECIES=="E_minor")[,"COLOUR"])

#get the MRCA of two E. ellermani sequences in the tree for collapsing E. ellermani clade
tip1_ellermani<-"KC433997.1"
tip2_ellermani<-"MK806743.1"
node_ellermani<- getMRCA(new.tree, tip = c(tip1_ellermani, tip2_ellermani))
col_ellermani<-as.character(subset(info.df, SPECIES=="E_ellermani")[,"COLOUR"])

#get the MRCA of two E. tanala sequences in the tree for collapsing E. tanala clade
tip1_tanala<-"AF160532.1"
tip2_tanala<-'MK806845.1'
node_tanala<- getMRCA(new.tree, tip = c(tip1_tanala, tip2_tanala))
col_tanala<-as.character(subset(info.df, SPECIES=="E_tanala")[,"COLOUR"])

#get the MRCA of two E. webbi sequences in the tree for collapsing E. webbi clade
tip1_webbi<-"AF160521.1"
tip2_webbi<-'KF058046.1'
node_webbi<- getMRCA(new.tree, tip = c(tip1_webbi, tip2_webbi))
col_webbi<-as.character(subset(info.df, SPECIES=="E_webbi")[,"COLOUR"])

#get the MRCA of two E. majori sequences in the tree for collapsing E. majori clade
tip1_majori<-"AF160558.1"
tip2_majori<-'AF160553.1'
node_majori<- getMRCA(new.tree, tip = c(tip1_majori, tip2_majori))
col_majori<-as.character(subset(info.df, SPECIES=="E_majori")[,"COLOUR"])

#get the MRCA of two E. carletoni sequences in the tree for collapsing E. carletoni clade
tip1_carletoni<-"JQ866599.1"
tip2_carletoni<-'ANALV.A39'
node_carletoni<- getMRCA(new.tree, tip = c(tip1_carletoni, tip2_carletoni))
col_carletoni<-as.character(subset(info.df, SPECIES=="E_carletoni")[,"COLOUR"])

#get the MRCA of two E. antsingy sequences in the tree for collapsing E. antsingy clade
tip1_antsingy<-"GQ420664.1"
tip2_antsingy<-'GQ420663.1'
node_antsingy<- getMRCA(new.tree, tip = c(tip1_antsingy, tip2_antsingy))
col_antsingy<-as.character(subset(info.df, SPECIES=="E_antsingy")[,"COLOUR"])

#get the MRCA of two E. grandidieri sequences in the tree for collapsing E. grandidieri clade
tip1_grandidieri<-"AF160571.1"
tip2_grandidieri<-'KY753977.1'
node_grandidieri<- getMRCA(new.tree, tip = c(tip1_grandidieri, tip2_grandidieri))
col_grandidieri<-as.character(subset(info.df, SPECIES=="E_grandidieri")[,"COLOUR"])

#get the MRCA of two Eliurus sp. nova sequences in the tree for collapsing Eliurus sp. nova clade
tip1_sp_nova<-"BC51_2017"
tip2_sp_nova<-'BH10_2017'
node_sp_nova<- getMRCA(new.tree, tip = c(tip1_sp_nova, tip2_sp_nova))
col_sp_nova<-as.character(subset(info.df, SPECIES=="Eliurus_sp_nova")[,"COLOUR"])

#get the MRCA of two E. tsingimbato sequences in the tree for collapsing E. tsingimbato clade
tip1_tsingimbato<-"MK806825.1"
tip2_tsingimbato<-'MK806816.1'
node_tsingimbato<- getMRCA(new.tree, tip = c(tip1_tsingimbato, tip2_tsingimbato))
col_tsingimbato<-as.character(subset(info.df, SPECIES=="E_tsingimbato")[,"COLOUR"])

#get the MRCA of the outgroup sequence in the tree for collapsing it
tip1_out<-"EU349782.1"
tip2_out<-'EU349782.1'
node_out<- getMRCA(new.tree, tip = c(tip1_out, tip2_out))

  
  p<-ggtree(new.tree)
  
  p2 <- p %>% collapse(node=node_myoxinus) + 
    geom_point2(aes(subset=(node==node_myoxinus)), shape=21, size=5, fill=col_myoxinus,alpha=1)+geom_cladelabel(node=node_myoxinus, expression(italic("E. myoxinus")),fontsize=6)
  p2 <- collapse(p2, node=node_sp_nova) + 
    geom_point2(aes(subset=(node==node_sp_nova)), shape=21, size=5, fill=col_sp_nova,alpha=1)+geom_cladelabel(node=node_sp_nova, expression(italic("Eliurus sp. nova")),fontsize=6)
  p2 <-collapse(p2, node=node_grandidieri) + 
    geom_point2(aes(subset=(node==node_grandidieri)), shape=21, size=5, fill=col_grandidieri,alpha=1)+geom_cladelabel(node=node_grandidieri, expression(italic(" E. grandidieri")),fontsize=6)
  p2 <-collapse(p2, node=node_antsingy) + 
    geom_point2(aes(subset=(node==node_antsingy)), shape=21, size=5, fill=col_antsingy,alpha=1)+geom_cladelabel(node=node_antsingy, expression(italic(" E. antsingy")),fontsize=6)
  p2 <-collapse(p2, node=node_carletoni) + 
    geom_point2(aes(subset=(node==node_carletoni)), shape=21, size=5, fill=col_carletoni,alpha=1)+geom_cladelabel(node=node_carletoni, expression(italic(" E. carletoni")),fontsize=6)
  p2 <-collapse(p2, node=node_tsingimbato) +
    geom_point2(aes(subset=(node==node_tsingimbato)), shape=21, size=5, fill=col_tsingimbato,alpha=1)+geom_cladelabel(node=node_tsingimbato, expression(italic("E. tsingimbato")),fontsize=6)
  p2 <-collapse(p2, node=node_majori) + 
    geom_point2(aes(subset=(node==node_majori)), shape=21, size=5, fill=col_majori,alpha=1)+geom_cladelabel(node=node_majori, expression(italic(" E. majori")),fontsize=6)
  p2 <-collapse(p2, node=node_webbi) + 
    geom_point2(aes(subset=(node==node_webbi)), shape=21, size=5, fill=col_webbi,alpha=1)+geom_cladelabel(node=node_webbi, expression(italic(" E. webbi")),fontsize=6)
  p2 <-collapse(p2, node=node_tanala) + 
    geom_point2(aes(subset=(node==node_tanala)), shape=21, size=5, fill=col_tanala,alpha=1)+geom_cladelabel(node=node_tanala, expression(italic("E. tanala")),fontsize=6)
  p2 <-collapse(p2, node=node_ellermani) + 
    geom_point2(aes(subset=(node==node_ellermani)), shape=21, size=5, fill=col_ellermani,alpha=1)+geom_cladelabel(node=node_ellermani, expression(italic("E. ellermani")),fontsize=6)
  p2 <-collapse(p2, node=node_minor) + 
    geom_point2(aes(subset=(node==node_minor)), shape=21, size=5, fill=col_minor,alpha=1)+geom_cladelabel(node=node_minor, expression(italic("E. minor")),fontsize=6)
  
  
  final_plot<-p2+geom_tiplab()+
    ggplot2::xlim(0, 0.5)

