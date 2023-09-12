require(ape)
require(seqinr)
require(phangorn)

input_phylip = './input/Eliurus_sp_npop125_pop5_p4_r0.80_all_sp_nova_proj_min100.all.phylip'
DNAbin_file = './input/Eliurus_sp_npop125_pop5_p4_r0.80_all_sp_nova_proj_min100_all.Rdata'
parameters = 'npop125_pop5_p4_r0.80_all_sp_nova_proj_min100'

info_file = 'Eliurus_sp_all_sp_nova_proj_RAD_dist.csv'
species_1 = 'E_myoxinus'
species_2 = 'Eliurus_sp_nova'
DNAbin_obj = paste0(DNAbin_file,".Rdata")
output = paste0(species_1,'_',species_2,'_',parameters)

#
if(file.exist(DNAbin_obj)){
#read phylip file
DNAbin<-as.DNAbin(read.alignment(file = input_phylip,format = "phylip"))
#save phylip file as a DNAbin object
save(DNAbin,file=DNAbin_obj)
}else{
#load DNAbin object if already saved
load(DNAbin_obj)
}

#load info data
df.info<-read.csv(info_file)
#set a species pair
species_list<-c(species_1,species_2)
#get info on species pair
sub.info<-df.info[df.info$species %in% species_list,]
#subset genetic data for a given species pair
new.dnabin<-DNAbin[rownames(DNAbin) %in% sub.info$id_code,]
#create genetic distance matrix
res.dist<-dist.dna(new.dnabin,model="raw",pairwise.deletion=TRUE)
#save distance matrix
save(res.dist,file=paste0(output,".Rdata"))

