# Disease mapping of dengue chikungunya and Zika transmission in Brazilian municipalities

## Objective: 

This repository aims to provide the code used for spatial modeling of dengue, chikungunya and Zika. This work is separated into two steps:

  1. Data treatment and preparation;
  2. Coding the algorithm to estimate the spatial relative incidence risk of each of the diseases, for each Brasilian municipality. 

## Data treatment and preparation

In order to conduct our analyses, we need to know the number of  observed and the number of  expected cases for each Brasilian municipality. To calculate the expected number of cases, it is necessary to know information about the gender and age group of the infected individual.  We extracted  from the Brazilian National Notifiable Diseases Information System (SINAN), the information related to the municipality ('codmunres'), year of notification (extracted from the date of notification variable), gender (cs_sexo') and age  group ('nu_idade_n'). 
