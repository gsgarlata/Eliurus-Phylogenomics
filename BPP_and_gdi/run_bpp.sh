#!/bin/bash
#SBATCH -p workq

path_BPP=bpp-4.3.8-linux-x86_64/bin

control_file=$1

$path_BPP/bpp --cfile $control_file
