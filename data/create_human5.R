#Author: Janina Taurinen
#Date: 23.11.2021
#R-script of the Exercise 5 - Modifying human -data set
#Meta file for these data sets: http://hdr.undp.org/en/content/human-development-index-hdi

#Data source (Human development): http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv
#Data source (Gender inequality): http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv

library(stringr)
library(dplyr)

#Reading the data
human = read.table(file="hd_gii.txt", sep=",", header=TRUE)

#Exploring the dimensions and structure of the data
dim(human) #195 obs. of  19 variables
str(human) #Including numeric, integers and characters

colnames(human)
#"HDI.Rank"   
#"Country"    
#"HDI"      "Human.Development.Index..HDI."
#"LEB"      "Life.Expectancy.at.Birth"  
#"EYE"      "Expected.Years.of.Education"  
#"MYE"      "Mean.Years.of.Education"  
#"GNI"      "Gross.National.Income..GNI..per.Capita" 
#"GNI_HDI"   
#"GII.Rank" "GNI.per.Capita.Rank.Minus.HDI.Rank"  
#"GII"      "Gender.Inequality.Index..GII."  
#"MMR"      "Maternal.Mortality.Ratio"    
#"ABR"      "Adolescent.Birth.Rate"   
#"PRP"      "Percent.Representation.in.Parliament.Female" 
#"PSE_F"    "Population.with.Secondary.Education..Female." 
#"PSE_M"    "Population.with.Secondary.Education..Male."
#"LFPR_F"   "Labour.Force.Participation.Rate..Female."  
#"LFPR_M"   "Labour.Force.Participation.Rate..Male."   
#"PSE_ratio"     "Ratio of Female and Male populations with secondary education in each country"
#"LFPR_ratio"    "Ratio of labour force participation of females and males in each country"

#Mutating GNI to numeric
str_replace(human$GNI, pattern=",", replace ="") %>% as.numeric

#Keeping only some of the variables
keep <- c("Country", "PSE_ratio", "LFPR_ratio", "EYE", "LEB", "GNI", "MMR", "ABR", "PRP")
human <- select(human, one_of(keep))


#Removing all rows with missing values
#Completeness indicator of the 'human' data
complete.cases(human)

#Data along with a completeness indicator as the last column
data.frame(human[-1], comp = complete.cases(human))

#Filtering out all rows with NA (missing) values
human <- filter(human, complete.cases(human) == TRUE)


#Removing the observations which relate to regions instead of countries

#The last 10 observations of human
tail(human, 10)

#Defining the last indice we want to keep (checked from the data)
last <- nrow(human) - 7

#Choosing everything until the last 7 observations
human_ <- human[1:last,]
human_

#Adding countries as rownames
rownames(human_) <- human_$Country

#Removing the Country variable
human_ <- select(human_, -Country)

human_
str(human_)


#Let us wrap the data into txt-file
write.table(human_, file = "human5.txt", sep=",", row.names = TRUE, col.names = TRUE)

#And finally a try-out that the text-file works and looks appropriate
testi = read.table(file="human5.txt", sep=",", header=TRUE)
str(testi)

#Looks good!


