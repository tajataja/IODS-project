#Author: Janina Taurinen
#Date: 7.12.2021
#R-script of the Exercise 6 - BPRS and RATS -data set
#Background of the data sets (chapters 8 & 9): https://mooc.helsinki.fi/pluginfile.php/192850/course/section/7335/MABS4IODS-Part6.pdf


library(dplyr)
library(tidyr)

#Reading the “BPRS” and “RATS” datas into R
BPRS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/BPRS.txt", sep="", header=TRUE)
RATS <- read.table("https://raw.githubusercontent.com/KimmoVehkalahti/MABS/master/Examples/data/rats.txt", sep="", header=TRUE)

#Dimensions and structures of the data sets
dim(BPRS) #40 obs. of  11 variables
str(BPRS) 

dim(RATS) #16 obs. of  13 variables
str(RATS) 

#Summaries of the data sets
summary(BPRS)
summary(RATS)


#Factor treatment & subject of BPRS
BPRS$treatment <- factor(BPRS$treatment)
BPRS$subject <- factor(BPRS$subject)

#Factor ID & Group of RATS
RATS$ID <- factor(RATS$ID)
RATS$Group <- factor(RATS$Group)

glimpse(BPRS)
glimpse(RATS)

#Converting data sets to long form
BPRSL <-  BPRS %>% gather(key = weeks, value = bprs, -treatment, -subject)
RATSL <-  RATS %>% gather(key = times, value = Weight, -ID, -Group)

#Extract the week number
BPRSL <-  BPRSL %>% mutate(week = as.integer(substr(weeks,5,5)))
RATSL <-  RATSL %>% mutate(Time = as.integer(substr(times,3,4)))

# Take a glimpse at the BPRSL data
glimpse(BPRSL)
glimpse(RATSL)


#Column names
colnames(BPRSL)
colnames(RATSL)

#Data contents and structures
str(BPRSL)
str(RATSL)

#Summaries of the variables
summary(BPRSL)
summary(RATSL)



#Let us wrap the data sets into txt-file
write.table(BPRSL, file = "BPRSL.txt", sep=",", row.names = TRUE, col.names = TRUE)
write.table(RATSL, file = "RATSL.txt", sep=",", row.names = TRUE, col.names = TRUE)

#And finally a try-out that the text-file works and looks appropriate
B = read.table(file="BPRSL.txt", sep=",", header=TRUE)
str(B) #360 obs. of 5 variables

R = read.table(file="RATSL.txt", sep=",", header=TRUE)
str(R) #176 obs. of 5 variables

#Looks good! 
