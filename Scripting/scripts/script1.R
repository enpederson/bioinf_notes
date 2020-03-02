#!/usr/bin/R

#Initialize with libraries
library(rBLAST)
library(ShortRead)
library(ggplot2)
library(taxonomizr)
library(dplyr)
library(forcats)

#set paths
Sys.setenv(PATH=paste(Sys.getenv("PATH"), "/share/pkg.7/blast+/2.7.1/install/bin", sep=":"))
Sys.setenv(PATH=paste(Sys.getenv("PATH"), "/share/pkg.7/sratoolkit/2.9.2/install/bin/", sep=":"))



