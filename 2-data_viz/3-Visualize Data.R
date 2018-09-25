#You only need to install a package once, but you need to reload it every time you start a new session.

install.packages("tidyverse")

library(tidyverse)

##### Dataset ######

# Let's work on the mpg dataframe(or tibble...)

mpg

mpg <- mpg

# The course is based on questions. Here is the 1st :)

# What does the relationship between engine size and fuel efficiency look like? Let's make some hypothesis

# To learn more about mpg, open its help page by running ?mpg.

# Put displ on the x-axis and hwy on the y-axis

ggplot(data = mpg)

ggplot(data = mpg, mapping = aes(x= displ, y= hwy))

ggplot(data = mpg, mapping = aes(x= displ, y= hwy)) +
  geom_point()

# Or more in general...

ggplot(data = mpg) +
  geom_point( mapping = aes(x= displ, y= hwy))

# ggplot(data = <DATA>) + 
#   <GEOM_FUNCTION>(mapping = aes(<MAPPINGS>))

# Make a scatterplot of hwy vs cyl

ggplot(data = mpg) +
  geom_point( mapping = aes(x= class, y= drv))

# What happens if you make a scatterplot of class vs drv? Why is the plot not useful?

# Outliers...

##### Aesthetic Mapping ######

# Try to map another variable that can explain the behaviour of the outliers

ggplot(data = mpg) +
  geom_point( mapping = aes(x= displ, y= hwy, colour= class))

# Let's map class on the size or alpha (transparency) or shape. Why the warning?

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, size = class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, alpha = class))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = class))

# Once you map an aesthetic, ggplot2 takes care of the rest. 
# It selects a reasonable scale to use with the aesthetic
# It constructs a legend that explains the mapping between levels and values. 

# You can also set the aesthetic properties of your geom manually

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), color = "green")


# Pay attention to where you put the specification.

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy, color = "????"))

# Which variables in mpg are categorical? Which variables are continuous?


##### Facets ######

# One way to add additional variables is with aesthetics. 
# Another way, particularly useful for categorical variables, is to split your plot into facets

# To facet your plot by a single variable, use facet_wrap()

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))+
  facet_wrap(~ class, nrow = 2)

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  facet_wrap(~ class, ncol = 1)

# To facet your plot on the combination of two variables use facet_grid()

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) + 
  facet_grid(drv ~ cyl)

##### Geometric Object ######

# point
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))

# smooth line
ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy))+
  geom_smooth(mapping = aes(x = displ, y = hwy))


# Every geom function in ggplot2 takes a mapping argument. 
# However, not every aesthetic works with every geom. 
# You could set the shape of a point, but you couldn’t set the “shape” of a line. 
# On the other hand, you could set the linetype of a line

ggplot(data = mpg) + 
  geom_smooth(mapping = aes(x = displ, y = hwy, linetype = drv))

#To display multiple geoms in the same plot, add multiple geom functions to ggplot()


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy)) +
  geom_smooth(mapping = aes(x = displ, y = hwy))


# This, however, introduces some duplication in our code. 
# Imagine if you wanted to change the y-axis to display cty instead of hwy...
# You can avoid this. Set the aes in ggplot call, as we seen before.

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth()

# If you place mappings in a geom call ggplot2 will treat them as local mappings for the specific layer. 
# This makes it possible to display different aesthetics in different layers.

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point(mapping = aes(color = class)) + 
  geom_smooth()

# VS

ggplot(data = mpg, mapping = aes(x = displ, y = hwy)) + 
  geom_point() + 
  geom_smooth(mapping = aes(color = class))


# Other geoms.

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = hwy)) + 
  geom_histogram()


##### Statistical transformations ######

# Work with different data

diamonds <- diamonds

# Try the bar geom

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))



# What's the difference between bar-chart and a histogram? Bin vs count

# Histogram with categorical variable

ggplot(data = diamonds) + 
  geom_histogram(mapping = aes(x = cut))

# Let's try

ggplot(data = diamonds) + 
  geom_histogram(mapping = aes(x = cut), stat = "count")

# Histogram with continuos variable

ggplot(data = diamonds) + 
  geom_histogram(mapping = aes(x = carat))

# Bar with categorical variable

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut))

# Bar with continuos variable

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = carat))


###### Position adjustments ######

# Colour a bar chart using fill

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut))

# map the fill aesthetic to clarity

ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = clarity))

# Notice that the bars are automatically stacked (impilate). 
# Each colored rectangle represents a combination of cut and clarity
# The stacking is performed automatically by the position adjustment specified by the position argument


ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar(position = "stack")

# Try other positions

# fill. works like stacking, but makes each set of stacked bars the same height. 
# This makes it easier to compare proportions across groups

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar(position = "fill")

# dodge. places objects directly beside one another. 
# This makes it easier to compare individual values.

ggplot(data = diamonds, mapping = aes(x = cut, fill = clarity)) + 
  geom_bar( position = "dodge")



# Positioning is useful not only for bars.

# Recall our first scatterplot

ggplot(data = mpg, mapping = aes(x= displ, y= hwy)) +
  geom_point()

# The values of hwy and displ are rounded so the points appear on a grid. Many points overlap.
# This problem is known as overplotting, makes it hard to see where the mass of the data is. 
# You can avoid this gridding by setting the position adjustment to “jitter”
# Jitter adds a small amount of random noise to each point
# This spreads the points out because no two points are likely to receive the same amount of random noise.

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = displ, y = hwy), position = "jitter")

# It's quite famous...

ggplot(data = mpg) + 
  geom_jitter(mapping = aes(x = displ, y = hwy))



###### Coordinate systems ######

# Coordinate systems are probably the most complicated part of ggplot2. 
# The default coordinate system is the Cartesian coordinate
# There are a number of other coordinate systems that are occasionally helpful.

# coord_flip() switches the x and y axes. useful for long labels

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot()

ggplot(data = mpg, mapping = aes(x = class, y = hwy)) + 
  geom_boxplot() +
  coord_flip()


# coord_quickmap() sets the aspect ratio correctly for maps

nz <- map_data("italy")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black")

ggplot(nz, aes(long, lat, group = group)) +
  geom_polygon(fill = "white", colour = "black") +
  coord_quickmap()

# coord_polar() uses polar coordinates. 
# Polar coordinates reveal an interesting connection between a bar chart and a pie chart.

# Notice the use of bar as a variable 

bar <- ggplot(data = diamonds) + 
  geom_bar(mapping = aes(x = cut, fill = cut), show.legend = FALSE,
    width = 1
  ) + 
  theme(aspect.ratio = 1) +
  labs(x = NULL, y = NULL)

class(bar)

bar + coord_flip()

bar + coord_polar()

####### Summary ######

# ggplot(data = <DATA>) + 
#  <GEOM_FUNCTION>(
#    mapping = aes(<MAPPINGS>),
#    stat = <STAT>, 
#    position = <POSITION>
#  ) +
#  <COORDINATE_FUNCTION> +
#  <FACET_FUNCTION>

# Then we can also add specification for <SCALES> and <ANNOTATIONS>

# Ex mpg

1# Is there any correlation between cty, hwy and displ?
2# What's the effect of fuel type and car type on the efficency?
3# Has the efficency changed over time?
4# Whats the number of model per manufacturer?
5# To which manufacturer you would look at for a car to use in the city?
6# Wich fuel type is more efficient in the highway?
7# Whats the distribution for the two year of manufacturers for the engine displacements?
8# Whats the number of classes per manufacturer per year?
9# Create your own questions [2]
10# Answer to a questions make by a colleague [2]


ggplot(data = mpg) + 
  geom_jitter(mapping = aes(x = year, y = hwy))















ggplot(data = mpg) + 
  geom_jitter(mapping = aes(x = cty, y = hwy, color= displ))

ggplot(data = mpg) + 
  geom_jitter(mapping = aes(x = fl, y = class, size= hwy))


ggplot(data = mpg) + 
  geom_point(mapping = aes(x = year, y = hwy))

ggplot(data = mpg) + 
  geom_bar(mapping = aes(x = manufacturer)) 

ggplot(data = mpg) + 
  geom_boxplot(mapping = aes(x =manufacturer, y = cty/hwy))

ggplot(data = mpg) + 
  geom_point(mapping = aes(x = fl, y = hwy))

ggplot(data = mpg) + 
  geom_histogram(mapping = aes(x = displ),bins=10) + 
  facet_wrap(~year, nrow=2)

ggplot(data = mpg) + 
  geom_bar(mapping = aes(x = class)) +
  facet_grid(manufacturer ~year)

