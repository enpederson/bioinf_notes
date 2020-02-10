# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
# pkgs <- rownames(installed.packages())
# BiocManager::install(pkgs, type = "source", checkBuilt = TRUE)
# BiocManager::install("ShortRead")
library(ShortRead)
library(ggplot2)

dir.create("data", showWarnings = FALSE)
download.file("https://raw.githubusercontent.com/rsh249/applied_bioinformatics2020/master/data/all.fastq", "data/rapid_test.fastq")

###########################################################
rapid_test = readFastq('data', pattern='rapid_test.fastq')

# ShortRead Functions for looking at fastq data
reads = sread(rapid_test) # the set of sequence data
idstr = id(rapid_test) # id numbers
qscores = quality(rapid_test) # sequence quality strings

reads = sread(rapid_test)
class(reads) #what is this object?
length(reads)

widths = as.data.frame(reads@ranges@width)



(widthplot <- ggplot(widths) +
    geom_histogram(aes(x=reads@ranges@width), binwidth = 100) + 
    theme_linedraw() + 
    xlab('Read Length (bp)') +
    ggtitle('Not a great read length distribution'))

numqscores = as(qscores, "matrix") # converts to numeric scores automatically

avgscores = apply(numqscores, 1, mean, na.rm=TRUE) #apply the function mean() across all rows (argument '1') of the matrix and ignore "NA" values

avgscores = as.data.frame(avgscores)
colnames(avgscores) #need the column name for ggplot

ggplot(avgscores) +
  geom_histogram(aes(x=avgscores), binwidth=0.25) +
  theme_linedraw() +
  xlab('Quality Score') +
  ggtitle('Per Read Average Quality')

mdata = cbind(widths, avgscores)


ggplot(mdata) +
    geom_density_2d(aes(x=reads@ranges@width,y=avgscores)) +
    theme_linedraw() +
    xlab('Read Length (bp)') +
    ggtitle('2D Density')

#blog post about the code. including how to set up BioConductor. Plot relationship between reads and quality

