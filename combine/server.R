library(shiny)
library(shinydashboard)
library(ape)
library(RCurl)
library(RMySQL)
options(stringsAsFactors = F)

ucsc.host="genome-mysql.cse.ucsc.edu";
ucsc.user="genome";
ucsc.password=""; 

createLink <- function(link,char) {
  sprintf('<a href="%s" target="_blank" class="btn btn-primary">%s</a>',link,char)
}

shinyServer(function(input, output, session){
  get_all_UCSC_tables <- reactive({
    db=input$ChooseUCSCdb
    if(db=='hg19'){
      UCSC_all_hg19_tables=read.table("txt_files/UCSC_all_hg19_tables.txt",header = T)
      UCSC_all_hg19_tables
    }else{
      con_UCSC <- dbConnect(MySQL(), host=ucsc.host, user=ucsc.user,dbname=db)
      all_hg19_tables=dbListTables(con_UCSC)
      dbDisconnect(con_UCSC)
      all_hg19_tables=all_hg19_tables[!grepl('wgEncode',all_hg19_tables)]
      all_hg19_tables
    }
  })
  output$chooseUCSCtable <- renderUI({
    selectizeInput("ChooseUCSCtable","选择表",
                width='80%',
                choices = get_all_UCSC_tables()
    ) 
  }) 
  get_UCSC_results <- eventReactive(input$UCSC_search,{
    db=input$ChooseUCSCdb
    con_UCSC <- dbConnect(MySQL(), 
                          host=ucsc.host, user=ucsc.user,dbname=db)
    if (input$ChooseUCSCrow == 'ALL'){
      tmp=dbGetQuery(con_UCSC,paste0("select * from ",input$ChooseUCSCtable)
                      )    
    }else{
      tmp=dbGetQuery(con_UCSC,paste("select * from ",input$ChooseUCSCtable,
                                    "limit ",input$ChooseUCSCrow,
                                    sep=" "))
    }
 
    dbDisconnect(con_UCSC)
    tmp
  })
  output$UCSC_results <- DT::renderDataTable({
    get_UCSC_results()
    },extensions = 'FixedColumns',
    options = list(
      scrollX = TRUE,
      fixedColumns = list(leftColumns = 2, rightColumns = 1)
    )
  )
  
  
})