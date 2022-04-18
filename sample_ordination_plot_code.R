library(vegan) #or phyloseq (which is technically what I used, but it's just a shell around vegan's code)
library(ggplot2)

#I install the rest of these just to be safe in case of dependencies and also so I have access to more colors
library(colorspace)
library(RColorBrewer)
library(tidyverse)
library(plyr)


#run ordination
##here I used phyloseq which has a different command than vegan but same output
##I used Bray-Curtis distance and specified NMDS ordination
ordination <- ordinate(data, "NMDS", "bray")


#TO EXTRACT NMDS LOADINGS!!!
#the default command is here https://rdrr.io/cran/vegan/man/scores.html
loadings <- scores(ordination, display = "sites")

#create a data frame with your scores as columns
nmds.loadings <- as.data.frame(scores(loadings))

#now we need to add some metadata to your scores so you can color code them by a variable
#here I just added the location/treatment information as an additional column that was already in the correct order (matched up with my sample IDs)
nmds.loadings$site <- metadata$site

#load sample file here if you want to play around with the figure or just use your own!

#plotting
#create color palette first with as many colors as you need so each "grouping" has one, I needed three since I have three different treatments/sites
nmds.color <- scale_color_manual(values = c("#079bbc", "#f9b1d5", "#cc416a"))
nmds.plot <- ggplot(nmds.loadings, aes(x = NMDS1, y = NMDS2)) + geom_point(size = 2, aes(color = site)) + nmds.color
nmds.plot

#other things i like to play around with are the alpha values of each point, especially if I have a lot of overlapping points
#this is when it's nice to have it in ggplot! There are so many cool things you can do to make it look nice
