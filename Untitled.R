census = read.csv('https://raw.githubusercontent.com/rsh249/applied_bioinformatics2020/master/data/census.csv')
library(ggplot2)

ggplot(data = census) +
  geom_point(aes(x = Citizen, y = TotalPop))

ggplot(data=census) + 
  geom_point(aes(x=IncomePerCap, y=Poverty), alpha=0.1) +
  geom_smooth(aes(x=IncomePerCap, y=Poverty)) # adds a line of best fit
