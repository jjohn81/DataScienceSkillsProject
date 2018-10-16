require(plyr)
require(tidyr)
require(dplyr)
 data <- read.csv('2017q1.csv') 
 
 
 
   skills_title <- data %>%select( starts_with('skill') )    %>%
     gather(3:10,  value = "skill") %>%
    select( starts_with('skill'))   %>%
    filter(skill != '') %>% 
      distinct()
   
   job_titles <- data %>%select(  1)  %>%
     filter(title != '')   %>% 
    distinct()  
  
   names(job_titles) <- c('job_name')
   names(skills_title) <- c('skill_name')
   
   con <- dbConnect(sqlite, "jobs.db")
   dbBegin(con)
   dbWriteTable(con, 'Jobs', job_titles, append =T)
   dbWriteTable(con, 'skills', skills_title, append =T)
    
   dbCommit(con)
  
    jobs <- dbReadTable(con, 'Jobs')
   
   skills <- dbReadTable(con, 'skills')
   
   
   jobs_titles_long <- data %>%
     gather(3:10,  key = "xyz" ,value = "skill_name") %>%
     filter(title != '' & skill_name != '')   %>%  
    select( 'title', 'skill_name')
   
   names(jobs_titles_long) <- c('job_name','skill_name')
   jobs_skills_mapping <- jobs_titles_long%>% 
                          inner_join(jobs, by= c('job_name') )  %>% 
                inner_join(skills, by=c('skill_name') ) %>%
                select(job_id, skill_id)
   
   
            
   db_write_table(con, 'job_skills', jobs_skills_mapping)
   
 
   
   
   
   
   
    