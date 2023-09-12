#!/bin/sh
#SBATCH -J IndCoverage
#SBATCH -c 6
#SBATCH --mem=20G

args = commandArgs(trailingOnly=TRUE)

require(data.table)
library(foreach)
library(doParallel)

data_file<-args[1]
path_data<-args[2]
threads<-as.numeric(args[3])


dat<-read.table(data_file,header=FALSE)

setwd(path_data)

file_map<-vector()
for(i in 1:length(dat[,1])){
  file_map[i]<-list.files(pattern=paste(dat[i,1],".coverage.txt",sep=""))
  }

file_names<-gsub(paste(".coverage.txt",sep=""),"",file_map)

collectors = vector("list", length(file_map))

collectors[[1]][[1]]= as.data.frame(fread(file_map[1]))

for(index in 2:length(file_map)) {
  reduced_set <- mclapply(file_map[[index]], function(x) {
    as.data.frame(fread(x))
  }, mc.cores=threads)
  collectors[[index]]= reduced_set
}


save(file=paste0(path_data,'/IndCoverage.Rdata'),collectors)
