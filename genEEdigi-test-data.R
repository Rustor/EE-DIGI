        x=seq(0,2^12*pi,pi/10)
        x= x[1:4000]
        timecol= seq(as.POSIXct("2000/1/1"), as.POSIXct("2004/12/12"), "hours")
        date= timecol[1:4000]
        z=0.0001*x*sin(x)
        y=sin(x)
        r=runif(4000, 0, 10)
for (i  in 1:10) {
        str=paste("id00", i, sep="")
        v=r+r*y*1.25/(i %% 11)
        # cor(y,v) over 0,75 is significant
        id =rep( str, 4000)
        mydf = data.frame(date,id,x,y,z,v,x,y,z) # the last x y z not used right now
        write.table(mydf, file=paste( "TESTdata", str, ".csv", sep=""), sep=";", row.names = F, col.names = TRUE) }

