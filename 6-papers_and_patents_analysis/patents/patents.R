install.packages("rvest")

source("patents_functions.R")

tech_vector <- read_lines(file = "technimeter_demo.txt")[1:10]

tech_table <- tibble(
  technology= sort(rep(tech_vector,10)),
  year= rep(c(2007:2016), length(tech_vector)),
  n_of_patents = rep(0,length(tech_vector)*10)
  
)

for (i in 1:nrow(tech_table)){
  
  tech_table[i, "n_of_patents"] <- patent_count(tech_table[i, "technology"], tech_table[i, "year"])
  
  print(i)
  
}


write_csv(tech_table, "tech_table.csv")





# Test per tommy

link <- "http://www.freepatentsonline.com/result.html?p=1&edit_alert=&srch=xprtsrch&query_txt=%22data+science%22&uspat=on&usapp=on&eupat=on&date_range=all&stemming=on&sort=relevance&search=Search"

page <- read_html(link)

html_nodes(page,".rowalt:nth-child(2) a")


