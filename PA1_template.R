par(mfrow = c(1,1))

sn <- read.csv("activity.csv", header = T, na.strings = "NA")
sn$date <- as.Date(sn$date, "%Y-%m-%d")
# NoNA = sn[!is.na(sn$steps),] # na.omit(sn)

steps <- tapply(sn$steps,sn$date,sum, na.rm = T)

hist(steps,60) #qplot(steps, title = "Frequency of Daily Steps taken in 2 Month") # qplot(steps, fill = weekdays(as.Date(names(steps))))

mean(steps)
median(steps)

stepsint <- tapply(sn$steps,sn$interval,mean, na.rm = T)
plot(names(stepsint), stepsint, type <- "l", main = "Average daily activity")

stepsint[stepsint == max(stepsint)]

sum(is.na(sn$steps))

# My strategy is to use the mean for that 5-minute interval to fill each NA value in the steps column.

nsn <- sn 
for (i in 1:nrow(nsn)) {
  if (is.na(nsn$steps[i])) {
    nsn$steps[i] <- as.numeric(stepsint[sn$interval[i] == names(stepsint)])
  }
}

stepsn <- tapply(nsn$steps,nsn$date,sum)
hist(stepsn,60)

mean(stepsn)
median(stepsn)

nsn$weeks <- as.factor(ifelse(weekdays(nsn$date) %in% c("Saturday", "Sunday"), "weekday", "weekend"))

stepswe <- tapply(nsn$steps[nsn$weeks == "weekend"],nsn$interval[nsn$weeks == "weekend"],mean)
stepswd <- tapply(nsn$steps[nsn$weeks == "weekday"],nsn$interval[nsn$weeks == "weekday"],mean)

par(mfrow = c(1,2))
plot(names(stepswe), stepswe, type <- "l", main = "Average daily activity in Weekends", ylab = "Number of steps",xlab = "Interval", ylim = c(0,200))
plot(names(stepswd), stepswd, type <- "l", main = "Average daily activity in Weekdays", ylab = "Number of steps",xlab = "Interval", ylim = c(0,200))
par(mfrow = c(1,1))

