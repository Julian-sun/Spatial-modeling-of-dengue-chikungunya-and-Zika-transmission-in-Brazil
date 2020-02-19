# Spatial analyses of dengue chikungunya and Zika transmission by Brazilian municipalities

## Objective: 

This repository aims to provide the code used for spatial modeling of dengue (from 2000 up to 2017), chikungunya (from 2014 up to 2017) and Zika (from 2015 up to 2017), by Brazilian municipalities. This work is separated into two steps:

  1. Data treatment and preparation;
  2. Coding the algorithm to estimate the spatial relative incidence risk of each of the diseases, for each Brasilian municipality. 

## Data treatment and preparation

  In order to conduct our analyses, we need to know the number of  observed confirmed cases and the number of  expected cases for each Brasilian municipality. To calculate the expected number of cases, it is necessary to know information about the gender and age group of the infected individual.  We extracted from the Brazilian National Notifiable Diseases Information System (SINAN) the following individual information for each disease considered: the municipality ('codmunres'), year of notification (extracted from the date of notification variable), gender (cs_sexo') and age group ('nu_idade_n'). Additionally to the observed number of cases, we also need to collect the total population number for each of this strata.

### Extracting variables from SINAN database: 
  
  If you are familiar with Apache Spark, you can run the SINAN_Extracao_Dengue.ipynp file, located in the  "Data-preparation-for-epidemiological-studies" directory (link: https://github.com/Julian-sun/Data-preparation-for-epidemiological-studies.git),  provided that you have the csv files obtained from  DATASUS.  In the same directory you can learn how to download data from DATASUS in an optimized way using Python.  

### Expected number of cases of dengue, chikugunya and Zika

  In the file “Standard_incidence_ratio.ipynb” (present in this directory), we describe how to calculate the expected number of cases per municipality. The output csv file is used to estimate the Standard Incidence ratio, that will be coded in R software. 
