install.packages(c("httr", "XML"))

source("scopusAPI.R")
library(tidyverse)
library(udpipe)

# download scopus paper -----------------------------------------------------

query <- 'TITLE-ABS-KEY (("team working"  OR  "Public speaking"  OR  "Active listening" )  AND  ( "skill"  OR  "ability"  OR  "competence"  OR  "competency" ))' 

xml_output <- searchByString(string = query, outfile = "output_data/testdata.xml")

xml_output <- read_lines("output_data/testdata.xml")

paper_table <- extractXML(xml_output) 



# text preprocessing ---------------------------------------

# DONT RUN

udmodel <- udpipe_load_model(file = "input_data/english-ud-2.0-170801.udpipe")

paper_metadata <- paper_table %>% 
  select(-abstract)

sentences <- udpipe_annotate(udmodel, x = paper_table$abstract, doc_id= paper_table$articletitle) %>%
  as.tibble() %>%
  rename(title = doc_id)


write_delim(sentences, "output_data/tokenized_text.csv", delim= "\t")

sentences <- read_delim("output_data/tokenized_text.csv", delim= "\t")

# chunking ---------------------------------------

# DONT RUN

stats <- keywords_phrases(x = sentences$xpos, term = tolower(sentences$lemma),
                          pattern = "(JJ)*(NN(S|P)?)*(HYPH)*(JJ)*(NN(S|P)?)*(VB)*(RP)*",
                          is_regex = TRUE, detailed = TRUE) %>%
  as.tibble() %>%
  arrange(start, -ngram) %>%
  filter(!duplicated(start)) %>%
  filter(!duplicated(end)) %>%
  # the pattern can be improved insterting PUNCT between nouns (co-operation) and numricals (6 sigma)
  filter(!(pattern %in% c("VB", "HYPH", "HYPHJJ", "JJ", "JJHYPH"))) %>% 
  rename(id_lemma = start)

write_delim(stats, "output_data/stats.csv", delim= "\t")

stats <- read_delim("output_data/stats.csv", delim= "\t")






