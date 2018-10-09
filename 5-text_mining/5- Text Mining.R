# This is not a good thing to do in your workflow!!! But it is s lean data format, to be shure that everyone can do the exercise. 

load("data/Ex_text_mining.RData")


# import libraries --------------------------------------------------------

library(tidyverse)
library(tidytext)

#Make regex human
library(rebus)

#Text Processing
library(udpipe)

# Generic plot scaling methods
library(scales)

# Dinamic plots
library(plotly)


#### Read files #####

# read_csv() reads comma delimited files 

# read_csv2() reads semicolon separated files

# read_tsv() reads tab delimited files

# read_delim() reads in files with any delimiter.

papers_block_chain <- read_csv("data/block_chain_scopus.csv")

###### Tibbles vs. data.frame #####

# read_csv loads a tibble

papers_block_chain

# Pay attention when you print data frame. if you print papers_block_chain_df it freezes. 

papers_block_chain_df <- as.data.frame(papers_block_chain)

str(papers_block_chain_df)

head(papers_block_chain_df,2)


# a quick recap -----------------------------------------------------------


# Subsetting a tibble with pipe

# select column named Title

papers_block_chain_df %>% 
  .$Title

# select the first column
papers_block_chain_df %>% 
  .[,1]

# select the first row
papers_block_chain_df %>% 
  .[1,]

#### Write files #####

# Create a modified version of the tibble
papers_block_chain_df_modified <- papers_block_chain_df %>% 
  select(1:5) %>% 
  filter(Year ==2017)

write_csv(papers_block_chain_df_modified, "data/papers_block_chain_df_modified.csv")

# excell readble

write_delim(papers_block_chain_df_modified, "data/papers_block_chain_df_modified_excell.csv", delim=";")

##### The tidy approach to preprocessing. The unnest_tokens function #####

text_tbl <- papers_block_chain_df %>% 
  select(Title,Abstract) %>% 
  as.tibble()

View(text_tbl)

# Tonekize the abstracts

tidy_block_chain <- text_tbl %>% 
  unnest_tokens(word, Abstract )

# Notice that:

#1- The default tokenization in unnest_tokens() is for single words
  
#2- Other columns, such as the title, are retained.

#3- Punctuation has been stripped.

#4- By default, unnest_tokens() converts the tokens to lowercase, which makes them easier to compare or combine with other datasets. (Use the to_lower = FALSE argument to turn off this behavior).

# Tonekize the bigrams?

?unnest_tokens

###### Stopwords #####

#  We can remove stop words (kept in the tidytext dataset stop_words)

# N.B. stopword lists (blacklists or bl) has to be engineered for the specific case you are working on. 

# In other words, making a bl for patents is different than making it for papers.

data(stop_words)

View(stop_words)

tidy_block_chain_filtered <- tidy_block_chain %>%
  filter(!(word %in% stop_words$word))


# what's inside
tidy_block_chain %>%
  filter((word %in% stop_words$word)) %>% 
  View()

# Which are other words that are actually black?

###### Count words #####

# We can also use dplyr’s count() to find the most common words in all the abstracts as a whole.

#Any problems??

tidy_block_chain_filtered %>%
  count(word, sort = TRUE) %>% 
  View()

tidy_block_chain %>%
  count(word, sort = TRUE) %>% 
  View()

# Let's use ggplot

tidy_block_chain_filtered %>%
  count(word, sort = TRUE) %>%
  filter(n > 200) %>%
  ggplot(aes(reorder(word,n), n)) +
  geom_col() +
  xlab(NULL) +
  coord_flip()


# data cleaning -----------------------------------------------------------

# Filter unwanted papers. How can we do that?

#ATTENTION: this method does not ensure total precision. 
# Typical exaple of data quality improvement trough analysis

# let's build a query
ok_topic <- or("bitcoin|cryptocurrency|transactions")

papers_block_chain_df <- papers_block_chain_df %>% 
  filter(str_detect(tolower(Abstract), ok_topic))

tidy_block_chain <- papers_block_chain_df %>% 
  unnest_tokens(word, Abstract)

tidy_block_chain_filtered <- tidy_block_chain %>%
  filter(!(word %in% stop_words$word))

tidy_block_chain_filtered %>%
  count(word, sort = TRUE) %>% 
  View()


# quick stringr lesson ----------------------------------------------------

##### stringr -------

library(tidyverse)
library(rebus)

# no need of sep="", it's default
str_c("a", "b")

# how it deals with NAs
str_c("a", NA)

str_replace_na(c("element1", NA, "element2"), replacement = "nothing")

# str_length()  takes a vector of strings as input and returns the number of characters in each string. 

str_length(c("Bruce", "Wayne")) 

# The str_sub() function in stringr extracts parts of strings based on their location.

str_sub(c("Bruce", "Wayne"), 1, 4)

str_sub(c("Bruce", "Wayne"), -4, -1)

#take first letters

str_sub(c("Bruce", "Wayne"), 1, 1)

#take last letters

str_sub(c("Bruce", "Wayne"), -1, -1)


######  Hunting for matches --------

# str_detect() is used to answer the question: Does the string contain the pattern? it takes in input a vector of strings and a pattern and it returns a logical vector with TRUE when the pattern is matched, FALSE otherwise

string <- c("strategy", "competitive intelligence", "data science")

str_detect(string, "te")

# str_subset() detects strings with a pattern and then subsets out those strings. Takes a vector in input and a pattern and filter only on those elements that matches the pattern. 

str_subset(string, "te")

# str_count() takes a vector of strings and a pattern and return a vector of counts of the pattern in the strings. 

str_count(string, "te")

###### Replacing matches in strings ------ 

str_replace("this is bad, so bad","bad", "good")

str_replace_all("this is bad, so bad","bad", "good")

##### regular expressions -------

# Let's have a look at REBUS

# print start

START

# Print END

END

# Some strings to practice with
x <- c("cat", "coat", "scotland", "tic toc", rep("this",200))

# the string view is a great tool to check the regex

# Run me
str_view(x, pattern = START %R% "c")

# Match the strings that start with "co" 
str_view(x, pattern = START %R% "co")

# Match the strings that end with "at"
str_view(x, pattern = "at" %R% END)

# Match the strings that is exactly "cat"
str_view(x, pattern = START %R% "cat" %R% END)

#OR

str_view(x, pattern = exactly("cat"))

# Match any character followed by a "t"
str_view(x, pattern = ANY_CHAR %R% "t")

# Match a "t" followed by any character
str_view(x, pattern = "t" %R% ANY_CHAR)

# Match two characters
str_view(x, pattern = ANY_CHAR %R% ANY_CHAR)

# Match a string with exactly three characters
str_view(x, pattern = START %R% ANY_CHAR %R% ANY_CHAR %R% ANY_CHAR %R% END)


# Automatically build query in or

str_view(x, pattern = or("a","o"))

#### Capturing ------

# captuer the part of the regular expresion that you want to extract
email <- capture(one_or_more(WRD)) %R% 
  "@" %R% one_or_more(WRD) %R% 
  DOT %R% one_or_more(WRD)

# Use str_match to extract it as a data.frame

str_match("(wolverine@xmen.com)", pattern =  email)  

###### Word frequencies#####

# A common task in text mining is to look at word frequencies, just like we have done above for the whole abstract corpus, and to compare frequencies across (for example) different year.

# Create corpus for 2017

block_chain_2017 <- tidy_block_chain_filtered %>% 
  filter(Year == 2017)

#Number of documents
block_chain_2017 %>%
  group_by(Title) %>% 
  nrow()
  

# most common words in 2017

block_chain_2017 %>%
  count(word, sort = TRUE)

# Create corpus for 2016

block_chain_2016 <- tidy_block_chain_filtered %>% 
  filter(Year == 2016)

#Number of documents
block_chain_2016 %>%
  group_by(Title) %>% 
  nrow()

# most common words in 2016

block_chain_2016 %>%
  count(word, sort = TRUE)


# Now, let’s calculate the frequency for each word for 2016 and 2017. 

# We need to bind the data frames together. 

# Then we can use spread and gather from tidyr to reshape our dataframe to transform it and finally plotting and comparing the two sets of papers.

# quick lesson about spread and gather


#spread
bind_rows(block_chain_2016,
          block_chain_2017) %>% 
  #count word per year
  count(Year, word) %>%
  group_by(Year) %>%
  mutate(proportion = n / sum(n)) %>% 
  select(-n) %>% 
  # spread: first value is what we want to make as columns
  # second value is the actual value of the elements
  spread(Year, proportion, fill = 0) %>% 
  rename(proportion_2016= `2016`,proportion_2017= `2017` ) %>% 
  View()

frequency <- bind_rows(block_chain_2016,
                       block_chain_2017) %>% 
  #count word per year
  count(Year, word) %>%
  group_by(Year) %>%
  mutate(proportion = n / sum(n)) %>% 
  select(-n) %>% 
  spread(Year, proportion, fill = 0) %>% 
  rename(proportion_2016= `2016`,proportion_2017= `2017` )

  
# gather --------

frequency %>% 
  # first value is the name of the new column (the output of the gathering, the container)
  # second value is the name of the new colums
  # third value is what i dont want to gather
  gather(year, proportion, -word)

# lets plot

p <- ggplot(frequency, aes(x = `2016`, y = `2017`, text= word)) +
  geom_abline(color = "gray40", lty = 2) +
  geom_jitter(alpha = 0.1, size = 2.5, width = 0.3, height = 0.3) +
  scale_x_log10(labels = percent_format()) +
  scale_y_log10(labels = percent_format()) +
  scale_color_gradient(limits = c(0, 0.001), low = "darkslategray4", high = "gray75") +
  theme(legend.position="none")

p

# Let's use ggplotly
ggplotly(p)

# Lemmatisation and POS tagging ----------------

View(papers_block_chain_df)

# Load a model. Put english-ud-2.0-170801.udpipe in your data folder.

udmodel <- udpipe_load_model(file = "data/english-ud-2.0-170801.udpipe")

# Give a text and an id as input

# ~5 mins to run......

# block_chain_pos <- udpipe_annotate(udmodel, x = papers_block_chain_df$Abstract, doc_id= papers_block_chain_df$Title) %>% 
#   as.tibble() %>% 
#   select(-(xpos:misc)) %>% 
#   select(- paragraph_id) %>% 
#   rename(Title = doc_id)

View(block_chain_pos)


# count most common nouns

block_chain_pos %>% 
  filter(upos == "NOUN") %>% 
  count(lemma, sort=TRUE) %>% 
  View()



# count most common verbs
block_chain_pos %>% 
  filter(upos == "VERB") %>% 
  count(lemma, sort=TRUE) %>% 
  View()


block_chain_pos %>% 
  filter(upos == "ADJ") %>% 
  count(lemma, sort=TRUE) %>% 
  top_n(10) %>% 
  View()

block_chain_pos %>% 
  filter(upos == "ADJ") %>% 
  count(token, sort=TRUE) %>% 
  top_n(10) %>% 
  View()



# Re-add all the info for each title

block_chain_all_info <- block_chain_pos %>% 
  inner_join(papers_block_chain_df)



##### Exercises -------------------

# Take in to consideration only the papers about blockchain (papers_block_chain_df and block_chain_all_info). 

# Generic...
# 1- Is there a trend in the paper for year?
# 2- Wich are the most common source title?
# 3- What is the distribution document type?
# 4- What is the distribution of the abstracts lengths (n. of words)?
# 5- Is there a trend in the number of citations per year? 

# Text...
# 6- How many different words are in the corpus? 
# 7- Which are the top10 adjectives in terms of occurrency?

# 8- Is there a trend in the nouns usage?
# 9- Is there a trend in the verbs usage?
# 10- How can you improve the blacklist in the case of paper analysis?








