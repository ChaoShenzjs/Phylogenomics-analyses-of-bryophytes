sink("results.txt", append = FALSE, split=TRUE)
library(ape)
library(coda)
library(BAMMtools)
library(phytools)

tree <- read.tree("bryophyte_only_timetree_million_decreasing.nwk")
events <- read.csv("bryophyte_event_data.txt")
#plot(tree, cex=0.2)
#nodelabels(cex=0.5)
ed <- getEventData(tree, events, burnin=0.25)
shift_probs <- summary(ed)

#Check shift set and nodes
print("----------------------------------------------")
print("shift set and nodes")
head(ed$eventData)

# burnin 25% of samples
mcmcout <- read.csv("bryophyte_mcmc_out.txt", header=T)
burnstart <- floor(0.25 * nrow(mcmcout))
postburn <- mcmcout[burnstart:nrow(mcmcout), ]

# Check ESS
print("----------------------------------------------")
print("number_of_shifts_ESS:")
effectiveSize(postburn$N_shifts)
print("----------------------------------------------")
print("logLikelihood_ESS:")
effectiveSize(postburn$logLik)

#Compare BayesFactors
print("----------------------------------------------")
print("BayesFactors[Bayes factors greater than 20 generally imply strong evidence for one model over another; values greater than 50 are very strong evidence in favor of the numerator model]:")
bfmat <- computeBayesFactors(mcmcout, expectedNumberOfShifts=1, burnin=0.25)
bfmat

#the number of macroevolutionary rate regimes on our phylogenetic tree
print("----------------------------------------------")
post_probs <- table(postburn$N_shifts) / nrow(postburn)
print("Models included:")
names(post_probs)
post_probs

#estimate the 95% credible set of rate shifts
print("95 % credible set of rate shift configurations sampled with BAMM")
css <- credibleShiftSet(ed, expectedNumberOfShifts=1, threshold=20, set.limit = 0.95)
print("Here is the total number of samples in the posterior:")
length(ed$eventData)
print("And here is the number of distinct shift configurations:")
css$number.distinct
print("----------------------------------------------")
print("summary statistics:")
summary(css)
print("Accessing the raw frequency vector for the credible set:")
css$frequency
css$eventData[[1]]
css$cumulative

#Create PDF results
pdf(file="BAMMresults.pdf")
#Test convergence
plot(mcmcout$logLik ~ mcmcout$generation)
#PlotPrior: BAMMtools also has a function for visualizing the prior and posterior simultaneously. This is useful to see what models are not being sampled in the posterior, and also to evaluate how far from the prior the posterior has moved. To use it
plotPrior(mcmcout, expectedNumberOfShifts=1)

# marginal shift probablities
marg_probs <- marginalShiftProbsTree(ed)
plot.phylo(marg_probs, lwd=0.3, cex=0.02, show.tip.label = TRUE)
title(main = "marg_probs")
branch_priors <- getBranchShiftPriors(tree, expectedNumberOfShifts = 1)
plot(branch_priors, edge.width = 0.3, cex=0.02)
title(main = "branch_priors")

#meanPhyloRate
q <- plot(ed, spex="netdiv", tau=0.05, pal="temperature", breaksmethod='jenks', lwd=2)
addBAMMlegend(q, location= 'topleft')
addBAMMshifts(ed, cex=1)
title(main = "meanPhyloRate(netdiv)")

q <- plot(ed, spex="s", tau=0.05, pal="temperature", breaksmethod='jenks', lwd=2)
addBAMMlegend(q, location= 'topleft')
addBAMMshifts(ed, cex=1)
title(main = "meanPhyloRate(speciation)")

q <- plot(ed, spex="e", tau=0.05, pal="temperature", breaksmethod='jenks', lwd=2)
addBAMMlegend(q, location= 'topleft')
addBAMMshifts(ed, cex=1)
title(main = "meanPhyloRate(extinction)")

#BestShiftConfiguration
best <- getBestShiftConfiguration(ed, expectedNumberOfShifts=1)
bt <- plot(best, spex="netdiv", tau=0.05, pal="temperature", breaksmethod='jenks', lwd=2)
addBAMMlegend(bt, location= 'topleft')
addBAMMshifts(best, cex=1)
title(main = "BestShiftConfiguration(netdiv)")

best <- getBestShiftConfiguration(ed, expectedNumberOfShifts=1)
bt <- plot(best, spex="s", tau=0.05, pal="temperature", breaksmethod='jenks', lwd=2)
addBAMMlegend(bt, location= 'topleft')
addBAMMshifts(best, cex=1)
title(main = "BestShiftConfiguration(speciation)")

#95% creditble shift sets
cs <- plot(css, spex="netdiv", tau=0.05, pal="temperature", breaksmethod='jenks', lwd=2)

# Rate Through Time bryophytes, hornworts, mosses, liverworts
st <- max(branching.times(tree))
plotRateThroughTime(ed, ratetype = "netdiv", intervalCol="darkgreen", avgCol="darkgreen", start.time=st, ylim=c(0,0.2), cex.axis=1)
text(x=250, y= 0.2, label="bryophyte", font=4, cex=1.0, pos=1)

plotRateThroughTime(ed, ratetype = "netdiv", intervalCol="red", avgCol="red", start.time=st, node=286, ylim=c(0,0.2), cex.axis=1)
text(x=250, y= 0.2, label="liverwort", font=4, cex=1.0, pos=1)

plotRateThroughTime(ed, ratetype = "netdiv", intervalCol="orange", avgCol="orange", start.time=st, node=221, ylim=c(0,0.2), cex.axis=1)
text(x=250, y= 0.2, label="moss", font=4, cex=1.0, pos=1)

plotRateThroughTime(ed, ratetype = "netdiv", intervalCol="light blue", avgCol="light blue", start.time=st, node=203, ylim=c(0,0.2), cex.axis=1)
text(x=250, y= 0.2, label="hornwort", font=4, cex=1.0, pos=1)

dev.off()
sink()
