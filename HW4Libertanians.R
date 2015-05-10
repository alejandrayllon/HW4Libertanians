#install package to use mosaic
install.packages("vcd")
library(vcd)

#bring in information
Info <- read.csv("GSS.csv")

#use only the year 2012 and get rid of unwanted columns
Info1 <- Info[Info$Gss.year.for.this.respondent == "2012",]
Info1 <- Info1[c(3,4)]

#turn the neutrals into NAs
Info1$marry <- sub("agree nor disagree", NA, Info1$marry, ignore.case = TRUE)
Info1$marry <- sub("not applicable", NA, Info1$marry, ignore.case = TRUE)
Info1$marry <- sub("cant choose", NA, Info1$marry, ignore.case = TRUE)

#change disagree to oppose so that grepl doesn't say TRUE when searching for agree
Info1$marry <- sub("disagree", "oppose", Info1$marry, ignore.case = TRUE)

#substitute the numbers to reduce, since people who favor are under Govt reduce diff
Info1$income <- sub("1", "reduce", Info1$income, ignore.case = TRUE)
Info1$income <- sub("2", "reduce", Info1$income, ignore.case = TRUE)
Info1$income <- sub("3", "reduce", Info1$income, ignore.case = TRUE)

#turn the neutrals into NAs
Info1$income <- sub("4", NA, Info1$income, ignore.case = TRUE)
Info1$income <- sub("not applicable", NA, Info1$income, ignore.case = TRUE)
Info1$income <- sub("no answer", NA, Info1$income, ignore.case = TRUE)

#get rid of NA rows
Info2 <- na.omit(Info1)

#turn agrees into TRue and the others, which are disagrees, to FALSE
Info2$marry <- grepl("agree", Info2$marry, ignore.case = TRUE)

#turn reduces into TRue and the others, which are no govt actions, to FALSE
Info2$income <- grepl("reduce", Info2$income, ignore.case = TRUE)

#change TRUEs to FAVORs and FALSEs to OPPOSEs
Info2$income <- sub("TRUE", "FAVOR", Info2$income, ignore.case = TRUE)
Info2$income <- sub("FALSE", "OPPOSE", Info2$income, ignore.case = TRUE)
Info2$marry <- sub("TRUE", "FAVOR", Info2$marry, ignore.case = TRUE)
Info2$marry <- sub("FALSE", "OPPOSE", Info2$marry, ignore.case = TRUE)

#Puet everything into a table
Parties <- table(Info2$income,Info2$marry)

#Use mosaicplot to make the final image
mosaicplot(Parties, main = "Where To Find The Libertarians", xlab = "INCOME REDISTRIBUTION", ylab = "GAY MARRIAGE", shade = TRUE)



