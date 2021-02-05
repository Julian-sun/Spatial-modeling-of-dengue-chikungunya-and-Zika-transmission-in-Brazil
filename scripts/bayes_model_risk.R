### Function to compute spatial risk of dengue, zika and chick in Brazil
### Last update: 07/03/2020


#Load necessary libraries
packes_list <- c("spdep", "tidyverse", "rgdal", "leaflet", "rworldmap",
                 "beepr", "R2OpenBUGS", "maptools", "mapdata", "maps","INLA")


lapply(packes_list, require, character.only = TRUE)

#Start help functions

makeNeigh <- function(shape){
  #This function take as input a shpapefile and
  #return a neighbourd matrix for been used in INLA models
  map.gen <- readShapePoly(shape)
  temp <- poly2nb(map.gen)
  nb2INLA(file = "map.graph", temp)
  map.adj <- paste(getwd(),"/map.graph",sep="")
  #return(inla.read.graph("map.graph"))
  return(map.adj)
}

runZIPModel <- function(data, cases, expected, nbMatrix){
  #This function return a INLA model result using zero inltafed poisson 1 family
  
  #Time that model will start to run
  start <-  Sys.time()
  
  #Enquote variales to be used in a dplyr way
  expected <- enquo(expected)
  cases <- enquo(cases)
  
  #manipulate the dataset to make varialbes avaliable to INLA model
  data <- data %>%
    mutate(Y = !!cases,
           spaceUnstr = 1:nrow(data),
           expected = !!expected + 0.00001) %>% 
    replace_na(list(Y = 0))
  
  #Create the model formula
  # formula <- Y ~ 1 + f(spaceUnstr,  model="bym", graph=nbMatrix,
  #                      hyper=list(prec.unstruct=list(prior="gaussian",param=c(0,1)),
  #                                 prec.spatial=list(prior="gaussian",param=c(0,1))))
  
  formula <- Y ~ 1 + f(spaceUnstr, model="bym",graph=H, scale.model=TRUE,
                       hyper=list(prec.unstruct=list(prior="loggamma",param=c(1,0.001)), 
                                  prec.spatial=list(prior="loggamma",param=c(1,0.001))))
  
  #run model
  #modelResult <- inla(formula, family = "zeroinflatedpoisson1",
  #                    data = data,
  #                    offset = log(expected),
  #                    control.predictor = list(compute = TRUE),
  #                    control.compute = list(dic = TRUE))
  modelResult <- inla(formula,family="poisson",
                      data = data,
                      E=E,
                      control.predictor = list(compute = TRUE),
                      control.compute=list(dic=TRUE))
  
  beep(4)
  stop <- Sys.time()
  print(paste0("This model takes ", stop - start, " min to run"))
  return(modelResult)
}


H <- makeNeigh("/media/juliane_oliveira/My Passport/dropbox_15_11_2019/Artigos_preprints/analise_de_risco/estimations_for_all_diseases/Spatial-modeling-of-dengue-chikungunya-and-Zika-transmission-in-Brazil/Data/BRMUE250GC_SIR.shp")

library(readxl)

########## Dengue model ###################
data_risk_space <- read_excel("Standard_incidence_ratio_dengue.xls")
View(data_risk_space)

data.dengue <- data.frame(ZBS=data_risk_space$ZBS, Y=data_risk_space$`2015`, E=data_risk_space$expected_2015)

mod.zip1 <- runZIPModel(data.dengue, Y,E,H)


######## Zika model ######################

data_risk_space <- read_excel("standard_incidence_ratio_zika (1).xls")
View(data_risk_space)

data.zika <- data.frame(ZBS=data_risk_space$ZBS, Y=data_risk_space$`2015`, E=data_risk_space$expected_2015)

mod.zip1 <- runZIPModel(data.zika, Y,E,H)

round(mod.zip1$summary.hyperpar,3)
summary(mod.zip1)

mod.zip1$dic

round(mod.zip1$summary.fixed) 
head(mod.zip1$summary.random$spaceUnstr) #partial output

exp.b0.mean <- inla.emarginal(exp,mod.zip1$marginals.fixed[[1]])
exp.b0.mean
exp.b0.95CI <- inla.qmarginal(c(0.025,0.975), inla.tmarginal(exp,mod.zip1$marginals.fixed[[1]]))
exp.b0.95CI

############ Getting outputs from the models

csi <- mod.zip1$marginals.random$spaceUnstr[1:5572]
zeta <- lapply(csi,function(x) inla.emarginal(exp,x))

value<-c()
for (i in 1:5572){
  x <- zeta[[i]]
  value <- append(value,x)}
summary(value)

data_risk_space$zeta2015_poisson <-value

################## wiring on files

######## dengue

write.csv(data_risk_space,'Modified_standard_incidence_ratio_dengue.csv')

####### Zika

write.csv(data_risk_space,'estimated_standard_incidence_ratio_zika.csv')

####### Chik

write.csv(data_risk_space,'Modified_standard_incidence_ratio_chik.csv')
