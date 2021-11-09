#Author: Janina Taurinen
#Date: 8.11.2021
#R-script of the Exercise 2

library(dplyr)


lrn14 = read.table("http://www.helsinki.fi/~kvehkala/JYTmooc/JYTOPKYS3-data.txt", sep="\t", header=TRUE)

dim(lrn14)
#resulting in [1] 183  60 --> 183 observations of 60 variables in the file

str(lrn14)
#resulting in letter and numeric codes
#The last rows are Age, Attitude, Points and gender
#everything else is integer except gender, which is a character "F" or "M"


#Next the missing variables (deep, surf, stra + attitude) will be formed by combining the questions in a way described in the given txt-file.
Attitude_questions = c("Da", "Db", "Dc", "Dd", "De", "Df", "Dg", "Dh", "Di", "Dj")
deep_questions = c("D03", "D11", "D19", "D27", "D07", "D14", "D22", "D30", "D06", "D15", "D23", "D31")
surf_questions = c("SU02", "SU10", "SU18", "SU26", "SU05", "SU13", "SU21", "SU29", "SU08", "SU16", "SU24", "SU32")
stra_questions = c("ST01", "ST09", "ST17", "ST25", "ST04", "ST12", "ST20", "ST28")


#The combined questions form a data frame which will be added as a variable to our lrn14 -data
#The variables are scaled by taking the mean 
Attitude_columns = select(lrn14, one_of(Attitude_questions))
lrn14$Attitude = rowMeans(Attitude_columns)

deep_columns = select(lrn14, one_of(deep_questions))
lrn14$deep = rowMeans(deep_columns)

surf_columns = select(lrn14, one_of(surf_questions))
lrn14$surf = rowMeans(surf_columns)

stra_columns = select(lrn14, one_of(stra_questions))
lrn14$stra = rowMeans(stra_columns)


#Let us exclude all the unnecessary variables
keep_columns = c("gender","Age","Attitude", "deep", "stra", "surf", "Points")
learning2014 = select(lrn14, one_of(keep_columns))


#Now we rename some the variables so that each variable starts with a lower key
colnames(learning2014)[2] <- "age"
colnames(learning2014)[3] <- "attitude"
colnames(learning2014)[7] <- "points"


#Exclude observations where the exam points are zero
learning2014 <- filter(learning2014, points > 0)


#Double checking
# 1. all the needed variables are in our data and they are named appropriately
# 2. Observations with points = 0 have been excluded -> resulting in 166 obs. of 7 variables
str(learning2014)


#Let us wrap the cleaned data into txt-file
write.table(learning2014, file = "learning2014.txt", sep=",", row.names = TRUE, col.names = TRUE) #\t")


#And finally a try-out that the text-file really works and looks appropriate
testi = read.table(file="learning2014.txt", sep=",", header=TRUE)
str(testi)


#Looks good!
