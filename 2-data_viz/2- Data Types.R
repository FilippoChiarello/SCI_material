
##### Data classes ####

# 4 basic classes

# logical (e.g., TRUE, FALSE) (See beter at the end)

logical <- FALSE

logical_1 <- F


#integer (e.g, as.integer(3))

x <- 1

#numeric (real or decimal) (e.g, 2, 2.0, pi)

y <- 1.2

#character (e.g, "a", "Ingegneria_Gestionale")

a <- "apple"


#### Vectors ####

# We can create a vector consisting of multiple numeric values

v1 <- c(1, 5.5, 1e2)

v2 <- c(0.14, 0, -2)

# This function can also be used to combine two vectors, such as v1 and v2, into a variable v3

v3 <-  c(v1, v2)

# Subsetting a vector

v3[2]

v3[2:5]

v3_sub <- v3[4:6]

# Functions on vectors 

v1 + 2
sin(v1)

sin(v1[2])

v1 * v2

v1 %*% v2

# Dot products requires that two vectors must have a same length

v1 %*% v3


# Check the length of a vector

length(v1)

length(v3)



# summary provides an easy way to get the feel of data
summary(v3)

mean(v3)
quantile(v3,1)

median(v3)
sd(v3)
max(v3)
min(v3)

sum(v3)



#### Lists ####

# In R, a list is a vector containing other objects which may be of different data types

l1 <- list("apple",1 ,1.3, c(1:10))


# We could also assign names to objects within a list

l1 <- list(fruit= "apple",first_integer=1 ,this_is_numeric= 1.3,this_is_vector = c(1:10))

# We can slice a list by its index

l1[3]

# If you would like to extract the content, you need to use two sets of square brackets


l1[[3]]

l1[[4]]


# The content of a member in a list can be accessed by its name. 

names(l1)


# And can use a dollar sign ($) to extract one member of the list


l1$this_is_vector


##### Data Frames #####

# Data frames are lists with a set of restrictions. 
# Most precisely, a data frame is a list of vectors which are conveniently arranged as columns. 
# All vectors or columns in a data frame must have the same length. 
# Remember the concept of Tidy data...


# R comes with built-in datasets that can be retrieved by name, using data function. 

data(mtcars)

View(mtcars)



class(mtcars)

colnames(mtcars)

dim(mtcars)

summary(mtcars)

# You can see a help file about mtcars with ?mtcars

?mtcars

?summary

# Help works also with functions...

?dim

# Look inside a df

head(mtcars)
head(mtcars,2)

tail(mtcars)
tail(mtcars,2)

# Split the df. In general mtcars[row_dim, col_dim]

mtcars[1, 1]

mtcars[1,]
mtcars[,1]

mtcars[1:2,]
mtcars[,1:2]

# You can retrieve a specific column by name. 

mtcars$mpg

mtcars[,"mpg"]


##### Logical Vectors and Operators ######

boolean_true <- TRUE

boolean_false <- FALSE

#Using the function c, we can make a vector of logical values. 
#Note that TRUE and FALSE are not wrapped by quotation marks.

y <- c(TRUE, FALSE, TRUE)

y


# Boolean are useful for subsetting dataframes

mtcars$mpg > 20


#This logical vector can be used to subset rows of the data frame. 
#TRUE means "keep the row", FALSE means drop it. 

mtcars[!(mtcars$mpg > 20), ]


# Boolean operators works like you know

TRUE && TRUE

TRUE && FALSE

TRUE || FALSE

FALSE || TRUE

!TRUE

!FALSE



# Ex mtcars

#1- What's the mean of consumption of the data set?

#2- What's the standard deviation of the weight?

#3- What's the median of the weight? 

#4- What can we say about the distribution of wt?

#5- Count the total number of carburetors in all the cars

#6- How many cars has an automatic transimission?

#7- How may cars has 8 cylinders?

#8-  Is the mean of consumption for cars having a manual transimission greater than he mean of consumption for cars having an automatic transimission?

#9- Create your own questions [2]

#10- Answer to a questions make by a colleague [2]

