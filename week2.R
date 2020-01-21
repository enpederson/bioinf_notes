x<-2
n='abc'
y='def'
n<y
1<y

z=seq(10,1)
class(z)
print(z)

print(z[2])
z[4]='four'
class(z)
print(z[c(1,3,5)])
d = matrix(nrow=5,ncol=5)
print(d)

d[,1]=5
print(d)
d[,1] = seq(1:5) # put data in column 1
d[,2] = seq(6:10)
d[,3] = seq(11:15)
d[,4] = seq(16:20)
d[,5] = seq(11:15)
print(d)

file = 'https://raw.githubusercontent.com/rsh249/applied_bioinformatics2020/master/data/mtcars.csv'
cars = read.table(file, header=T, sep = ',')
head(cars)

write.table(cars, file='mtcars.tab')
write.csv(cars, file='mtcars.csv')

hist(cars[,'mpg'])
boxplot(cars[,'hp'])



