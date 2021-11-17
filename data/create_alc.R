#Author: Janina Taurinen
#Date: 15.11.2021
#R-script of the Exercise 3 - Creating alc
#Data source: UCI Machine Learning Repository: https://archive.ics.uci.edu/ml/datasets/Student+Performance
#The structure of the code is originally made by Reijo Sund: https://raw.githubusercontent.com/rsund/IODS-project/master/data/create_alc.R

library(dplyr)

#Reading the two csv-files
math = read.table(file = "student-mat.csv", sep=";", header=TRUE)
por = read.table(file = "student-por.csv", sep=";", header=TRUE)


#Examining dimensions and structures of the data
dim(math)
#resulting in [1] 395  33 --> 395 observations of 33 variables in the file
dim(por)
#resulting in [1] 649  33 --> 649 observations of 33 variable in the file


str(math)
#resulting in string and integer (numeric) observations

str(por)
#resulting in string and integer (numeric) observations


#Own id for both datasets
por_id <- por %>% mutate(id=1000+row_number()) 
math_id <- math %>% mutate(id=2000+row_number())

#Columns that vary in datasets
free_cols <- c("id","failures","paid","absences","G1","G2","G3")

#The rest of the columns are common identifiers used for joining the datasets
join_cols <- setdiff(colnames(por_id),free_cols)

pormath_free <- por_id %>% bind_rows(math_id) %>% select(one_of(free_cols))


#Combining datasets to one data --> NOTE! 370 students that belong to both datasets
  #Calculating required variables from two observations 
pormath <- por_id %>% bind_rows(math_id) %>% group_by(.dots=join_cols) %>% 
summarise(                                                           
    n=n(),
    id.p=min(id),
    id.m=max(id),
    failures=round(mean(failures)),     # Rounded mean for numerical
    paid=first(paid),                   # and first for chars
    absences=round(mean(absences)),
    G1=round(mean(G1)),
    G2=round(mean(G2)),
    G3=round(mean(G3))    
) %>%
  #Removing lines that do not have exactly one obs from both datasets -> must be 2 obs found in order to join
  #In addition, 1 must be from por and 1 from math
  #(id:s differ more than max within one dataset (649 here))
filter(n==2, id.m-id.p>650) %>%  
  # Join original free fields, because rounded means or first values may not be relevant
inner_join(pormath_free,by=c("id.p"="id"),suffix=c("",".p")) %>%
inner_join(pormath_free,by=c("id.m"="id"),suffix=c("",".m")) %>%
  #Calculating alcohol use by taking an average of weekday (Dalc) and weekend (Walc) alcohol consumption
  #Calculating high usage -> TRUE for students which 'alc_use' is greater than 2
ungroup %>% mutate(alc_use = (Dalc + Walc) / 2,high_use = alc_use > 2, cid=3000+row_number())


#Let us wrap the cleaned data into txt-file
write.table(pormath, file = "pormath.txt", sep=",", row.names = TRUE, col.names = TRUE) #\t")
  
  
#And finally a try-out that the text-file works and looks appropriate
testi = read.table(file="pormath.txt", sep=",", header=TRUE)
str(testi)

#Looks good! 
# [370 obs. of 51 variables]