# Reproducible Research: Peer Assessment 1


## Loading and preprocessing the data
>Show any code that is needed to
 1. Load the data (i.e. read.csv())
 2. Process/transform the data (if necessary) into a format suitable for your analysis


```r
sn <- read.csv("activity.csv", header = T, na.strings = "NA")
sn$date <- as.Date(sn$date, "%Y-%m-%d")
```

## What is mean total number of steps taken per day?
>For this part of the assignment, you can ignore the missing values in the dataset.
 1. Make a histogram of the total number of steps taken each day
 2. Calculate and report the mean and median total number of steps taken per day

The goal of this section is to generate the overall mean (average) of the total number of steps taken per day.
There are a few steps taken to reach this goal.

1. A dataset containing the total number of steps taken each day is created.

  
  ```r
  steps <- tapply(sn$steps,sn$date,sum, na.rm = T)
  ```

2. A histogram of the above data is created as a form of visual representation.

  
  ```r
  hist(steps,60) 
  ```
  
  ![plot of chunk unnamed-chunk-3](figure/unnamed-chunk-3-1.png) 

3. Calculate the mean and median values (ignoring NA values) using the above dataset.

  1. Mean
      
      ```r
      mean(steps)
      ```
      
      ```
      ## [1] 9354.23
      ```
  2. Median
      
      ```r
      median(steps)
      ```
      
      ```
      ## [1] 10395
      ```

## What is the average daily activity pattern?
>What is the average daily activity pattern?
 1. Make a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all days (y-axis)
 2. Which 5-minute interval, on average across all the days in the dataset, contains the maximum number of steps?

This goal of this section is to find the mean (average) steps taken for eatch 5-minute time interval averaged over all the days in the data.
Similar to the previous section, the steps taken to reach the above goal are as follows:

1. Generate the mean (average) number of steps taken (ignoring NA values) for each 5-minute interval, itself averaged across all days.
  
  
  ```r
  stepsint <- tapply(sn$steps,sn$interval,mean, na.rm = T)
  ```
  
2. A Time-Series plot is created from the above dataset

  
  ```r
  plot(names(stepsint), stepsint, type <- "l", main = "Average daily activity")
  ```
  
  ![plot of chunk unnamed-chunk-7](figure/unnamed-chunk-7-1.png) 
  
3. Finding the 5-minute interval with the maximum number of steps

  
  ```r
  stepsint[stepsint == max(stepsint)]
  ```
  
  ```
  ##      835 
  ## 206.1698
  ```

## Imputing missing values
>Note that there are a number of days/intervals where there are missing values (coded as NA). The presence of missing days may introduce bias into some calculations or summaries of the data.
 1. Calculate and report the total number of missing values in the dataset (i.e. the total number of rows with NAs)
 2. Devise a strategy for filling in all of the missing values in the dataset. The strategy does not need to be sophisticated. For example, you could use the mean/median for that day, or the mean for that 5-minute interval, etc.
 3. Create a new dataset that is equal to the original dataset but with the missing data filled in.
 4. Make a histogram of the total number of steps taken each day and Calculate and report the mean and median total number of steps taken per day. Do these values differ from the estimates from the first part of the assignment? What is the impact of imputing missing data on the estimates of the total daily number of steps?

The goal of this section is to generate a new graph using the same data as from the first section but with its NA values replaced.

To achieve this goal the mean (average) 5-minunte interval values as from the previous section will be used to replace the NA values.

1. Total number of rows with NA values in original data.

  
  ```r
  sum(is.na(sn$steps))
  ```
  
  ```
  ## [1] 2304
  ```

2. The average 5-minute interval values from the prevous section is used to replace the NA values of the original data and a new dataset will be generated from the latter.

 Decimal values will be rounded up to a whole number.
 
  
  ```r
  nsn <- sn 
  for (i in 1:nrow(nsn)) {
    if (is.na(nsn$steps[i])) {
      nsn$steps[i] <- as.numeric(stepsint[sn$interval[i] == names(stepsint)])
    }
  }
  ```

3. The total number of steps taken each day is generated using this new dataset.

  
  ```r
  stepsn <- tapply(nsn$steps,nsn$date,sum)
  ```

4. A histogram of the above data is created as a form of visual representation.

  
  ```r
  hist(stepsn,60)
  ```
  
  ![plot of chunk unnamed-chunk-12](figure/unnamed-chunk-12-1.png) 

5. Calculate the mean and median values of this new dataset (NA values replaced with mean).

  1. Mean
      
      ```r
      mean(stepsn)
      ```
      
      ```
      ## [1] 10766.19
      ```
  2. Median
      
      ```r
      median(stepsn)
      ```
      
      ```
      ## [1] 10766.19
      ```
      
6. It seems that adding the missing values to the original data has caused both the mean and median values to increase.

  1. Mean:
  
      9354 to 10766
  2. Median:
  
      10395 to 10766


## Are there differences in activity patterns between weekdays and weekends?
>For this part the weekdays() function may be of some help here. Use the dataset with the filled-in missing values for this part.
 1. Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.
 2. Make a panel plot containing a time series plot (i.e. type = "l") of the 5-minute interval (x-axis) and the average number of steps taken, averaged across all weekday days or weekend days (y-axis). The plot should look something like the following, which was creating using simulated data:

1.  Create a new factor variable in the dataset with two levels - "weekday" and "weekend" indicating whether a given date is a weekday or weekend day.

  
  ```r
  nsn$weeks <- as.factor(ifelse(weekdays(nsn$date) %in% c("Saturday", "Sunday"), "weekday", "weekend"))
  ```
  
2. The data is then separated into weekday or weekend and the mean (average) number of steps taken for each 5-minute interval, itself averaged across all weekday days or weekend days is calculated.

  
  ```r
  stepswe <- tapply(nsn$steps[nsn$weeks == "weekend"],nsn$interval[nsn$weeks == "weekend"],mean)
  stepswd <- tapply(nsn$steps[nsn$weeks == "weekday"],nsn$interval[nsn$weeks == "weekday"],mean)
  ```

3. Finally, a panel plot of both weekend and weekday graphs is generated.

  
  ```r
    par(mfrow = c(1,2))
    plot(names(stepswe), stepswe, type <- "l", main = "Average daily activity in Weekends", ylab = "Number of steps"    ,xlab = "Interval", ylim = c(0,200))
    plot(names(stepswd), stepswd, type <- "l", main = "Average daily activity in Weekdays", ylab = "Number of steps",xlab = "Interval", ylim = c(0,200))
  ```
  
  ![plot of chunk unnamed-chunk-17](figure/unnamed-chunk-17-1.png) 
  
  ```r
    par(mfrow = c(1,1))
  ```
