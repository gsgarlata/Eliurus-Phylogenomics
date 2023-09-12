require(ape)
require(phangorn)
require(devtools)
require(magrittr)
require(phytools)
require(treeio)
require(ggtree)

##
sub_type<-"N125_pop5_p4_min100"
info_file<-"Eliurus_sp_all_sp_nova_proj_RAXML.csv" #Eliurus_sp_10inds_species_RAXML.csv or Eliurus_sp_1inds_site_RAXML.csv or Eliurus_sp_all_sp_nova_proj_RAXML.csv
path_tree = paste0('./output/',sub_type)
snp_type = 'all' #'fixed' or 'all'
##

fasta_file<-paste0('Eliurus_sp_',sub_type,'.',snp_type,'.fas')


#####  
infile_ML<-list.files(path=path_tree,pattern="RAxML_bipartitionsBranchLabels")
input_ML<-pate0(path_tree,"/",infile_ML)

#load RAXML tree
raxml.tree.ML<-read.raxml(input_ML)
#perform midpoint rooting
raxml.tree.ML@phylo<-midpoint(raxml.tree.ML@phylo,node.labels = "support")
#give bootstrap values at the nodes
raxml.tree.ML@phylo$node.label<-raxml.tree.ML@data$bootstrap
#get phylo  tree
ML.tree<-raxml.tree.ML@phylo
#get info data
id_raxml<-read.csv(info_file,sep=",",header = TRUE)
raxsp<-id_raxml[match(ML.tree$tip.label, id_raxml$CODE),"FINAL"]
ML.tree$tip.label<-as.character(raxsp)
#give a red color id to node with bootstrap value higher than 50 
label_node<-ML.tree$node.label
size_node<-rep(NA,length(label_node))
size_node[which(label_node>50)]<-1
col_node<-rep(NA,length(label_node))
col_node[which(label_node>50)]<-"red"

size_node[which(is.na(size_node))]<-0
col_node[which(is.na(col_node))]<-"black"

raxml_col<-id_raxml[match(ML.tree$tip.label, id_raxml$FINAL),"COLOUR"]

tips_info<-read.csv(paste0(path_tree,'/species_tips_',sub_type,'.csv'))

myox_df<-subset(tips_info,species=='E_myoxinus')
tip1myox<-myox_df$tip1
tip2myox<-myox_df$tip2

carl_df<-subset(tips_info,species=='E_carletoni')
tip1carl<-carl_df$tip1
tip2carl<-carl_df$tip2

eller_df<-subset(tips_info,species=='E_ellermani')
tip1eller<-eller_df$tip1
tip2eller<-eller_df$tip2

min_df<-subset(tips_info,species=='E_minor')
tip1min<-min_df$tip1
tip2min<-min_df$tip2

sp_df<-subset(tips_info,species=='Eliurus_sp_nova')
tip1sp<-sp_df$tip1
tip2sp<-sp_df$tip2

end<-ggtree(ML.tree,layout=phylo_method)+geom_nodepoint(size=c(NA,size_node),colour=c(NA,col_node),pch=8,na.rm =TRUE)+
  geom_tiplab(align=FALSE, linetype='dashed', linesize=.3,size=2)+
  geom_tippoint(color=raxml_col, size=1)+
  geom_strip(tip1myox, tip2myox, barsize=2, color='#8700fe', 
             label='bolditalic(E.~~myoxinus)', offset=.1,offset.text=.1,parse = TRUE,fontsize=6)+
  geom_strip(tip1sp, tip2sp, barsize=2, color='orange', 
             label='bolditalic(Eliurus~~sp.~~nova)',offset=.15, offset.text=.05,parse = TRUE,fontsize=6)+
  geom_strip(tip1min, tip2min, barsize=2, offset=.1,color='chartreuse3', 
             label='bolditalic(E.~~minor)', offset.text=.05,parse = TRUE,fontsize=6)+
  geom_strip(tip1eller, tip2eller, barsize=2, color='red3', 
             label='bolditalic(E.~~ellermani)',offset=.18, offset.text=.05,parse = TRUE,fontsize=6)+
  geom_strip(tip1carl, tip2carl, barsize=2, color='#1787ff', 
             label='bolditalic(E.~~carletoni)',offset=.1, offset.text=.05,parse = TRUE,fontsize=6)


plot.MSA<-msaplot(end,fasta=paste0(path_tree,'/',fasta_file),color=c('white','#E69F00','#56B4E9','#009E73','#F0E442'),
                  offset=.45)



