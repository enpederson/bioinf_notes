#setwd('Tutorial')

#load packages
#devtools::install_github("mhahsler/rBLAST")
library(rBLAST)
library(ShortRead)
library(ggplot2)
#install.packages('taxonomizr')
library(taxonomizr)
library(dplyr)
library(forcats)

Sys.setenv(PATH=paste(Sys.getenv("PATH"), "/share/pkg.7/blast+/2.7.1/install/bin", sep=":"))
Sys.setenv(PATH=paste(Sys.getenv("PATH"), "/share/pkg.7/sratoolkit/2.9.2/install/bin/", sep=":"))

#srr=c('SRR11043480, SRR11043497, SRS6120496') #use label from repository
#srr=c('SRR11043480') #HW
#srr=c('SRS6120496') #not much
srr=c('SRS6120502') #largest dataset
system(paste('fastq-dump', srr, sep=' ')) #load fastq

dna = readFastq('.', pattern=srr)

reads = sread(dna, id=id(dna)) # parse DNA sequences

qscores = quality(dna) # parse quality scores

bl <- blast(db="/projectnb/ct-shbioinf/blast/nt.fa") #access local BLAST database

cl <- predict(bl, reads, BLAST_args = '-num_threads 12 -evalue 1e-100')
accid = as.character(cl$SubjectID) # accession IDs of BLAST hits

#load the taxonomy database files 'nodes' and 'names'
taxaNodes<-read.nodes.sql("/projectnb/ct-shbioinf/taxonomy/data/nodes.dmp")
taxaNames<-read.names.sql("/projectnb/ct-shbioinf/taxonomy/data/names.dmp")
# Search the taxonomy by accession ID #

# takes accession number and gets the taxonomic ID
ids<-accessionToTaxa(accid,'/projectnb/ct-shbioinf/taxonomy/data/accessionTaxa.sql')

# displays the taxonomic names from each ID #
taxlist=getTaxonomy(ids, taxaNodes, taxaNames)

# Merge BLAST hits and taxonomy of each
cltax=cbind(cl,taxlist)

cltop = cltax %>% 
  group_by(QueryID) %>% 
  top_n(n=10, wt=Bits)



(ggplot(data=cltop) +
    geom_bar(aes(x=fct_infreq(genus))) +
    theme_minimal() +
    theme(    
      axis.text.x  = element_text(angle = 45, hjust=1)
    ) +
    xlab('')
  
)

#test
cltop2 = cltax %>% 
  group_by(QueryID) %>% 
  top_n(n=1, wt=Bits)

(ggplot(data=cltop2) +
    geom_bar(aes(x=fct_infreq(class))) +
    theme_minimal() +
    theme(    
      axis.text.x  = element_text(angle = 45, hjust=1)
    ) +
    xlab('')
  
)

require(scales)
widths = as.data.frame(reads@ranges@width)

numqscores = as(qscores, "matrix") # converts to numeric scores automatically
avgscores = apply(numqscores, 1, mean, na.rm=TRUE) #apply the function mean() across all rows (argument '1') of the matrix and ignore "NA" values
avgscores = as.data.frame(avgscores)
mdata = cbind(widths, avgscores)

my_breaks = c(1,2,4,8,16,32,64,128,256,512,1024)

ggplot(mdata,aes(x=reads@ranges@width,y=avgscores)) +
  geom_bin2d(bins = 48) +
  #geom_point(size=0.5,alpha=0.1,colour="white") +
  
  #stat_density_2d(aes(fill = ..level..), geom = "polygon", colour="white") +
  scale_fill_gradient(low="lightblue2",high="darkblue", name = "count", trans = "log",
                      breaks = my_breaks, labels = my_breaks) +
  scale_x_log10(breaks = trans_breaks("log10", function(x) 10^x),
                labels = trans_format("log10", math_format(10^.x))) +
  #geom_density_2d(colour="white",bins=6) +
  theme_linedraw() +
  ggtitle('2D Density') +
  #ylab('Average Scores') +
  #xlab(bquote("Read Length (log" [10] "bp)")) +
  labs( y='Average Scores', x=expression('Read Length (log'[10]* ' bp)'))

# git check
