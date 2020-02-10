library(ShortRead)
library(ggplot2)

srr = readFastq('data', pattern='/projectnb/ct-shbioinf/epederso/bioinf_notes/SRR-data/SRR11043480.fastq')

reads = sread(srr) # the set of sequence data
idstr = id(srr) # id numbers
qscores = quality(srr)

reads = sread(srr)
widths = as.data.frame(reads@ranges@width)

numqscores = as(qscores, "matrix") # converts to numeric scores automatically
avgscores = apply(numqscores, 1, mean, na.rm=TRUE) #apply the function mean() across all rows (argument '1') of the matrix and ignore "NA" values
avgscores = as.data.frame(avgscores)

ggplot(mdata) +
  #geom_point(aes(x=reads@ranges@width,y=avgscores)) +
  geom_density_2d(aes(x=reads@ranges@width,y=avgscores)) +
  theme_linedraw() +
  xlab('Read Length (bp)') +
  ggtitle('2D Density')