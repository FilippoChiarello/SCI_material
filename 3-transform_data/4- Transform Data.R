library(nycflights13)
library(tidyverse)

# It is rare that you get the data in exactly the right form you need. 

#Often you’ll need to:create some new variables, summaries, rename the variables or reorder the observations in order to make the data a little easier to work with. 

#Focus on how to use the dplyr package, another core member of the tidyverse.

# The dataset nycflights13::flights. This data frame contains all 336,776 flights that departed from New York City in 2013. 

#The data comes from the US Bureau of Transportation Statistics, and is documented in ?flights

flights <- nycflights13::flights

View(flights)

#Abbreviations under the column names describes the type of each variable

#### Filter #####

#filter() allows you to subset observations based on their values. The first argument is the name of the data frame. The second and subsequent arguments are the expressions that filter the data frame. 

flights %>% 
  filter( month == 1, day == 1)


# dplyr functions never modify their inputs, so if you want to save the result, you’ll need to use the assignment operator, <-:

jan1 <- filter(flights, month == 1, day == 1)

jan1

View(jan1)

jan1 %>% 
  View()

# The easiest mistake to make is to use = instead of == when testing for equality.

filter(flights, month = 1)


# The following code finds all flights that departed in November or December:

filter(flights, month == 11 | month == 12) %>% 
  View("test1")

# This is wrong, cause it finds it finds all months that equal 11 | 12.

filter(flights, month == 11 | 12) 




# A solution is to think that as "find all months inside a vector"

filter(flights, month %in% c(1,2,3,7,11,12)) %>% 
  View()

#Missing values are “contagious”

NA > 5

10 == NA

NA + 10

NA == NA


#It’s easiest to understand why this is true with a bit more context:
  
# Let x be Mary's age. We don't know how old she is.

x <- NA

# Let y be John's age. We don't know how old he is.
y <- NA

# Are John and Mary the same age?

x == y

# We don't know!

#If you want to determine if a value is missing, use 

is.na(NA)

is.na(1)

is.na("apple")


# filter() only includes rows where the condition is TRUE; it excludes both FALSE and NA values. If you want to preserve missing values, ask for them explicitly

df <- tibble(x = c(1, NA, 3))

View(df)

filter(df, x > 1)

filter(df, !is.na(x))


df <- tibble(x = c(1, 2, 3), y = c(4, 5, 6))
df_sum <- mutate(df,tot= x+y)
View(df_sum)


tibble(x = c(1, 2, 3), y = c(4, 5, 6)) %>% 
  mutate(tot= x+y) %>% 
  View()
  
  

#### Arrange ######

arrange(flights, arr_delay) %>% 
  View()

arrange(flights, desc(arr_delay)) %>% 
  View()


### Select #####


flights %>% 
  select(year, month, day) %>% 
  View()

View(new_variable)



select(flights, year:day)


flights %>% 
  select(-year) %>% 
  View()


### Mutate #######

# mutate() always adds new columns at the end of your dataset 

#Let's create a narrower dataset so we can see the new variables.

flights_sml <- select(flights, year:day, ends_with("delay"), distance, air_time)



#Remember that when you’re in RStudio, the easiest way to see all the columns is View().

flights_sml %>% 
View()

mutate(flights_sml, gain = arr_delay - dep_delay, speed = distance / air_time * 60) %>% 
  View()

# Note that you can refer to columns that you’ve just created

mutate(flights_sml,gain = arr_delay - dep_delay, hours = air_time / 60, gain_per_hour = gain / hours) %>% 
  View()

### Summarise & group_by ######

# summarise() collapses a data frame to a single row. na.rm stends for NA removing. In this way NA's are not taken in to consideration for the computation. 

summarise(flights, delay = mean(dep_delay, na.rm = TRUE))

# summarise() is not terribly useful unless we pair it with group_by(). 

# This changes the unit of analysis from the complete dataset to individual groups.

# Then, when you use the dplyr verbs on a grouped data frame they’ll be automatically applied “by group”.

by_day <- group_by(flights, year, month)

summarise(by_day, delay = mean(dep_delay, na.rm = TRUE)) %>% 
  View()

### Pipe ####

# Want to explore the relationship between the distance and average delay for each destination

#There are three steps to prepare this data:

# 1 grup_by destination
by_dest <- group_by(flights, dest)

# 2 for each destination, count the number of flights arriving there, the mean distance of these flights and the mean delay

delay <- summarise(by_dest, count = n() , dist = mean(distance, na.rm = TRUE) ,delay = mean(arr_delay, na.rm = TRUE))

# 3 Chose the main destination, only the ones where arrives more than 20 flights. Honolulu is very far...

delay <- filter(delay, count > 20, dest != "HNL")

# Then visualise the data

ggplot(data = delay, mapping = aes(x = dist, y = delay)) +
  geom_point(aes(size = count), alpha = 1/3) +
  geom_smooth(se = FALSE)



# This code is a little frustrating to write because we have to give each intermediate data frame a name, even though we don’t care about it.

# There’s another way to tackle the same problem with the pipe, %>%


delays <- flights %>%  
  group_by(dest) %>% 
  summarise(count = n(),dist = mean(distance, na.rm = TRUE),delay = mean(arr_delay, na.rm = TRUE)) %>% 
  filter(count > 20, dest != "HNL")


#### NA problems ######

# What happens if we don't use na.rm?


flights %>% 
  group_by(year, month, day) %>% 
  summarise(mean = mean(dep_delay))

# That’s because aggregation functions obey the usual rule of missing values: if there’s any missing value in the input, the output will be a missing value.

# Fortunately, all aggregation functions have an na.rm argument which removes the missing values prior to computation.

# Where missing values represent cancelled flights, we could also tackle the problem by first removing the cancelled flights. We’ll save this dataset so we can reuse in the next few examples.

not_cancelled <- flights %>% 
  filter(!is.na(dep_delay), !is.na(arr_delay))


#### n() #####

# n() counts the number of row of your tibble. If group_by is on, it counts the number os elements per groups. It helps you  check that you’re not drawing conclusions based on very small amounts observation. 

# Let’s look at the planes (identified by their tail number) that have the highest average delays. Draw a scatterplot of number of flights vs. average delay

#compute the mean delay for each plane
delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(delay = mean(arr_delay))

View(delays)

ggplot(data = delays, mapping = aes(x = delay)) + 
  geom_histogram(binwidth = 10)



# Add the count information. We can get more insight if we draw a scatterplot of number of flights vs. average delay

delays <- not_cancelled %>% 
  group_by(tailnum) %>% 
  summarise(delay = mean(arr_delay, na.rm = TRUE),n = n())

View(delays)

ggplot(data = delays, mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)

# There is much greater variation in the average delay when there are few flights. 

# The shape of this plot is very characteristic: whenever you plot a mean (or other summary) vs. group size, you’ll see that the variation decreases as the sample size increases.

# Filter out the groups with the smallest numbers of observations, so you can see more of the pattern

# Let's also integrate ggplot2 into dplyr flows.

delays %>% 
  filter(n > 20) %>% 
  ggplot(mapping = aes(x = n, y = delay)) + 
  geom_point(alpha = 1/10)


##### Useful summary functions ####

# It’s sometimes useful to combine aggregation with logical subsetting. 

not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(avg_delay1 = mean(arr_delay),
            avg_delay2 = mean(arr_delay[arr_delay > 0]),
            avg_delay3 = mean(arr_delay[arr_delay < 0])
           ) %>% 
  View()

# Measures of spread. 
# Why is distance to some destinations more variable than to others?

not_cancelled %>% 
  group_by(dest) %>% 
  summarise(distance_sd = sd(distance)) %>% 
  arrange(desc(distance_sd)) %>% 
  View()

# Measures of rank

# When do the first and last flights leave each day?


not_cancelled %>% 
  group_by(year, month, day) %>% 
  summarise(
    first = min(dep_time),
    last = max(dep_time)
  ) %>% 
  View()


# Weighted counts:

# “count” (sum) the total number of miles a plane flew

not_cancelled %>% 
  count(tailnum, wt = distance)

####  Grouped mutates (and filters)#####

# Grouping is also convenient  with:

# Filter on the most popular destinations

popular_dests <- flights %>% 
  group_by(dest) %>% 
  filter(n() > 500)

View(popular_dests)

# Mutate. Count the number of planes for each destination and add as a variable

count_dests <- flights %>% 
  group_by(dest) %>% 
  mutate(tot_planes = n())
View(count_dests)



# 1: Find all flights that had an arrival delay of two or more hours
# 2: Find all flights that flew to Houston (IAH or HOU)
# 3.Find all flights that departed between midnight and 6am (inclusive)
# 4: Compare air_time with arr_time - dep_time. What do you expect to see?
# 5: Find the 10 most delayed flights
# 6: Look at the number of cancelled flights per day. Is there a pattern? 
# 7: Is the proportion of cancelled flights related to the average delay?
# 8: What time of day should you fly if you want to avoid delays as much as possible?
# 9: Create your own questions [2]
# 10: Answer to a questions make by a colleague [2]






