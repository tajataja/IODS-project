#Author: Janina Taurinen
#Date: 23.11.2021
#R-script of the Exercise 4 - Creating human -data set
#Meta file for these data sets: http://hdr.undp.org/en/content/human-development-index-hdi

#Data source (Human development): http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv
#Data source (Gender inequality): http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv


library(dplyr)

#Reading the “Human development” and “Gender inequality” datas into R
hd <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/human_development.csv", stringsAsFactors = F)
gii <- read.csv("http://s3.amazonaws.com/assets.datacamp.com/production/course_2218/datasets/gender_inequality.csv", stringsAsFactors = F, na.strings = "..")

#Dimensions and structures of the data sets
dim(hd) #195 obs. of  8 variables
str(hd) 

dim(gii) #195 obs. of  10 variables
str(gii) 

#Summaries of the data sets
summary(hd)
summary(gii)


#Printing out the column names of the data
colnames(hd) #HDI Rank,Country,Human Development Index (HDI),Life Expectancy at Birth,Expected Years of Education,Mean Years of Education,Gross National Income (GNI) per Capita,GNI per Capita Rank Minus HDI Rank
colnames(gii) #GII Rank,Country,Gender Inequality Index (GII),Maternal Mortality Ratio,Adolescent Birth Rate,Percent Representation in Parliament,Population with Secondary Education (Female),Population with Secondary Education (Male),Labour Force Participation Rate (Female),Labour Force Participation Rate (Male)

#Changing the long names to shorter ones
colnames(hd)[3] <- "HDI" #"Human.Development.Index..HDI." 
colnames(hd)[4] <- "LEB" #"Life.Expectancy.at.Birth" 
colnames(hd)[5] <- "EYE" #"Expected.Years.of.Education"
colnames(hd)[6] <- "MYE" #"Mean.Years.of.Education"
colnames(hd)[7] <- "GNI" #"Gross.National.Income..GNI..per.Capita"
colnames(hd)[8] <- "GNI_HDI" #"GNI.per.Capita.Rank.Minus.HDI.Rank"

colnames(hd) #HDI.Rank,Country,HDI,LEB,EYE,MYE,GNI,GNI_HDI

colnames(gii)[3] <- "GII" #"Gender.Inequality.Index..GII." 
colnames(gii)[4] <- "MMR" #"Maternal.Mortality.Ratio" 
colnames(gii)[5] <- "ABR" #"Adolescent.Birth.Rate"  
colnames(gii)[6] <- "PRP" #"Percent.Representation.in.Parliament..Female" 
colnames(gii)[7] <- "PSE_F" #"Population.with.Secondary.Education..Female."
colnames(gii)[8] <- "PSE_M" #"Population.with.Secondary.Education..Male."
colnames(gii)[9] <- "LFPR_F" #"Labour.Force.Participation.Rate..Female."
colnames(gii)[10] <- "LFPR_M" #"Labour.Force.Participation.Rate..Male."

colnames(gii) #GII.Rank,Country,GII,MMR,ABR,PRP,PSE_F,PSE_M,LFPR_F,LFPR_M


#Mutating the “Gender inequality” data and creating two new variables. 

#The first one > ratio of Female and Male populations with secondary education in each country 
gii <- mutate(gii, PSE_ratio = (PSE_F / PSE_M))

#The second one > ratio of labour force participation of females and males in each country 
gii <- mutate(gii, LFPR_ratio = (LFPR_F / LFPR_M))


#Joining the two data sets by the selected identifier 'Country'
hd_gii <- inner_join(hd, gii, by = "Country", suffix = c(".hd", ".gii"))


#Let us check that all the columns and dimensions exist
colnames(hd_gii)
dim(hd_gii)


#Let us wrap the data into txt-file
write.table(hd_gii, file = "hd_gii.txt", sep=",", row.names = TRUE, col.names = TRUE)

#And finally a try-out that the text-file works and looks appropriate
testi = read.table(file="hd_gii.txt", sep=",", header=TRUE)
str(testi)

#Looks good! 
