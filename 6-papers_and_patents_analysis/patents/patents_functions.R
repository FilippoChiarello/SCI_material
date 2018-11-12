library(rvest)


##### patent_count -----------------

patent_count <- function(query,year=FALSE){
  
  # the parameter query has to be inputed using single quotes ' instead of double quotes "
  
  query <- query %>% 
    str_replace_all("(?<=[\\s])\\s*|^\\s+|\\s+$", "")	%>% 
    str_replace_all(" AND ", dQuote(")+AND+(")) %>% 
    str_replace_all(" OR ", dQuote("+OR+")) %>% 
    str_replace_all(" |_","+") %>% 
    dQuote() %>% 
    str_replace_all("^","(") %>% 
    str_replace_all("$",")") %>% 
    str_replace_all("“","%E2%80%9C") %>% 
    str_replace_all("”","%E2%80%9C")
  
  
  link <- paste("http://www.freepatentsonline.com/result.html?p=1&edit_alert=&srch=xprtsrch&query_txt=",query,"&uspat=on&usapp=on&eupat=on&date_range=all&stemming=on&sort=relevance&search=Search",sep="")

  
  if(year!=FALSE){
    
    link <- paste("http://www.freepatentsonline.com/result.html?p=1&edit_alert=&srch=xprtsrch&query_txt=APD%2F",year,"+",query,"&uspat=on&usapp=on&eupat=on&date_range=all&stemming=on&sort=relevance&search=Search",sep="")}

  page <- read_html(link)
  
  n_patents <- html_nodes(page,"#results .well-small td:nth-child(1)")
  
  n_patents <- gsub(".*of ","",n_patents)
  
  n_patents <- as.numeric(gsub(" .*</td>","",n_patents))
  
  if(length(n_patents)==0){n_patents <- 0}
  
  
  return (n_patents)}

##### patent_trend -----------------

patent_trend <- function(query, year_start, year_end){
  
  year_vector <- vector(mode = "numeric",length = year_end-year_start+1)
  
  for(i in seq_along(year_vector)){
    year_vector[i] <- patent_count(query, year_start+i-1)
    
  }
  
  return(year_vector)
  
}



