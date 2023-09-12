
path_data = '/Users/gabrielemariasgarlata/Documents/Projects/PhD_project/RAD_seq/Manuscripts/Eliurus_sp_nova/ms_submission/MolecularPhylogeneticsEvolution/revision1/data_and_scripts/morphology'
morpho_file ='morpho_bioclim_data_eliurus_v2.csv'
tree_name = 'eliurus_pop_genomics_pop1_p0_wlist_miss04.phy'
morpho_vars = c('head_length','body_lentgth','tail_length','weight')
names_morphio_vars = c('Head Length (mm)','Body Length (mm)','Tail length (mm)','Weight (g)')
name_list<-c('E. myoxinus','E. carletoni','E. minor','E. ellermani','Eliurus sp. nova')
colour_sp<-c("#8700fe","#1787ff","chartreuse3","red3","orange")
bio_labels = c('Annual Mean Temperature','Mean Diurnal Range','Isothermality','Temperature Seasonality',
               'Max Temperature of Warmest Month','Min Temperature of Coldest Month',
               'Temperature Annual Range','Mean Temperature of Wettest Quarter','Mean Temperature of Driest Quarter',
               'Mean Temperature of Warmest Quarter','Mean Temperature of Coldest Quarter',
               'Annual Precipitation','Precipitation of Wettest Month','Precipitation of Driest Month',
               'Precipitation Seasonality','Precipitation of Wettest Quarter','Precipitation of Driest Quarter',
               'Precipitation of Warmest Quarter','Precipitation of Coldest Quarter')

out_path = ''
  
###
full_morphoDF = read.csv(paste0(path_data,'/',morpho_file))
tree_file = read.tree(paste0(path_data,'/',tree_name))


tree_file$tip.label = full_morphoDF[match(tree_file$tip.label,full_morphoDF$id_seq),'id']

moprho_df = full_morphoDF

moprho_df$species = NULL
moprho_df$id = NULL
moprho_df$id_seq = NULL

rownames(moprho_df) = morpho_data$id

td = treedata(tree_file, moprho_df)

morphoData = as.data.frame(td$data)
eliurusTree = td$phy

bio_vars = names(morphoData)[grep('bio|altitude',names(morphoData))]

#START: PERFORM PGLS ANALYSIS ACROSS ALL 4 MORPHOLOGICAL VARIABLES,
#AND 19 BIOCLIMATIC VARIABLES + ALTITUDE
final_data = NULL
fitted_data = NULL

for(b in 1:length(bio_vars)){
  
  for(k in 1:length(morpho_vars)){
    
    #extract pairs of morphological and bioclimatic variables
    morphoVarData = morphoData[,c(morpho_vars[k],bio_vars[b])]
    names(morphoVarData) = c('value','bio_var')
    #perform PGLS analysis
    pglsModel <- gls(value ~ bio_var, correlation = corBrownian(phy = eliurusTree),
                     data = morphoVarData, method = "ML")
    
    summ_res = summary(pglsModel)
    res_vals = coef(summ_res)[2,]
    
    tmp_data = data.frame(slope=as.numeric(res_vals['Value']),std_error = as.numeric(res_vals['Std.Error']),
                          t_value = as.numeric(res_vals['t-value']),p_value = as.numeric(res_vals['p-value']),morpho_var=morpho_vars[k], 
                          bio_var = bio_vars[b])
    
    tmp_fitted = data.frame(id=names(summ_res$fitted),bio_var = morphoVarData$bio_var,
                            value=as.numeric(summ_res$fitted), morpho_var = morpho_vars[k], bio_name = bio_vars[b])
    
    final_data = rbind(final_data,tmp_data)
    fitted_data = rbind(fitted_data,tmp_fitted)
    
    rm(pglsModel,tmp_fitted,tmp_data)
    
  }
}
#END: PERFORM PGLS ANALYSIS ACROSS ALL 4 MORPHOLOGICAL VARIABLES,
#AND 19 BIOCLIMATIC VARIABLES + ALTITUDE


#START: PERFORM MULTIPLE TEST CORRECTION BASED ON Benjamini & Yekutieli (2001) 
tot_adj = NULL

for(f in 1:length(morpho_vars)){
  
  tmp_morpho = subset(final_data,morpho_var==morpho_vars[f])
  
  tmp_morpho$adj_pval = p.adjust(tmp_morpho$p_value, method = 'BH')
  
  tot_adj = rbind(tot_adj,tmp_morpho)
  
}
#END: PERFORM MULTIPLE TEST CORRECTION BASED ON Benjamini & Yekutieli (2001) 

#GET SPECIES NAMES
morphoData$species = full_morphoDF[match(rownames(morphoData),full_morphoDF$id),'species']



###START: PREPARE LABELS FOR PLOTTING OF CLIMATIC VARIABLES (i.e., excluding ALTITUDE)
tot_adj$x = NA
tot_adj$y = NA

tot_stats = NULL

clim_vars = bio_vars[!bio_vars %in% 'altitude']

for(l in 1:length(clim_vars)){
  
  tmp_bio = subset(tot_adj,bio_var==clim_vars[l])
  
  for(j in 1:nrow(tmp_bio)){
    
    if(tmp_bio$morpho_var[j]=='head_length'){
      tmp_bio$x[j] = as.numeric(quantile(morphoData[,clim_vars[l]])[4])
      tmp_bio$y[j] = 53
    }
    
    if(tmp_bio$morpho_var[j]=='body_lentgth'){
      tmp_bio$x[j] = as.numeric(quantile(morphoData[,clim_vars[l]])[4])
      tmp_bio$y[j] = 130
    }
    
    if(tmp_bio$morpho_var[j]=='tail_length'){
      tmp_bio$x[j] = as.numeric(quantile(morphoData[,clim_vars[l]])[4])
      tmp_bio$y[j] = 250
    }
    if(tmp_bio$morpho_var[j]=='weight'){
      tmp_bio$x[j] = as.numeric(quantile(morphoData[,clim_vars[l]])[4])
      tmp_bio$y[j] = 140
    }
    
  }
  tot_stats = rbind(tot_stats,tmp_bio)
}

tot_stats$round_slope = round(tot_stats$slope,4)
tot_stats$round_pval = round(tot_stats$adj_pval,4)

tot_stats$label = paste0('slope = ',tot_stats$round_slope,'\n p-value = ',tot_stats$round_pval)
###END: PREPARE LABELS FOR PLOTTING OF CLIMATIC VARIABLES (i.e., excluding ALTITUDE)


###START: MAKE PLOTS ONLY WITH CLIMATIC VARIABLES
shape_vals<-c(12,15,11,13,1)

for(k in 1:length(morpho_vars)){
  
  plot.list<-vector("list",length=length(clim_vars))
  
  for(b in 1:length(clim_vars)){
    
    
    morph_fit_data = subset(fitted_data,morpho_var==morpho_vars[k] & bio_name==clim_vars[b])
    obs_morph = data.frame(bio_var= morphoData[,clim_vars[b]],value = morphoData[,morpho_vars[k]],species = morphoData$species)
    rownames(obs_morph) = rownames(morphoData)
    
    stat_morpho = subset(tot_stats,morpho_var==morpho_vars[k] & bio_var==clim_vars[b])
    
    plot.list[[b]] = ggplot()+
      geom_line(data=morph_fit_data,aes(x=bio_var,y=value),colour='red')+
      geom_star(data = obs_morph,aes(x=bio_var,y=value,starshape=species,fill=species),size = 2)+
      geom_label(data=stat_morpho,aes(x=x,y=y,label=label))+
      geom_smooth(data=obs_morph,aes(x=bio_var,y=value),method='lm', formula= y~x, colour = 'black')+
      scale_starshape_manual(name='',values=shape_vals,breaks=name_list,guide = guide_legend(label.theme = element_text(angle = 0, face = "italic")))+
      scale_fill_manual(name='',breaks=name_list,values=colour_sp,
                        guide = guide_legend(label.theme = element_text(angle = 0, face = "italic")))+
      scale_color_manual(name='',breaks=name_list,values=colour_sp,
                         guide = guide_legend(label.theme = element_text(angle = 0, face = "italic")))+
      xlab(bio_labels[b])+ylab(names_morphio_vars[k])+
      theme_bw()
    
  }
  
  
  
  grid<-ggarrange(plotlist=plot.list,align = "hv",
                  common.legend = TRUE, legend="right")
  
  ggsave(plot=grid,filename = paste(out_path,"/plot_",morpho_vars[k],"_Eliurus_spp_PGLS_climate.png",sep=""),width = 17,height = 10)
  
  rm(grid,plot.list)
}
###END: MAKE PLOTS ONLY WITH CLIMATIC VARIABLES


####START: MAKE PLOTS ONLY WITH ALTITUDE###
morphoData_altitude = morphoData[,c('head_length','body_lentgth','tail_length','weight','altitude','species')]

alt_final_data = tot_adj[tot_adj$bio_var %in% 'altitude',]
alt_fitted_data = fitted_data[fitted_data$bio_name=='altitude',]

for(j in 1:nrow(alt_final_data)){
  
  if(alt_final_data$morpho_var[j]=='head_length'){
    alt_final_data$x[j] = 1000
    alt_final_data$y[j] = 53
  }
  
  if(alt_final_data$morpho_var[j]=='body_lentgth'){
    alt_final_data$x[j] = 1000
    alt_final_data$y[j] = 130
  }
  
  if(alt_final_data$morpho_var[j]=='tail_length'){
    alt_final_data$x[j] = 1000
    alt_final_data$y[j] = 250
  }
  if(alt_final_data$morpho_var[j]=='weight'){
    alt_final_data$x[j] = 1000
    alt_final_data$y[j] = 140
  }
  
}

alt_final_data$round_slope = round(alt_final_data$slope,4)
alt_final_data$round_pval = round(alt_final_data$adj_pval,4)

alt_final_data$label = paste0('slope = ',alt_final_data$round_slope,'\n p-value = ',alt_final_data$round_pval)

plot.ALTlist<-vector("list",length=length(morpho_vars))

for(k in 1:length(morpho_vars)){
  
  morph_fit_data = subset(alt_fitted_data,morpho_var==morpho_vars[k])
  obs_morph = data.frame(altitude= morphoData_altitude$altitude,value = morphoData_altitude[,morpho_vars[k]],species = morphoData_altitude$species)
  rownames(obs_morph) = rownames(morphoData_altitude)
  
  stat_morpho = subset(alt_final_data,morpho_var==morpho_vars[k])
  
  plot.ALTlist[[k]] = ggplot()+
    geom_line(data=morph_fit_data,aes(x=bio_var,y=value),colour='red')+
    geom_star(data = obs_morph,aes(x=altitude,y=value,starshape=species,fill=species, colour = species),size = 2)+
    geom_label(data=stat_morpho,aes(x=x,y=y,label=label))+
    geom_smooth(data=obs_morph,aes(x=altitude,y=value),method='lm', formula= y~x, colour = 'black')+
    scale_starshape_manual(name='',values=shape_vals,breaks=name_list,guide = guide_legend(label.theme = element_text(angle = 0, face = "italic")))+
    scale_fill_manual(name='',breaks=name_list,values=colour_sp,
                      guide = guide_legend(label.theme = element_text(angle = 0, face = "italic")))+
    scale_colour_manual(name='',breaks=name_list,values=colour_sp,
                        guide = guide_legend(label.theme = element_text(angle = 0, face = "italic")))+
    xlab('Altitude (m)')+ylab(names_morphio_vars[k])+
    theme_bw()
  
  
}

gridALT<-ggarrange(plotlist=plot.ALTlist,align = "hv",
                   common.legend = TRUE, legend="right")

ggsave(plot=gridALT,filename = paste(out_path,"/plotCorrelation_morphologyVERSUSaltitude_Eliurus_spp.png",sep=""),width = 10,height = 7)
####END: MAKE PLOTS ONLY WITH ALTITUDE###


