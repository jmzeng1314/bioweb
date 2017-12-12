library(shiny)
library(shinydashboard)
library(cgdsr)
library(shinyjs)
mycgds <- CGDS("http://www.cbioportal.org/public-portal/")

library(RMySQL)
options(stringsAsFactors = F)
createLink <- function(link,char) {
  sprintf('<a href="%s" target="_blank" class="btn btn-primary">%s</a>',link,char)
}

shinyServer(function(input, output, session){
  get_selected_case <- reactive({
    if (is.null(input$TCGA_all_case_selected))
      return(NULL)
    this_case=input$TCGA_all_case_selected[2]
    this_case
  })
  get_selected_sampleList <- reactive({
    if (is.null(input$sample_list_selected))
      return(NULL)
    this_case=input$sample_list_selected[2]
    this_case
  })
  get_genomic_data <- eventReactive(input$search_genomic,{
    gene=input$type_gene
    sampleList=get_selected_sampleList()
    this_case=get_selected_case()
    all_dataset <- getGeneticProfiles(mycgds, this_case)
    dataSet=all_dataset[input$DataList_rows_selected,1]
    tmp=getProfileData(mycgds,gene,dataSet,sampleList)
    ##getProfileData(mycgds, "BRCA1",
    ##              c('stad_tcga_gistic','stad_tcga_mutations'),'stad_tcga_all')
    cat(file=stderr(),paste(gene,dataSet,sampleList,sep="\n"))
    tmp
  })
  output$sample_list <- DT::renderDataTable({
    this_case=get_selected_case()
    if (is.null(this_case))
      return(iris)
    all_tables <- getCaseLists(mycgds, this_case)
    all_tables=all_tables[,-ncol(all_tables)]
    DT::datatable(all_tables,options = list( 
      pageLength = 5,
      lengthMenu = c(5, 10, 15, 20)
    ),## end for options
    callback = JS(
      "table.on('click.dt', 'tr', function() {
      $(this).toggleClass('selected');
      Shiny.onInputChange('sample_list_selected',
      table.rows('.selected').data().toArray());
      });") ## end for callback
    )## end for datatable
  })
  output$DataList <- DT::renderDataTable({
    this_case=get_selected_case()
    if (is.null(this_case)) 
      return(iris)
     
    all_dataset <- getGeneticProfiles(mycgds, this_case)
    DT::datatable(all_dataset, extensions = 'FixedColumns',
                  options = list(
                    scrollX = TRUE,
                    fixedColumns = TRUE
                  )
   )
    
   
  })
  output$genomic_results <- DT::renderDataTable({
     genomicData=get_genomic_data()
    if (is.null(genomicData)){
      return(NULL)
    }else{
      genomicData
    }
  })
  
})