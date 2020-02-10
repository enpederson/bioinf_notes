
# function needed for visualization purposes
sigmoid = function(params, x) {
  params[1] / (1 + exp(-params[2] * (x - params[3])))
}

x = c(0.1,0.5,1,5,10,50,100,500,1000,5000,10000)
y = c(1.82,5,8.64,20,28.64,55.45,67.73,86.36,91.36,97.73,100)

fitmodel <- nls(y~a/(1 + exp(-b * (x-c))), start=list(a=150,b=0.01,c=50))
params=coef(fitmodel)

y2 <- sigmoid(params,x)
plot(y2,type="l")
points(y)
