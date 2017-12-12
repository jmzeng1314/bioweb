library(shinydashboard)
library(shiny)
options(stringsAsFactors = F)
TCGA_all_case=read.csv('all_TCGA_studies.csv')

page_Home <- fluidPage(
  
)
page_Data <- fluidPage( 
  textOutput('tmp'),
  box(title = paste0("至今",Sys.Date(),"共有168个case studies"),
      solidHeader = T,status = 'success',collapsible = T,width = NULL,
      
      DT::datatable(TCGA_all_case,escape=F,options = list( 
        pageLength = 5,
        lengthMenu = c(5, 10, 15, 20)
      ),## end for options
      callback = DT::JS(
        "table.on('click.dt', 'tr', function() {
        $(this).toggleClass('selected');
        Shiny.onInputChange('TCGA_all_case_selected',
        table.rows('.selected').data().toArray());
        });") ## end for callback
      
      )## end for DT
  ),
  p("你需要从上面的126个case studies任意选择一个进行下面的分析！",align='center'),
  box(title = paste0("该study共有以下几种样本列表可以选取"),
      solidHeader = T,status = 'success',collapsible = T,width = NULL,
      DT::dataTableOutput('sample_list')
  ), 
  p("你需要从上面样本列表选择一个或者多个来进行下面的分析！",align='center'),
  box(title = paste0("该study共有以下几种数据可以获取"),
      solidHeader = T,status = 'success',collapsible = T,width = NULL,
      p('最后一列是样本列表，但是样本数太多，表格会很丑，所以不予显示，你只需要选择一个列表即可！'),
      DT::dataTableOutput('DataList')
  ), 
  p("根据你选择的样本列表和你想获取的数据类型,我们的结果如下:",align='center'),
  box(title = paste0("获取到的遗传数据"),
      solidHeader = T,status = 'success',collapsible = T,width = NULL,
      flowLayout(
        textInput('type_gene',label='',
                  placeholder = '请输入一个gene symbol',width = '80%'),
        div(br(),actionButton('search_genomic','搜索'))
      ),
      DT::dataTableOutput('genomic_results')
  ) 
)
page_About <- fluidPage(
  
)
header=dashboardHeader(
  title =p("TCGA数据库！"
           ,style="font-size:90%;font-style:oblique"
  )
)
sidebar = dashboardSidebar(
  conditionalPanel(
    condition = "1",
    sidebarMenu(
      id = "tabs",
      hr(),
      menuItem("TCGA数据库简介",tabName = "Home",icon = icon("home")),
      menuItem("数据探索",    tabName = "Data",icon = icon("flask")),
      menuItem("About", tabName = "About", icon = icon("info-circle"))
    ) ## end for sidebarMenu
  ) ## end for conditionalPanel
) ## end for dashboardSidebar

body=dashboardBody(
  tabItems(
    tabItem(tabName = "Home",page_Data ),
    tabItem(tabName = "Data",page_Home), 
    tabItem(tabName = "About",page_About)
  ) 
)

shinyUI(
  dashboardPage(
    header,
    sidebar,
    body,
    title = 'TCGA-database'
  )
)



