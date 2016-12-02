#!/usr/bin/env Rscript
# Requires rmr2 package (https://github.com/RevolutionAnalytics/RHadoop/wiki).
library(rmr2)
library(plyr)
# Set "LOCAL" variable to T to execute using rmr's local backend.
# Otherwise, use Hadoop (which needs to be running, correctly configured, etc.)
LOCAL=F
if (LOCAL)
{
        rmr.options(backend = 'local')
        # we have smaller extracts of the data in this project's 'local' subdirectory
        hdfs.data.root = 'data/local/eedigi'
        hdfs.data = file.path(hdfs.data.root, 'data', 'test.csv')
        hdfs.out.root = hdfs.data.root
} else {
        rmr.options(backend = 'hadoop')
        hdfs.data.root = '/rhadoop/eedigi'
        hdfs.data = file.path(hdfs.data.root, 'xdata')
        hdfs.out.root = '/rhadoop/eedigi'
        system("/home/ubuntu/hadoop/bin/hadoop fs -rmr /rhadoop/eedigi/out")
}
hdfs.out = file.path(hdfs.out.root, 'out')

# asa.csv.input.format() - read CSV data files and label field names
# for better code readability (especially in the mapper)
my.input.format = make.input.format(format='csv', mode='text', streaming.format = NULL, sep=';',
                                                                                 col.names = c('Year', 'id', 't1', 't2', 't3', 't4', 't5',  't6', 't7'),
                                                                                 stringsAsFactors=F)
# the mapper gets keys and values from the input formatter
# in our case, the key is NULL and the value is a data.frame from read.table()
mapper = function(key, val.df) {
        val.df = subset(val.df, id != 'id'  ) # remove name line !!! can be problematic
        output.key = data.frame(id=val.df$id,  stringsAsFactors=F) # conv to data.frame decide on col names avail in reducer
        # if value is a data frame then key should also be a data frame
        output.val = val.df[,c('t1', 't2', 't3', 't4')] # transmit temperature data
        return( keyval(output.key, output.val) )
}
# the reducer gets all the values for a given key
# df is processed as lines not as a whole df
reducer = function(key, val.df) {
        output.key = key
        output.val = c( cor( as.numeric(val.df$t2 ), as.numeric(val.df$t4 ) ) , cor( as.numeric(val.df$t1 ), as.numeric(val.df$t2 ) ) )
        return( keyval(output.key, output.val) )
}
mr = function (input, output) {
        mapreduce(input = input,
                          output = output,
                          input.format = my.input.format,
                          map = mapper,
                          reduce = reducer,
                          backend.parameters = list(
                                hadoop = list(D = "mapreduce.map.java.opts=-Xmx200M", D = "mapreduce.job.reduces=2")
                                ),
                          verbose=T)
}
out = mr(hdfs.data, hdfs.out)
results = from.dfs( out )
results.df = as.data.frame(results, stringsAsFactors=F )
#print(head(results.df))
print( results.df[which(results.df$val> 0.75),]) # only print out significant ( over 0.75) results. 

