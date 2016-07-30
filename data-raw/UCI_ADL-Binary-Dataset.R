# University of California Irvine 
# Activities of Daily Living (ADLs) Recognition Using Binary Sensors Data Set

## Conversion to raw binary data

#### Read in Lines
data1 = readLines("data-raw/UCI_ADL-Binary-Dataset/OrdonezA_ADLs.txt")

#### Extract variable names and data rows
header = data1[1]
body = data1[3:length(data1)]

#### Split lines and format
header = trimws(unlist(strsplit(header, "\t")))
body =  matrix(trimws(unlist(strsplit(body, "\t\t"))), ncol = length(header), byrow = T)

#### Define data types, name variables, and structure data
start = as.POSIXct(body[, 1])
end = as.POSIXct(body[, 2])
behavior = body[, 3]
tab = data.frame(start, end, behavior)

#### Calculate Active Behavior Chunks
tab$diff = tab$end - tab$start         # Calculate time difference
tab = tab[tab[, "diff"] > 0, ]         # Remove negative timers


### DATA Documentation

#> max(tab[, "diff"])
# Time difference of 36825 secs

# > min(tab[, "diff"])
# Time difference of 2 secs

# > max(tab[, 'end']) - min(tab[, "start"])
# Time difference of 13.80126 days

###


# Split behaviors
splt = split(tab, tab[, "behavior"])

# Calculate Inactive Behavior Chunks
x = vector(length = nrow(splt[["Toileting"]]) - 1)
x[1] = 0

for (i in 1:length(x)){
  x[i + 1] = difftime(splt[["Toileting"]][i + 1, "start"], splt[["Toileting"]][i, "end"], units = "sec")
}

y = splt[["Toileting"]][, "diff"]

x2 = lapply(lapply(x, function(a) rep(0, a)), unlist)
y2 = lapply(lapply(y, function(a) rep(1, a)), unlist)

z = c(rbind(y2, x2))



get_binary = function(data1, name, tab) {
  
  data1 = vector(length = nrow(data1[[name]]) - 1)
  data1[1] = 0
  
  for (i in 1:length(data1)){
    data1[i + 1] = difftime(splt[[name]][i + 1, "start"], splt[[name]][i, "end"], units = "sec")
  }
  
  data2 = splt[[name]][, "diff"]
  
  data1 = lapply(lapply(data1, function(a) rep(0, a)), c)
  data2 = lapply(lapply(data2, function(a) rep(1, a)), c)
  
  data3 = unlist(c(rbind(data1, data2)))
  print(str(data3))
  intro = as.numeric(difftime(min(splt[[name]][, "start"]), min(tab[, "start"]), units = "sec"))
  print(str(intro))
  outro = as.numeric(difftime(max(tab[, "end"]), max(splt[[name]][, "end"]), units = "sec"))
  print(str(outro))
  intro = rep(0, intro)
  print(str(intro))
  outro = rep(0, outro)
  print(str(outro))

  data3 = c(intro, data3, outro)
  return(data3)
}

# Almost
Breakfast = unlist(get_binary(splt, "Breakfast", tab = tab))
Grooming = unlist(get_binary(splt, "Grooming", tab = tab))
Leaving = unlist(get_binary(splt, "Leaving", tab = tab))
Lunch = unlist(get_binary(splt, "Lunch", tab = tab))
Showering = unlist(get_binary(splt, "Showering", tab = tab))
Sleeping = unlist(get_binary(splt, "Sleeping", tab = tab))
Snack = unlist(get_binary(splt, "Snack", tab = tab))
SpareTimeTV = unlist(get_binary(splt, "Spare_Time/TV", tab = tab))
Toileting = unlist(get_binary(splt, "Toileting", tab = tab))

# x = list()
# for (i in behavior){
#   x[i] = unlist(get_binary(splt, i, tab = tab))
# }


new = cbind(Breakfast, Grooming, Leaving, Lunch, 
            Showering, Sleeping, Snack, SpareTimeTV, Toileting)

### Gotcha
p = plot_freqprof(freqprof(new[199500:204000, ]), gg = T)


p = plot_freqprof(freqprof(new[200000:203750, ]), gg = T)


diff <- make_difftime(secs = 199500) #difftime
as.interval(diff, min(tab$start))


# Check em
length(new42)
difftime(max(tab[, "end"]), min(tab$start), units = "sec")
