library(BAMMtools)

tree <- read.tree("bryophyte_only_timetree_million_decreasing.nwk")
events <- read.csv("bryophyte_event_data.txt")
ed <- getEventData(tree, events, burnin=0.25)

# Rate Through Time bryophytes, hornworts, mosses, liverworts
st <- max(branching.times(tree))

plotRateThroughTime(ed, ratetype = "netdiv", intervals = seq(from = 0, 0.95, by = 0.01), intervalCol="blue", 
                    avgCol="blue", start.time=st, node=203, ylim=c(0,0.15), cex.axis=1,  smooth=TRUE,lwd = 1.5)

plotRateThroughTime(ed, ratetype = "netdiv", intervals = seq(from = 0, 0.95, by = 0.01), intervalCol="red", 
                    avgCol="red", start.time=st, node=286, ylim=c(0,0.15), cex.axis=1,  smooth=TRUE,lwd = 1.5, add = TRUE)

plotRateThroughTime(ed, ratetype = "netdiv", intervals = seq(from = 0, 0.95, by = 0.01), intervalCol="orange", 
                    avgCol="orange", start.time=st, node=221, ylim=c(0,0.15), cex.axis=1,  smooth=TRUE,lwd = 1.5, add = TRUE)



legend('topleft', legend = c('liverwort', 'moss', 'hornwort'), col = c('red', 'orange', 'blue'),
       border = FALSE, lty = 5, lwd = 2, merge = FALSE, seg.len=0.6)

