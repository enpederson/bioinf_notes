library(ShortRead)
library(ggplot2)
require(scales)

download.file("https://sra-download.ncbi.nlm.nih.gov/traces/sra50/SRZ/011043/SRR11043480/8_Swamp_S1B_18S_2019_minq7.fastq","SRR-data/SRR11043480.fastq")
srr = readFastq('/projectnb/ct-shbioinf/epederso/bioinf_notes/SRR-data/', pattern='SRR11043480.fastq')
#srr = readFastq('~/Desktop/AppBioinformatics332/bioinf_notes/SRR-data', pattern='8_Swamp_S1B_18S_2019_minq7.fastq')

reads = sread(srr) # the set of sequence data
idstr = id(srr) # id numbers
qscores = quality(srr)

reads = sread(srr)
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
  

